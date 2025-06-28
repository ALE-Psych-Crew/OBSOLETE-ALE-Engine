package scripting.haxe;

import rulescript.RuleScript;
import rulescript.parsers.HxParser;

import haxe.ds.StringMap;
import haxe.Exception;

class ALERuleScript extends RuleScript
{
	public var failedParsing:Bool = false;

	override public function new()
	{
		super();

		getParser(HxParser).allowAll();

		this.errorHandler = onError;

		preset();
	}

	public function onError(error:Exception):Dynamic
	{
		failedParsing = true;
		
		return error.details();
	}

	private function preset():Void
	{
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
			Date,
			DateTools,
			Math,
			Reflect,
			Std,
			StringTools,
			Type,
	
			// OpenFL
			openfl.Lib,
			sys.io.File,
			openfl.filters.ShaderFilter,
	
			// Sys
			sys.io.File,
			sys.FileSystem,
			Sys,
	
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
			core.backend.Controls,
	
			// CPP
			cpp.WindowsAPI
		];

        for (theClass in presetClasses)
            setClass(theClass);

		var presetVariables:StringMap<Dynamic> = [
			'FlxColor' => HScriptFlxColor,
			'FlxKey' => HScriptFlxKey,
			'Json' => utils.ALEJson,
			'debugTrace' => CoolUtil.debugTrace
		];

		for (preVar in presetVariables.keys())
			set(preVar, presetVariables.get(preVar));
	}

	public function call(func:String, ?args:Array<Dynamic>)
	{
		var func = variables.get(func);

		if (func != null && Reflect.isFunction(func))
		{
			try
			{
				Reflect.callMethod(null, func, args ?? []);
			} catch(error:Exception) {
				debugPrint(error.message, ERROR);
			}
		}
	}

	public function set(name:String, value:Dynamic)
		variables.set(name, value);

	public function setClass(cls:Class<Dynamic>)
	{
		set(Type.getClassName(cls).split('.').pop(), cls);
	}
}