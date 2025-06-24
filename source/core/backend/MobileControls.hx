package core.backend;

import flixel.input.keyboard.FlxKey;

import funkin.visuals.mobile.MobileButton;

class MobileControls
{
    @:allow(funkin.visuals.mobile.MobileButton)
    @:allow(utils.CoolUtil)
    @:unreflective
    private static final _controlsMap:Map<FlxKey, MobileButton> = new Map<FlxKey, MobileButton>();

    public static function anyJustPressed(keys:Array<Int>):Bool
    {
        var retVal:Bool = false;
    
        for (key in keys)
            if (_controlsMap.exists(key))
                if (_controlsMap.get(key).justPressed)
                    retVal = true;
    
        return retVal;
    }
    
    public static function anyJustReleased(keys:Array<Int>):Bool
    {
        var retVal:Bool = false;
    
        for (key in keys)
            if (_controlsMap.exists(key))
                if (_controlsMap.get(key).justReleased)
                    retVal = true;
    
        return retVal;
    }
    
    public static function anyPressed(keys:Array<Int>):Bool
    {
        var retVal:Bool = false;
    
        for (key in keys)
            if (_controlsMap.exists(key))
                if (_controlsMap.get(key).pressed)
                    retVal = true;
    
        return retVal;
    }
}