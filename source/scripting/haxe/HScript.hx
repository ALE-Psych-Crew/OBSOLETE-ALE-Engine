package scripting.haxe;

import core.enums.ScriptType;

import haxe.ds.StringMap;
import haxe.Exception;

import flixel.FlxObject;

@:access(core.backend.ScriptState)
@:access(core.backend.ScriptSubState)
class HScript extends ALERuleScript
{
	public final type:ScriptType;

	override public function new(filePath:String, type:ScriptType)
	{
		this.type = type;

		super();

		scriptName = filePath.split('/').pop();

		if (FileSystem.exists(filePath))
			tryExecute(File.getContent(filePath), onError);
	}

	override public function onError(error:Exception):Dynamic
	{
		if (type == STATE)
			ScriptState.instance.debugPrint(error.message, ERROR);
		else
			ScriptSubState.instance.debugPrint(error.message, ERROR);

		return super.onError(error);
	}

	override private function preset():Void
	{
		super.preset();
		
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
	}
}