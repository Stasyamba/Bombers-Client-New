/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package loading {
import greensock.events.LoaderEvent
import greensock.loading.ImageLoader
import greensock.loading.LoaderStatus
import greensock.loading.SWFLoader
import greensock.loading.core.LoaderCore

public class LoadedObject {
    private var _loaded:Boolean
    private var _loader:LoaderCore
    private var _id:String
    private var _content:*
    private var _contentType:LoadedContentType

    public function LoadedObject(id:String, loader:LoaderCore) {
        _loader = loader
        _id = id
        if (loader.status == LoaderStatus.COMPLETED)
            onLoaded()
        else
            _loader.addEventListener(LoaderEvent.COMPLETE, function(e:LoaderEvent) {
                trace("loaded child " + _id)
                onLoaded()
            })
    }

    private function onLoaded():void {
        _loaded = true
        if (_loader is SWFLoader) {
            _content = (_loader as SWFLoader).rawContent
            _contentType = LoadedContentType.SWF
        } else if (_loader is ImageLoader) {
            _content = (_loader as ImageLoader).rawContent
            _contentType = LoadedContentType.IMAGE
        }
    }

    public function get id():String {
        return _id;
    }

    public function get content():* {
        return _content;
    }

    public function get loaded():Boolean {
        return _loaded;
    }

    public function get contentType():LoadedContentType {
        return _contentType
    }

    public function swfClass(name:String):Class {
        if (_contentType != LoadedContentType.SWF)
            throw Context.Exception("Error in LoadedObject.as: swfClass is only accessible for swf loaders");
        if (!_loaded)
            throw Context.Exception("Error in LoadedObject.as: content " + _id + " is not loaded yet");
        var res:Class = (_loader as SWFLoader).getClass(name)
        if (res == null) {
            throw Context.Exception("Error in LoadedObject.as: didn't find class " + name + " in object with id = " + _id);
        }
        return res;
    }
}
}
