package funkin.visuals.cutscenes;

import haxe.ds.StringMap;

import core.structures.ALEDialogueCharacter;

import utils.ALEParserHelper;

class DialogueCharacter extends FlxSprite
{
    private var IDLE_POSTFIX:String = '-idle';

    public var data:ALEDialogueCharacter;

    public var defaultY:Float = 0;

    public var name(default, set):String;
    public function set_name(value:String):String
    {
        name = value;

        data = ALEParserHelper.getALEDialogueCharacter(name);

        texture = data.image;

        return name;
    }

    public var offsetsMap:StringMap<Dynamic>;

    public var texture(default, set):String;
    public function set_texture(value:String):String
    {
        texture = value;

        offsetsMap = new StringMap<Dynamic>();

        frames = Paths.getAtlas('dialogue/' + texture);

        for (anim in data.animations)
        {
            animation.addByPrefix(anim.animation, anim.name, 24, false);
            offsetsMap.set(anim.animation, anim.offset);
            
            animation.addByPrefix(anim.animation + IDLE_POSTFIX, anim.idleName, 24, true);
            offsetsMap.set(anim.animation + IDLE_POSTFIX, anim.idleOffset);
        }

        animation.onFrameChange.add(
            (name, number, index) -> {
                if (offsetsMap.exists(name))
                {
                    offset.x = offsetsMap.get(name)[0];
                    offset.y = offsetsMap.get(name)[1];
                }
            }
        );

        antialiasing = ClientPrefs.data.antialiasing && data.antialiasing;

        scale.x = scale.y = data.scale * 0.7;

        updateHitbox();

        return texture;
    }

    override public function new(x:Float = 0, y:Float = 0, character:String)
    {
        super(x, y);

        if (character == null)
            character = 'bf';
        
        name = character;
    }
}