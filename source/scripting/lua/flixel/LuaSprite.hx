package scripting.lua.flixel;

import flixel.util.FlxGradient;

import funkin.visuals.objects.Alphabet;
import funkin.visuals.objects.TypedAlphabet;

class LuaSprite extends LuaPresetBase
{
    public function new(lua:LuaScript)
    {
        super(lua);

        set('newSprite', function(tag:String, ?x:Float, ?y:Float, ?sprite:String)
            {
                var sprite:FlxSprite = new FlxSprite(x, y, sprite == null ? null : Paths.image(sprite));
                sprite.animation.onFrameChange.add(
                    function(name:String, number:Int, index:Int)
                    {
                        if (type == STATE)
                            ScriptState.instance.callOnLuaScripts('onSpriteAnimationFrameChange', [tag, name, number, index]);
                        else
                            ScriptSubState.instance.callOnLuaScripts('onSpriteAnimationFrameChange', [tag, name, number, index]);
                    }
                );
                sprite.animation.onFinish.add(
                    (name:String) -> {
                        if (type == STATE)
                            ScriptState.instance.callOnLuaScripts('onSpriteAnimationFinish', [tag, name]);
                        else
                            ScriptSubState.instance.callOnLuaScripts('onSpriteAnimationFinish', [tag, name]);
                    }
                );
                setTag(tag, sprite);
            }
        );

        set('newGradient', function(tag:String, width:Int, height:Int, colors:Array<FlxColor>, ?chunkSize:Int = 1, ?rotation:Int = 90, ?interpolate:Bool = true)
            {
                setTag(tag, FlxGradient.createGradientFlxSprite(width, height, colors, chunkSize, rotation, interpolate));
            }
        );

        set('loadGraphic', function(tag:String, name:String, ?animated:Bool = false, ?frameWidth:Int = 0, frameHeight:Int = 0)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).loadGraphic(Paths.image(name), animated, frameWidth, frameHeight);
            }
        );

        set('makeGraphic', function(tag:String, width:Int, height:Int, ?color:FlxColor = FlxColor.WHITE)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).makeGraphic(width, height, color);
            }
        );

        set('addAnimationByPrefix', function(tag:String, name:String, prefix:String, ?frameRate:Float, ?looped:Bool, ?flipX:Bool, ?flipY:Bool)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).animation.addByPrefix(name, prefix, frameRate, looped, flipX, flipY);
            }
        );

        set('addAnimationByIndices', function(tag:String, name:String, prefix:String, indices:Array<Int>, ?frameRate:Float, ?looped:Bool, flipX:Bool, flipY:Bool)
            {
                if(tagIs(tag, FlxSprite))
                    getTag(tag).animation.addByIndices(name, prefix, indices, null, frameRate, looped, flipX, flipY);
            }
        );

        set('playAnimation', function(tag:String, name:String, ?force:Bool, ?reversed:Bool, ?frame:Int)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).animation.play(name, force, reversed, frame);
            }
        );

        set('updateHitbox', function(tag:String)
            {
                if (tagIs(tag, FlxSprite))
                    getTag(tag).updateHitbox();
            }
        );

        set('newAlphabet', function(tag:String, x:Float, y:Float, text:String = '', ?bold:Bool = true)
            {
                setTag(tag, new Alphabet(x, y, text, bold));
            }
        );

        set('newTypedAlphabet', function(tag:String, x:Float, y:Float, text:String = "", ?delay:Float = 0.05, ?bold:Bool = false)
            {
                setTag(tag, new TypedAlphabet(x, y, text, delay, bold));
            }
        );
    }
}