package funkin.visuals.mobile;

import core.backend.MobileControls;

import flixel.ui.FlxSpriteButton;
import flixel.input.keyboard.FlxKey;

class MobileButton extends FlxSpriteButton
{
    public var keys:Null<Array<Null<FlxKey>>>;

    override public function new(?x:Float, ?y:Float, keys:Array<Null<FlxKey>>, letter:String, ?width:Float, ?height:Float)
    {
        super(x, y);

        var theWidth:Int = Math.floor(width ?? 125);
        var theHeight:Int = Math.floor(height ?? 125);

        label = new FlxSprite();

        if (letter != null)
        {
            makeGraphic(theWidth, theHeight, 0x80404040);

            label.frames = Paths.getSparrowAtlas('ui/alphabet');
            label.animation.addByPrefix('idle', letter.toLowerCase() + ' instance 1');
            label.animation.play('idle');
            label.setGraphicSize(0, theHeight - theHeight * 0.4);
            label.updateHitbox();
            label.offset.x -= theWidth / 2 - label.width / 2;
            label.offset.y -= theHeight / 2 - label.height / 2;
            label.color = FlxColor.BLACK;
        } else {            
            makeGraphic(theWidth, theHeight, FlxColor.TRANSPARENT);

            label.makeGraphic(theWidth, theHeight, 0xFF404040);
            
            alpha = 0.5;
        }

        for (key in keys)
            if (key != null)
                MobileControls._controlsMap.set(key, this);

        this.keys = keys;
    }

    override public function destroy()
    {
        for (key in keys)
            if (key != null)
                MobileControls._controlsMap.remove(key);

        super.destroy();
    }
}