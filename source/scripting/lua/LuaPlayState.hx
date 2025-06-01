package scripting.lua;

import scripting.lua.haxe.LuaReflect;

import core.enums.ALECharacterType;

import funkin.visuals.game.*;

class LuaPlayState extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        var game:PlayState = PlayState.instance;

        set('setCharacterProperty', function(type:ALECharacterType, index:Int, props:Dynamic)
            {
                var object:Character = switch(type)
                {
                    case PLAYER:
                        game.characters.players.members[index];
                    case OPPONENT:
                        game.characters.opponents.members[index];
                    case EXTRA:
                        game.characters.extras.members[index];
                }

                if (object != null)
                    LuaReflect.applyProps(object, props);
            }
        );
    }
}