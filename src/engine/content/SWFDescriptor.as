package engine.content {
public class SWFDescriptor {

    private var _swfClass:Class;

    private var _className:String;

    public function SWFDescriptor(swfClass:Class, className:String) {
        _swfClass = swfClass
        _className = className
    }

    public function get swfClass():Class {
        return _swfClass
    }

    public function get className():String {
        return _className
    }
}
}
