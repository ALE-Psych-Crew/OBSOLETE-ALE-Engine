package scripting.haxe;

import rulescript.scriptedClass.RuleScriptedClass;

import flixel.*;
import flixel.ui.*;
import flixel.math.*;
import flixel.group.*;
import flixel.graphics.*;
import flixel.addons.ui.*;
import flixel.addons.display.*;

class Extensible {}

@:strictScriptedConstructor
class ScriptObject extends FlxObject implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptSprite extends FlxSprite implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptText extends FlxText implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptGroup extends FlxGroup implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptTimer extends FlxTimer implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptSound extends FlxSound implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptRect extends FlxRect implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptButton extends FlxButton implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptBar extends FlxBar implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptGraphic extends FlxGraphic implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptSubState extends FlxSubState implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptState extends FlxState implements RuleScriptedClass {}

@:strictScriptedConstructor
class ScriptBasic extends FlxBasic implements RuleScriptedClass {}