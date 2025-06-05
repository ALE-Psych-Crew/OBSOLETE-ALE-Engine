package scripting.haxe;

import funkin.visuals.game.*;

import core.enums.ALECharacterType;

class HaxePlayState
{
    public function new(haxe:HScript)
    {
        haxe.set('getCharacter', function(type:ALECharacterType, index:Int):Character
            {
                return switch(type)
                {
                    case PLAYER:
                        PlayState.instance.characters.players[index];
                    case OPPONENT:
                        PlayState.instance.characters.opponents[index];
                    case EXTRA:
                        PlayState.instance.characters.extras[index];
                }
            }
        );

        haxe.set('getStrum', function(type:ALECharacterType, groupIndex:Int, strumIndex:Int):Strum
            {
                return switch(type)
                {
                    case PLAYER:
                        PlayState.instance.strumLines.players[groupIndex].strums.members[strumIndex];
                    case OPPONENT:
                        PlayState.instance.strumLines.opponents[groupIndex].strums.members[strumIndex];
                    case EXTRA:
                        PlayState.instance.strumLines.extras[groupIndex].strums.members[strumIndex];
                }
            } 
        );
    }
}