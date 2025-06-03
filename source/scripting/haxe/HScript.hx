package scripting.haxe;

#if HSCRIPT_ALLOWED
import cpp.*;

import haxe.ds.StringMap;

import scripting.sscript.tea.SScript;
import scripting.sscript.tea.SScript.TeaCall;

import funkin.visuals.cutscenes.DialogueCharacter;

import flixel.input.keyboard.FlxKey;
import flixel.system.macros.FlxMacroUtil;

import core.enums.ScriptType;

import flixel.ui.FlxButton;
import flixel.FlxObject;

@:access(core.backend.ScriptState)
@:access(core.backend.ScriptSubState)
class HScript extends SScript
{
	public var type:ScriptType;

	override public function new(file:String, type:ScriptType)
	{
		super(file);

		this.type = type;

		preset();
	}

    override public function preset()
    {
		super.preset();

        var presetClasses:Array<Dynamic> = [
            // Flixel
            flixel.FlxG,
            flixel.FlxSprite,
            flixel.FlxCamera,
            flixel.math.FlxMath,
            flixel.text.FlxText,
            flixel.util.FlxTimer,
            flixel.tweens.FlxTween,
            flixel.tweens.FlxEase,
            flixel.effects.FlxFlicker,
            flixel.tile.FlxTilemap,
			flixel.group.FlxGroup,
			flixel.group.FlxGroup.FlxTypedGroup,
            flixel.addons.display.FlxRuntimeShader,
			flixel.addons.display.FlxGridOverlay,
            flixel.addons.display.FlxBackdrop,
            flixel.addons.editors.ogmo.FlxOgmo3Loader,

            // Haxe
            StringTools,
            sys.io.Process,
			haxe.ds.StringMap,

            // OpenFL
            openfl.Lib,
            sys.io.File,
            openfl.filters.ShaderFilter,

            // ALE
            Paths,
            CoolUtil,
            CoolVars,
			ClientPrefs,
            Conductor,
            core.backend.MusicBeatState,
			core.backend.DiscordRPC,
            CustomState,
			CustomSubState,
			funkin.visuals.objects.AttachedSprite,
			funkin.visuals.objects.AttachedText,
			funkin.visuals.objects.Alphabet,
			funkin.visuals.objects.TypedAlphabet,
			funkin.visuals.objects.AttachedAlphabet,
			funkin.states.OptionsState,
			core.backend.Controls
        ];

        for (theClass in presetClasses)
            setClass(theClass);

		var instanceVariables:StringMap<Dynamic> = new StringMap<Dynamic>();
		
		if (type == STATE)
		{
			instanceVariables = [
				'this' => FlxG.state,
				'add' => FlxG.state.add,
				'insert' => FlxG.state.insert,
				'openSubState' => FlxG.state.openSubState,
				'CancelSuperFunction' => ScriptState.instance.CancelSuperFunction,
				'debugPrint' => ScriptState.instance.debugPrint,
				'getObjectOrder' => function(obj:FlxObject)
				{
					if (type == STATE)
						ScriptState.instance.members.indexOf(obj);
					else
						ScriptSubState.instance.members.indexOf(obj);

					return null;
				},
				'setObjectOrder' => function(obj:FlxObject, index:Int)
				{
					if (type == STATE)
					{
						ScriptState.instance.remove(obj);
						ScriptState.instance.insert(index, obj);
					} else {
						ScriptSubState.instance.remove(obj);
						ScriptSubState.instance.insert(index, obj);
					}
				}
			];
		} else if (type == SUBSTATE) {
			instanceVariables = [
				'this' => FlxG.state.subState,
				'add' => FlxG.state.subState.add,
				'insert' => FlxG.state.subState.insert,
				'close' => FlxG.state.subState.close,
				'CancelSuperFunction' => ScriptSubState.instance.CancelSuperFunction,
				'debugPrint' => ScriptSubState.instance.debugPrint
			];
		}

		for (insVar in instanceVariables.keys())
			set(insVar, instanceVariables.get(insVar));

		var presetVariables:StringMap<Dynamic> = [
			'FlxColor' => FlxColorClass,
			'FlxKey' => FlxKeyClass,
			'Json' => utils.ALEJson,
			'debugTrace' => CoolUtil.debugTrace
		];

		for (preVar in presetVariables.keys())
			set(preVar, presetVariables.get(preVar));

		var presetFunctions:StringMap<Dynamic> = [
			'setWindowBorderColor' => function(r:Int, g:Int, b:Int)
			{
				#if (windows && cpp)
				WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
				WindowsCPP.setWindowBorderColor(r, g, b);
				#end
			},
			'showConsole' => function()
			{
				#if (windows && cpp)
				WindowsTerminalCPP.allocConsole();
				#end
			}
		];

		for (preFunc in presetFunctions.keys())
			set(preFunc, presetFunctions.get(preFunc));
    }

	override public function call(func:String, ?args:Array<Dynamic>):TeaCall
	{
		if (!exists(func))
			return null;

		var callValue:TeaCall = super.call(func, args);

		if (!callValue.succeeded)
		{
			var errorString:String = 'Error: ' + callValue.calledFunction + ' - ' + callValue.exceptions[0].message;
			
			if (type == STATE)
				ScriptState.instance.debugPrint(errorString, ERROR);
			else if (type == SUBSTATE)
				ScriptSubState.instance.debugPrint(errorString, ERROR);
		}

		if (callValue != null)
			return callValue;

		return null;
	}
}

class FlxColorClass
{
	public static var TRANSPARENT(default, null):Int = FlxColor.TRANSPARENT;
	public static var BLACK(default, null):Int = FlxColor.BLACK;
	public static var WHITE(default, null):Int = FlxColor.WHITE;
	public static var GRAY(default, null):Int = FlxColor.GRAY;

	public static var GREEN(default, null):Int = FlxColor.GREEN;
	public static var LIME(default, null):Int = FlxColor.LIME;
	public static var YELLOW(default, null):Int = FlxColor.YELLOW;
	public static var ORANGE(default, null):Int = FlxColor.ORANGE;
	public static var RED(default, null):Int = FlxColor.RED;
	public static var PURPLE(default, null):Int = FlxColor.PURPLE;
	public static var BLUE(default, null):Int = FlxColor.BLUE;
	public static var BROWN(default, null):Int = FlxColor.BROWN;
	public static var PINK(default, null):Int = FlxColor.PINK;
	public static var MAGENTA(default, null):Int = FlxColor.MAGENTA;
	public static var CYAN(default, null):Int = FlxColor.CYAN;

	public static function fromInt(Value:Int):Int 
	{
		return cast FlxColor.fromInt(Value);
	}

	public static function fromRGB(Red:Int, Green:Int, Blue:Int, Alpha:Int = 255):Int
	{
		return cast FlxColor.fromRGB(Red, Green, Blue, Alpha);
	}
	public static function fromRGBFloat(Red:Float, Green:Float, Blue:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromRGBFloat(Red, Green, Blue, Alpha);
	}

	public static inline function fromCMYK(Cyan:Float, Magenta:Float, Yellow:Float, Black:Float, Alpha:Float = 1):Int
	{
		return cast FlxColor.fromCMYK(Cyan, Magenta, Yellow, Black, Alpha);
	}

	public static function fromHSB(Hue:Float, Sat:Float, Brt:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSB(Hue, Sat, Brt, Alpha);
	}
	public static function fromHSL(Hue:Float, Sat:Float, Light:Float, Alpha:Float = 1):Int
	{	
		return cast FlxColor.fromHSL(Hue, Sat, Light, Alpha);
	}
	public static function fromString(str:String):Int
	{
		return cast FlxColor.fromString(str);
	}
}

class FlxKeyClass
{
	public static var fromStringMap(default, null):Map<String, FlxKey> = FlxMacroUtil.buildMap("flixel.input.keyboard.FlxKey", false, []);
	public static var toStringMap(default, null):Map<FlxKey, String> = FlxMacroUtil.buildMap("flixel.input.keyboard.FlxKey", true, []);

	public static var ANY = -2;
	public static var NONE = -1;
	public static var A = 65;
	public static var B = 66;
	public static var C = 67;
	public static var D = 68;
	public static var E = 69;
	public static var F = 70;
	public static var G = 71;
	public static var H = 72;
	public static var I = 73;
	public static var J = 74;
	public static var K = 75;
	public static var L = 76;
	public static var M = 77;
	public static var N = 78;
	public static var O = 79;
	public static var P = 80;
	public static var Q = 81;
	public static var R = 82;
	public static var S = 83;
	public static var T = 84;
	public static var U = 85;
	public static var V = 86;
	public static var W = 87;
	public static var X = 88;
	public static var Y = 89;
	public static var Z = 90;
	public static var ZERO = 48;
	public static var ONE = 49;
	public static var TWO = 50;
	public static var THREE = 51;
	public static var FOUR = 52;
	public static var FIVE = 53;
	public static var SIX = 54;
	public static var SEVEN = 55;
	public static var EIGHT = 56;
	public static var NINE = 57;
	public static var PAGEUP = 33;
	public static var PAGEDOWN = 34;
	public static var HOME = 36;
	public static var END = 35;
	public static var INSERT = 45;
	public static var ESCAPE = 27;
	public static var MINUS = 189;
	public static var PLUS = 187;
	public static var DELETE = 46;
	public static var BACKSPACE = 8;
	public static var LBRACKET = 219;
	public static var RBRACKET = 221;
	public static var BACKSLASH = 220;
	public static var CAPSLOCK = 20;
	public static var SCROLL_LOCK = 145;
	public static var NUMLOCK = 144;
	public static var SEMICOLON = 186;
	public static var QUOTE = 222;
	public static var ENTER = 13;
	public static var SHIFT = 16;
	public static var COMMA = 188;
	public static var PERIOD = 190;
	public static var SLASH = 191;
	public static var GRAVEACCENT = 192;
	public static var CONTROL = 17;
	public static var ALT = 18;
	public static var SPACE = 32;
	public static var UP = 38;
	public static var DOWN = 40;
	public static var LEFT = 37;
	public static var RIGHT = 39;
	public static var TAB = 9;
	public static var WINDOWS = 15;
	public static var MENU = 302;
	public static var PRINTSCREEN = 301;
	public static var BREAK = 19;
	public static var F1 = 112;
	public static var F2 = 113;
	public static var F3 = 114;
	public static var F4 = 115;
	public static var F5 = 116;
	public static var F6 = 117;
	public static var F7 = 118;
	public static var F8 = 119;
	public static var F9 = 120;
	public static var F10 = 121;
	public static var F11 = 122;
	public static var F12 = 123;
	public static var NUMPADZERO = 96;
	public static var NUMPADONE = 97;
	public static var NUMPADTWO = 98;
	public static var NUMPADTHREE = 99;
	public static var NUMPADFOUR = 100;
	public static var NUMPADFIVE = 101;
	public static var NUMPADSIX = 102;
	public static var NUMPADSEVEN = 103;
	public static var NUMPADEIGHT = 104;
	public static var NUMPADNINE = 105;
	public static var NUMPADMINUS = 109;
	public static var NUMPADPLUS = 107;
	public static var NUMPADPERIOD = 110;
	public static var NUMPADMULTIPLY = 106;
	public static var NUMPADSLASH = 111;

	public static inline function fromString(s:String)
	{
		s = s.toUpperCase();

		return fromStringMap.exists(s) ? fromStringMap.get(s) : NONE;
	}

	public inline function toString(value:FlxKey):String
		return toStringMap.get(value);
}
#end