package scripting.lua;

import scripting.lua.haxe.LuaReflect;

import core.enums.ALECharacterType;

import funkin.visuals.game.*;

import flixel.FlxObject;

class LuaPlayState extends LuaPresetBase
{
    var game:PlayState = PlayState.instance;

    override public function new(lua:LuaScript)
    {
        super(lua);

        set('setCharacterProperty', function(type:ALECharacterType, index:Int, props:Dynamic)
            {
                var object:Character = getCharacter(type, index);

                if (object != null)
                    LuaReflect.applyProps(object, props);
            }
        );

        set('playCharacterAnimation', function(type:ALECharacterType, index:Int, name:String, ?force:Bool, ?reversed:Bool, ?frame:Int)
            {
                var object:Character = getCharacter(type, index);

                if (object != null)
                    object.animation.play(name, force, reversed, frame);
            }
        );

        set('setStrumLineProperty', function(type:ALECharacterType, index:Int, props:Dynamic)
            {
                var object:StrumLine = getStrumLine(type, index);

                if (object != null)
                    LuaReflect.applyProps(object, props);
            }
        );

        set('setStrumProperty', function(type:ALECharacterType, groupIndex:Int, index:Int, props:Dynamic)
            {
                var object:Strum = getStrum(type, groupIndex, index);

                if (object != null)
                    LuaReflect.applyProps(object, props);
            }
        );

        /*
        set('addBehindExtras', function(tag:String)
            {
                if (tagIs(tag, FlxObject))
                {
                    if (type == STATE)
                        ScriptState.instance.insert(ScriptState.instance.indexOf(), getTag(tag));
                }
            }
        );
        */
    }

    function getCharacter(type:ALECharacterType, index:Int):Character
    {
        return switch(type)
            {
                case PLAYER:
                    game.characters.players[index];
                case OPPONENT:
                    game.characters.opponents[index];
                case EXTRA:
                    game.characters.extras[index];
            }
    }

    function getStrumLine(type:ALECharacterType, index:Int):StrumLine
    {
        return switch(type)
            {
                case PLAYER:
                    game.strumLines.players[index];
                case OPPONENT:
                    game.strumLines.opponents[index];
                case EXTRA:
                    game.strumLines.extras[index];
            }
    }

    function getStrum(type:ALECharacterType, groupIndex:Int, index:Int):Strum
    {
        return switch(type)
            {
                case PLAYER:
                    game.strumLines.players[groupIndex].strums.members[index];
                case OPPONENT:
                    game.strumLines.opponents[groupIndex].strums.members[index];
                case EXTRA:
                    game.strumLines.extras[groupIndex].strums.members[index];
            }
    }
}