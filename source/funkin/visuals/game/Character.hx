package funkin.visuals.game;

import utils.ALEParserHelper;

import core.structures.ALECharacter;

import core.enums.ALECharacterType;

import haxe.ds.StringMap;

class Character extends FlxSprite
{
    public var data:ALECharacter;

    public var type:ALECharacterType;

    public var idleTimer:Float = 0;

    public var finishedIdleTimer(get, never):Bool;
    public function get_finishedIdleTimer():Bool
        return idleTimer >= 60 / Conductor.bpm;

    public var allowIdle:Bool = true;

    public var name(default, set):String;
    public function set_name(value:String):String
    {
        name = value;

        data = ALEParserHelper.getALECharacter(name);

        texture = data.image;
        return name;
    }

    public var offsetsMap:Map<String, Array<Int>> = new Map<String, Array<Int>>();

    public var cameraPosition:Array<Float>;

    public var texture(default, set):String;
    public function set_texture(value:String):String
    {
        texture = value;

        frames = Paths.getAtlas(texture);

        for (animation in data.animations)
        {
            if (animation.indices != null && animation.indices.length > 0)
                this.animation.addByIndices(animation.animation, animation.prefix, animation.indices, "", animation.framerate, animation.looped);
            else
                this.animation.addByPrefix(animation.animation, animation.prefix, animation.framerate, animation.looped);

            var offsets:Array<Int> = animation.offset;

            offsetsMap[animation.animation] = offsets != null && offsets.length > 1 ? [offsets[0], offsets[1]] : [0, 0];
        }

        offsetsCallback = (name:String) -> {
            if (offsetsMap.exists(name))
            {
                var offsets:Array<Int> = offsetsMap.get(name);

                offset.set(offsets[0], offsets[1]);
            }
        }

        animation.onFrameChange.add((name:String, frameNumber:Int, frameIndex:Int) -> {
            if (offsetsCallback != null)
                offsetsCallback(name);
        });

        animation.onFinish.add((name:String) -> {
            if (animation.getByName(name).looped == false && animation.exists(name + '-loop'))
                animation.play(name + '-loop');
        });

        flipX = data.flipX == (type != PLAYER);

        if (animation.exists('idle'))
            animation.play('idle', true);
        else if (animation.exists('danceLeft'))
            animation.play('danceLeft', true);

        if (data.scale != 1)
        {
            scale.x = scale.y = data.scale;

            updateHitbox();
        }

        cameraPosition = [data.cameraPosition[0], data.cameraPosition[1]];

        antialiasing = ClientPrefs.data.antialiasing && data.antialiasing;

        return texture;
    }

    private var offsetsCallback:String -> Void;

    override public function new(x:Float = 0, y:Float = 0, name:String, type:ALECharacterType)
    {
        super(x, y);

        this.type = type;

        this.name = name;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (!finishedIdleTimer)
            idleTimer += elapsed;
    }
}