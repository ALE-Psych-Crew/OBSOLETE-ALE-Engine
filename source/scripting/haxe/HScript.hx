package scripting.haxe;

import rulescript.RuleScript;
import rulescript.parsers.HxParser;

import core.enums.ScriptType;

import haxe.ds.StringMap;
import haxe.Exception;

import flixel.FlxObject;

@:access(core.backend.ScriptState)
@:access(core.backend.ScriptSubState)
class HScript extends RuleScript
{
	public final type:ScriptType;

	public var parsingException:Null<String> = null;

	override public function new(filePath:String, type:ScriptType)
	{
		super();
		
		this.type = type;

		var splitPath:Array<String> = filePath.split('/');
		
		scriptName = splitPath[splitPath.length - 1];

		this.errorHandler = onError;

		getParser(HxParser).allowAll();

		preset();

		var theException:Null<Exception> = null;

		if (FileSystem.exists(filePath))
			tryExecute(File.getContent(filePath), onError);

		if (theException != null)
			parsingException = theException.message;
	}

	public dynamic function onError(error:Exception):Dynamic
	{
		if (type == STATE)
			ScriptState.instance.debugPrint(error.message, ERROR);
		else
			ScriptSubState.instance.debugPrint(error.message, ERROR);

		parsingException = error.message;

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

		var instanceVariables:StringMap<Dynamic> = new StringMap<Dynamic>();
		
		if (type == STATE)
		{
			instanceVariables = [
				'game' => FlxG.state,
				'add' => FlxG.state.add,
				'insert' => FlxG.state.insert,
				'remove' => FlxG.state.remove,
				'openSubState' => FlxG.state.openSubState,
				'CancelSuperFunction' => ScriptState.instance.CancelSuperFunction,
				'debugPrint' => ScriptState.instance.debugPrint,
				'getObjectOrder' => function(obj:FlxObject)
				{
					return FlxG.state.members.indexOf(obj);
				},
				'setObjectOrder' => function(obj:FlxObject, index:Int)
				{
					FlxG.state.remove(obj);
					FlxG.state.insert(index, obj);
				}
			];
		} else if (type == SUBSTATE) {
			instanceVariables = [
				'game' => FlxG.state.subState,
				'add' => FlxG.state.subState.add,
				'insert' => FlxG.state.subState.insert,
				'remove' => FlxG.state.subState.remove,
				'close' => FlxG.state.subState.close,
				'CancelSuperFunction' => ScriptSubState.instance.CancelSuperFunction,
				'debugPrint' => ScriptSubState.instance.debugPrint,
				'getObjectOrder' => function(obj:FlxObject)
				{
					return FlxG.state.subState.members.indexOf(obj);
				},
				'setObjectOrder' => function(obj:FlxObject, index:Int)
				{
					FlxG.state.subState.remove(obj);
					FlxG.state.subState.insert(index, obj);
				}
			];
		}

		for (insVar in instanceVariables.keys())
			set(insVar, instanceVariables.get(insVar));

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
		interp.variables.set(name, value);

	public function setClass(cls:Class<Dynamic>)
	{
		var className = Type.getClassName(cls).split('.');

		set(className[className.length - 1], cls);
	}
}