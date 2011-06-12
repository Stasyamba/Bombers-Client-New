/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.games.quest {
import components.common.base.access.rules.medalrule.AccessMedalRule

import components.common.quests.medals.MedalType

import engine.games.quest.goals.GoalsBuilder
import engine.games.quest.goals.IGoal
import engine.games.quest.medals.Medal
import engine.games.quest.medals.MedalBase

import mx.collections.ArrayCollection

public class EngineQuestObject {

    private var _xml:XML

    private var _commonGoal:IGoal

    private var _goldMedal:MedalBase
    private var _silverMedal:MedalBase
    private var _bronzeMedal:MedalBase

    private var _timeLimit:Number


    public var best:Array
    public var medalsEarned:int

    private var _accessRules:Array = new Array()

    public function hasMedal(medal:Medal):Boolean {
        return (medalsEarned & medal.value) != 0
    }

    public function EngineQuestObject(xml:XML) {
        _xml = xml;

        if (xml.medals.goal[0] != null) {
            _commonGoal = GoalsBuilder.makeFromXml(xml.medals.goal[0])
        }

        _bronzeMedal = Medal.fromXml(xml.medals.Bronze[0])
        _silverMedal = Medal.fromXml(xml.medals.Silver[0])
        _goldMedal = Medal.fromXml(xml.medals.Gold[0])

        _timeLimit = xml.timeLimit

        //access rules
        if( xml.accessRules.AllBefore.length() > 0){
            _accessRules.push(new AccessMedalRule(id,null,0,true))
        }else if(xml.accessRules.CountMedals.length() > 0) {
            var cm:XML = xml.accessRules.CountMedals[0]
            _accessRules.push(new AccessMedalRule(id,MedalType.byValue(int(cm.@type)),int(cm.@count)))
        }
    }

    public function get name():String {
        return _xml.name
    }

    public function get description():String {
        return _xml.description
    }

    public function get id():String {
        return _xml.id
    }

    public function get energyCost():int {
        return int(_xml.energyCost)
    }

    public function get locationId():int {
        return int(_xml.location)
    }


    //seconds. zero means no limit
    public function get timeLimit():Number{
        return _timeLimit
    }

    public function get goldMedal():MedalBase {
        return _goldMedal
    }

    public function get silverMedal():MedalBase {
        return _silverMedal
    }

    public function get bronzeMedal():MedalBase {
        return _bronzeMedal
    }

    public function get imageURL():String {
        return _xml.questImage
    }

    public function get previewImageURL():String {
        return _xml.previewImage
    }

    public function get accessRules():Array {
        return _accessRules
    }

    public function get finishOnGoal():Boolean {
         return _xml.finishOnGoal.length() > 0
    }

    public function get hasCommonGoal():Boolean{
        return _commonGoal != null
    }

    public function get commonGoal():IGoal{
        return _commonGoal
    }
}
}
