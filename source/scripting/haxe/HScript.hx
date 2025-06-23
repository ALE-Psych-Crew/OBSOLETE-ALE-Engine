package scripting.haxe;

#if HSCRIPT_ALLOWED
import cpp.*;

import haxe.ds.StringMap;

import tea.SScript;
import tea.SScript.TeaCall;

import core.enums.ScriptType;

import scripting.haxe.HScriptImports;
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
				'this' => FlxG.state,
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
				'this' => FlxG.state.subState,
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

		/*
		var presetFunctions:StringMap<Dynamic> = [
		];

		for (preFunc in presetFunctions.keys())
			set(preFunc, presetFunctions.get(preFunc));
		*/
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
#end