package utils;

import core.structures.DataJson;

import haxe.ds.StringMap;

class CoolVars
{
    public static var data:DataJson = null;

    public static var onlineVersion:String = '';

    public static var engineVersion:String = '';

    public static var skipTransIn:Bool = false;
    public static var skipTransOut:Bool = false;

    @:allow(core.config.MainState)
    @:allow(funkin.debug.DebugCounter)
    private static var mustUpdate:Bool = false;

    @:allow(cpp.WindowsTerminalCPP)
    private static var isConsoleVisible:Bool = false;

    @:allow(cpp.WindowsCPP)
    private static var windowLayered:Bool = false;

    public static var globalVars:StringMap<Dynamic> = new StringMap<Dynamic>();
}