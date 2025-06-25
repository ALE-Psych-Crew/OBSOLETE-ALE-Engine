package core.backend;

import core.structures.UIControls;
import core.structures.NotesControls;
import core.structures.EngineControls;

class Controls
{
    // Notes

    public static var NOTE_LEFT(get, never):Bool;
    static function get_NOTE_LEFT():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.notes.left);

    public static var NOTE_LEFT_P(get, never):Bool;
    static function get_NOTE_LEFT_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.notes.left);

    public static var NOTE_LEFT_R(get, never):Bool;
    static function get_NOTE_LEFT_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.notes.left);

    public static var NOTE_DOWN(get, never):Bool;
    static function get_NOTE_DOWN():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.notes.down);

    public static var NOTE_DOWN_P(get, never):Bool;
    static function get_NOTE_DOWN_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.notes.down);

    public static var NOTE_DOWN_R(get, never):Bool;
    static function get_NOTE_DOWN_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.notes.down);

    public static var NOTE_UP(get, never):Bool;
        static function get_NOTE_UP():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.notes.up);

    public static var NOTE_UP_P(get, never):Bool;
        static function get_NOTE_UP_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.notes.up);

    public static var NOTE_UP_R(get, never):Bool;
    static function get_NOTE_UP_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.notes.up);

    public static var NOTE_RIGHT(get, never):Bool;
    static function get_NOTE_RIGHT():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.notes.right);

    public static var NOTE_RIGHT_P(get, never):Bool;
    static function get_NOTE_RIGHT_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.notes.right);

    public static var NOTE_RIGHT_R(get, never):Bool;
    static function get_NOTE_RIGHT_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.notes.right);

    // UI
    
    @:unreflective static var ui:UIControls = ClientPrefs.controls.ui;

    public static var UI_LEFT(get, never):Bool;
    static function get_UI_LEFT():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.ui.left);

    public static var UI_LEFT_P(get, never):Bool;
    static function get_UI_LEFT_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.ui.left);

    public static var UI_LEFT_R(get, never):Bool;
    static function get_UI_LEFT_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.ui.left);

    public static var UI_DOWN(get, never):Bool;
    static function get_UI_DOWN():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.ui.down);

    public static var UI_DOWN_P(get, never):Bool;
    static function get_UI_DOWN_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.ui.down);

    public static var UI_DOWN_R(get, never):Bool;
    static function get_UI_DOWN_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.ui.down);

    public static var UI_UP(get, never):Bool;
    static function get_UI_UP():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.ui.up);

    public static var UI_UP_P(get, never):Bool;
    static function get_UI_UP_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.ui.up);

    public static var UI_UP_R(get, never):Bool;
    static function get_UI_UP_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.ui.up);

    public static var UI_RIGHT(get, never):Bool;
    static function get_UI_RIGHT():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyPressed(ClientPrefs.controls.ui.right);

    public static var UI_RIGHT_P(get, never):Bool;
    static function get_UI_RIGHT_P():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.ui.right);

    public static var UI_RIGHT_R(get, never):Bool;
    static function get_UI_RIGHT_R():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustReleased(ClientPrefs.controls.ui.right);

    public static var ACCEPT(get, never):Bool;
    static function get_ACCEPT():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.ui.accept);

    public static var BACK(get, never):Bool;
    static function get_BACK():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.ui.back);

    public static var RESET(get, never):Bool;
    static function get_RESET():Bool
        return #if mobile MobileControls #else FlxG.keys #end .anyJustPressed(ClientPrefs.controls.ui.reset);

    public static var MOUSE_WHEEL(get, never):Bool;
    static function get_MOUSE_WHEEL():Bool
        return FlxG.mouse.wheel != 0;
    
    public static var MOUSE_WHEEL_DOWN(get, never):Bool;
    static function get_MOUSE_WHEEL_DOWN():Bool
        return FlxG.mouse.wheel < 0;

    public static var MOUSE_WHEEL_UP(get, never):Bool;
    static function get_MOUSE_WHEEL_UP():Bool
        return FlxG.mouse.wheel > 0;

    public static var MOUSE(get, never):Bool;
    static function get_MOUSE():Bool
        return FlxG.mouse.pressed;
    
    public static var MOUSE_P(get, never):Bool;
    static function get_MOUSE_P():Bool
        return FlxG.mouse.justPressed;

    public static var MOUSE_R(get, never):Bool;
    static function get_MOUSE_R():Bool
        return FlxG.mouse.justReleased;
}