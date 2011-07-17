/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package loading {
import components.common.items.ItemType
import components.common.worlds.locations.LocationType

import engine.bombers.BomberType
import engine.games.quest.monsters.MonsterType

import flash.display.MovieClip
import flash.system.ApplicationDomain
import flash.system.LoaderContext
import flash.utils.Dictionary

import greensock.events.LoaderEvent
import greensock.loading.LoaderMax
import greensock.loading.LoaderStatus
import greensock.loading.MP3Loader
import greensock.loading.SWFLoader
import greensock.loading.XMLLoader
import greensock.loading.core.LoaderCore
import greensock.loading.data.LoaderMaxVars
import greensock.loading.data.MP3LoaderVars
import greensock.loading.data.SWFLoaderVars
import greensock.loading.data.XMLLoaderVars

import org.osflash.signals.Signal

public class BombersContentLoader {

    private static const IMAGES_ADDRESS:String = "http://www.vensella.ru/vp/images/"
    private static const QUESTS_ADDRESS:String = "http://www.vensella.ru/vp/quests/"
    private static const MONSTERS_ADDRESS:String = "http://www.vensella.ru/vp/monsters/monsters.xml"
    private static const BOMBERS_ADDRESS:String = "http://www.vensella.ru/vp/bombers/bombers.xml"

    private static var _filesXml:XML
    private static var _whatIsLoaded:Dictionary = new Dictionary()
    private static var _loadedGraphics:Dictionary = new Dictionary()
    private static var _monstersXml:XML
    private static var _bombersXml:XML

    public static var locationGraphicsLoaded:Signal = new Signal(LocationType)
    public static var bomberGraphicsLoaded:Signal = new Signal(BomberType)
    public static var commonGraphicsLoaded:Signal = new Signal()
    public static var allBombersGraphicsLoaded:Signal = new Signal()


    public static var readyToUseAppView:Signal = new Signal()

    // bombers
    public static var bomberTypesLoaded:Signal = new Signal()

    private static var _areBomberTypesLoaded:Boolean


    public static function loadBombers():void {
        var xmlLoader:XMLLoader = new XMLLoader(BOMBERS_ADDRESS,
                new XMLLoaderVars()
                        .onComplete(onBombersXmlComplete)
                        .onError(onBombersXmlError)
                        .noCache(true))
        xmlLoader.load()
    }

    private static function onBombersXmlError(e:LoaderEvent):void {
        throw Context.Exception("Error in file BombersContentLoader.as : error loading bombers description: " + e.text)
    }

    private static function onBombersXmlComplete(e:LoaderEvent):void {
        _bombersXml = (e.target as XMLLoader).content
        for each (var b:XML in _bombersXml.B) {
            //todo: access rules parsing
            var accessRules:Array = new Array()
            var bt:BomberType = new BomberType(b.@id, b.@name, ItemType.byValue(b.@bombId), b.@bombCount, b.@bombPower, b.@speed, b.@life, b.@crit, b.@block, b.@immortalTime, b.@graphicsId, accessRules, b.@description, b.@bigImageURL)
            BomberType.add(bt)
        }
        _areBomberTypesLoaded = true
        bomberTypesLoaded.dispatch()
        if (_areQuestsLoaded)
            readyToUseAppView.dispatch()
    }

    // Quests

    private static var _areQuestsLoaded:Boolean = false
    private static var _questXmls:Array = new Array()
    private static var _questsNames:Array = new Array()

    public static var questsLoaded:Signal = new Signal()

    public static function get areQuestsLoaded():Boolean {
        return _areQuestsLoaded
    }

    public static function get questsNames():Array {
        return _questsNames
    }

    public static function loadQuests():void {
        var questsXmlLoader:XMLLoader = new XMLLoader(QUESTS_ADDRESS + "quests.xml",
                new XMLLoaderVars()
                        .onComplete(onQuestsXmlComlete)
                        .onError(onQuestsXmlError)
                        .noCache(true))
        questsXmlLoader.load()
    }

    private static function onQuestsXmlError(e:LoaderEvent):void {
        throw Context.Exception("Error in file BombersContentLoader.as :error loading quests description: " + e.text)
    }

    public static function onQuestsXmlComlete(e:LoaderEvent):void {
        var _questsXml:XML = (e.target as XMLLoader).content

        var queue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .name("quests")
                .onComplete((
                function(e:LoaderEvent) {
                    trace("quests loaded")
                    _areQuestsLoaded = true
                    questsLoaded.dispatch()
                    if (_areBomberTypesLoaded)
                        readyToUseAppView.dispatch()
                }))
                .onError(
                function(e:LoaderEvent) {
                    throw Context.Exception("Error in file BombersContentLoader.as :Error loading quests: " + e.target.text)
                })
        )

        for each (var quest:XML in _questsXml.quest) {
            var name:String = quest.@name;
            _questsNames.push(name)
            queue.append(new XMLLoader(name + ".xml", new XMLLoaderVars()
                    .name(name)
                    .noCache(true)
                    .onError(
                    function(e:LoaderEvent) {
                        throw Context.Exception("Error in file BombersContentLoader.as: Error loading quest " + e.target.name + ": " + e.text)
                    })
                    .onComplete(
                    function(e:LoaderEvent) {
                        trace("quest " + name + " loaded")
                        _questXmls[e.target.name] = e.target.content
                    })))
        }
        queue.prependURLs(QUESTS_ADDRESS)
        queue.load()
    }

    public static function questXML(questId:String):XML {
        return _questXmls[questId]
    }

    // monsters
    public static function loadMonsters():void {
        var xmlLoader:XMLLoader = new XMLLoader(MONSTERS_ADDRESS,
                new XMLLoaderVars()
                        .onComplete(onMonstersXmlComplete)
                        .onError(onMonstersXmlError)
                        .noCache(true))
        xmlLoader.load()
    }

    private static function onMonstersXmlError(e:LoaderEvent):void {
        throw Context.Exception("Error in file BombersContentLoader.as: error loading monsters description: " + e.text)
    }

    private static function onMonstersXmlComplete(e:LoaderEvent):void {
        _monstersXml = (e.target as XMLLoader).content
        for each (var m:XML in _monstersXml.M) {
            MonsterType.add(new MonsterType(m.@id, m.@graphicsId, m.@speed, m.@life, m.@immortalTime, m.@damage, m.@name))
        }
    }

    // graphics
    public static function loadGraphics():void {
        var xmlLoader:XMLLoader = new XMLLoader(IMAGES_ADDRESS + "engine/files.xml",
                new XMLLoaderVars()
                        .onComplete(onGraphicsXmlComplete)
                        .onError(onGraphicsXmlError)
                        .noCache(true))
        xmlLoader.load()
    }

    private static function onGraphicsXmlError(e:LoaderEvent):void {
        throw Context.Exception("Error in file BombersContentLoader.as: Error loading files.xml: " + e.text)
    }

    private static function commonHelper(subGroup:String, comQueue:LoaderMax):void {

        var comAddr:String = IMAGES_ADDRESS + _filesXml.common.@addr
        for each (var file:XML in (_filesXml.common as XMLList).descendants(subGroup).File) {

            var fname:String = file.@name
            var faddr:String = comAddr + subGroup + "/" + fname + file.@ext
            var fid:String = "common." + subGroup + "." + fname
            var ldr:LoaderCore = LoaderMax.parse(faddr,
                    new LoaderMaxVars()
                            .onError(function (e:LoaderEvent):void {
                        throw Context.Exception("Error in file BombersContentLoader.as: Error loading file " + e.target.name + ": " + e.text)
                    })
                            .name(fid))
            if (ldr is SWFLoader) {
                ldr.vars.context = new LoaderContext(false, ApplicationDomain.currentDomain)
                ldr.vars.noCache = true;
            }
            comQueue.append(ldr)
            trace("added common: " + fid)
            _loadedGraphics[fid] = new LoadedObject(fid, ldr)
        }
    }

    private static function onGraphicsXmlComplete(e:LoaderEvent):void {

        _filesXml = (e.target as XMLLoader).content

        //common
        var comQueue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .onError(
                function (e:LoaderEvent):void {
                    throw Context.Exception("Error in file BombersContentLoader.as: Error loading common folder: " + e.text)
                })
                .onComplete(
                function (e:LoaderEvent):void {
                    whatIsLoaded["common"] = true
                    commonGraphicsLoaded.dispatch()
                    trace("common loaded")
                })
                .name("common")
        )
        commonHelper("DO", comQueue)
        commonHelper("map", comQueue)
        commonHelper("explosions", comQueue)
        commonHelper("healthBar", comQueue)
        commonHelper("other", comQueue)
        commonHelper("bombers", comQueue)

        //locations
        var locationsQueue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .onError(
                function (e:LoaderEvent):void {
                    throw Context.Exception("Error in file BombersContentLoader.as: Error loading locations: " + e.text)
                })
                .onComplete(
                function (e:LoaderEvent):void {
                    whatIsLoaded["locations"] = true
                    trace("locations loaded")
                })
                .name("locations")
        )
        var locsAddr:String = IMAGES_ADDRESS + _filesXml.locations.@addr

        for each (var location:XML in _filesXml.locations.Location) {
            var loc_id:String = location.@id
            var locAddr:String = locsAddr + loc_id + "/"
            var locLdr:LoaderMax = new LoaderMax(new LoaderMaxVars()
                    .onError(
                    function (e:LoaderEvent):void {
                        throw Context.Exception("Error in file BombersContentLoader.as: Error loading location " + e.target.name + ": " + e.text)
                    })
                    .onComplete(
                    function (e:LoaderEvent):void {
                        whatIsLoaded[e.target.name] = true
                        trace("location Loaded: " + e.target.name)
                        locationGraphicsLoaded.dispatch(LocationType.byStringId(e.target.name))
                    })
                    .name(loc_id)
            )
            for each (var fldr:XML in location.Folder) {
                var fldrName:String = fldr.@name
                var fldrLdr:LoaderMax = new LoaderMax(new LoaderMaxVars()
                        .onError(
                        function (e:LoaderEvent):void {
                            throw Context.Exception("Error in file BombersContentLoader.as: Error loading fldr " + e.target.name + ": " + e.text)
                        })
                        .onComplete(
                        function (e:LoaderEvent):void {
                            trace("fldr Loaded: " + e.target.name)
                        })
                        .name(loc_id + "." + fldrName)
                )
                for each (var file:XML in fldr.File) {
                    var fname:String = file.@name
                    var faddr:String = locAddr + fldrName + "/" + fname + file.@ext
                    var fid:String = loc_id + "." + fldrName + "." + fname
                    var ldr:LoaderCore = LoaderMax.parse(faddr,
                            new LoaderMaxVars()
                                    .onError(
                                    function (e:LoaderEvent):void {
                                        throw Context.Exception("Error in file BombersContentLoader.as: Error loading file " + e.target.name + ": " + e.text)
                                    })
                                    .name(fid))
                    fldrLdr.append(ldr)
                    _loadedGraphics[fid] = new LoadedObject(fid, ldr)
                }

                locLdr.append(fldrLdr)
            }

            locationsQueue.append(locLdr)
        }

        //all
        var allLdr:LoaderCore = LoaderMax.parse([comQueue,locationsQueue],
                new LoaderMaxVars()
                        .onError(
                        function (e:LoaderEvent):void {
                            throw Context.Exception("Error in file BombersContentLoader.as: Error loading all: " + e.text)
                        })
                        .onComplete(
                        function (e:LoaderEvent):void {
                            whatIsLoaded["all"] = true
                            trace("engine loaded")
                        })
                        .name("engine")
        )

        allLdr.load()
    }

    public static function get whatIsLoaded():Dictionary {
        return _whatIsLoaded
    }

    public static function get loadedGraphics():Dictionary {
        return _loadedGraphics
    }

    //creatures swf

    //BO swf
    public static const BO_SWF_ADDRESS:String = "http://www.vensella.ru/eg/gate.swf"
    public static var boSwf:MovieClip

    public static function loadBO():void {
        var l:SWFLoader = new SWFLoader(BO_SWF_ADDRESS, new SWFLoaderVars()
                .name("bo_swf")
                .context(new LoaderContext(false, ApplicationDomain.currentDomain))
                .noCache(true)
                .onComplete(
                function(e:LoaderEvent):void {
                    boSwf = (e.target as SWFLoader).rawContent
                    if (boSwf == null)
                        throw Context.Exception("Error in file BombersContentLoader.as: couldn't find boSwf at " + BO_SWF_ADDRESS)
                })
                .onError(
                function(e:LoaderEvent):void {
                    throw Context.Exception("Error in file BombersContentLoader.as: error loading bo swf: " + e.text)
                }))
        l.load()
    }

    //tasks
    public static function addTask(taskSignal:Signal, array:Array):void {
        var taskObj:Object = new Object()
        for (var i:int = 0; i < array.length; i++) {
            var id:String = String(array[i])
            taskObj[id] = Context.imageService.isLoaded(id)
            if (!taskObj[id]) {
                var ldr:LoaderCore = LoaderMax.getLoader(id)
                if (ldr == null)
                    throw Context.Exception("Error in file BombersContentLoader.as: no loader with id = " + id)
                if (ldr.status == LoaderStatus.COMPLETED) //'completed' already fired but not handled
                    taskObj[id] = true
                else
                    ldr.addEventListener(LoaderEvent.COMPLETE, function (e:LoaderEvent):void {
                        taskObj[e.target.name] = true
                        checkTask(taskSignal, taskObj)
                    })
            }
        }
        checkTask(taskSignal, taskObj)
    }

    private static function checkTask(taskSignal:Signal, taskObj:Object):void {
        for each(var loaded:Boolean in taskObj) {
            if (!loaded)
                return
        }
        taskSignal.dispatch()
    }

    //sounds
    private static const SOUNDS_ADDRESS:String = "http://www.vensella.ru/vp/sounds/"
    private static const _soundsNames:Array = [
        "03",
        "windowMoveOpen",
        "bg",
        "button_30",
        "button_46",
        "battle1"
    ]

    public static function loadSounds():void {

        var queue:LoaderMax = new LoaderMax(new LoaderMaxVars()
                .name("sounds")
                .onComplete((
                function(e:LoaderEvent) {
                    trace("all sounds loaded")
                    soundsLoaded.dispatch();
                }))
                .onError(
                function(e:LoaderEvent) {
                    throw Context.Exception("Error in file BombersContentLoader.as: Error loading sounds: " + e.target.text)
                })
        )
        for each (var name:String in _soundsNames) {
            queue.append(new MP3Loader(name + ".mp3", new MP3LoaderVars()
                    .name(name + ".mp3")
                    .noCache(true)
                    .autoPlay(false)
                    .onError(
                    function(e:LoaderEvent) {
                        throw Context.Exception("Error in file BombersContentLoader.as: Error loading sound " + e.target.name + ": " + e.text)
                    })
                    .onComplete(
                    function(e:LoaderEvent) {
                        trace("sound " + name + " loaded")
                        _sounds[e.target.name] = e.target
                    })))
        }
        queue.prependURLs(SOUNDS_ADDRESS)
        queue.load()
    }

    private static var _sounds:Object = new Object()

    public static var soundsLoaded:Signal = new Signal();

    public static function sound(file:String):MP3Loader {
        return _sounds[file]
    }

    //management

    public static function stopAll():void {
        (LoaderMax.getLoader("engine") as LoaderCore).dispose();
        (LoaderMax.getLoader("sounds") as LoaderCore).dispose();
    }
}
}
