package funkin.visuals.game;

import funkin.visuals.objects.AttachedSprite;

import funkin.visuals.shaders.RGBPalette;
import funkin.visuals.shaders.RGBShaderReference;

class Splash extends AttachedSprite
{
    public var noteData:Int;

    public var strum(default, set):Strum;
    function set_strum(value:Strum):Strum
    {
        strum = value;

        sprTracker = strum;
        
        xAdd = strum.width / 2 - width / 2;
        yAdd = strum.height / 2 - height / 2;

        return value;
    }

    public var texture(default, set):String = 'splash';
    function set_texture(value:String):String
    {
        texture = value;

        frames = Paths.getSparrowAtlas('splashes/' + texture);

        switch (noteData % 4)
        {
            case 0:
                animation.addByPrefix('splash', 'note splash purple 1', 24, false);
            case 1:
                animation.addByPrefix('splash', 'note splash blue 1', 24, false);
            case 2:
                animation.addByPrefix('splash', 'note splash green 1', 24, false);
            case 3:
                animation.addByPrefix('splash', 'note splash red 1', 24, false);
        }

        animation.onFrameChange.add((name:String, frameNumber:Int, frameIndex:Int) -> {
            centerOffsets();
            centerOrigin();
            
            visible = true;

            x = strum.x + strum.width / 2 - width / 2;
            y = strum.y + strum.width / 2 - width / 2;
        });

        animation.onFinish.add((name:String) -> {
            visible = false;
        });

        centerOffsets();
        centerOrigin();

        scale.set(0.85, 0.85);

        updateHitbox();

        if (strum != null)
        {
            xAdd = strum.width / 2 - width / 2;
            yAdd = strum.height / 2 - height / 2;
        }

        return texture;
    }

    public function new(noteData:Int)
    {
        super();

        visible = false;

        this.noteData = noteData;

        var rgbPalette = new RGBPalette();
        var shaderRef:RGBShaderReference = new RGBShaderReference(this, rgbPalette);

        var shaderArray:Array<FlxColor> = ClientPrefs.data.arrowRGB[noteData % 4];
        shaderRef.r = shaderArray[0];
        shaderRef.g = shaderArray[1];
        shaderRef.b = shaderArray[2];

        texture = texture;

        antialiasing = ClientPrefs.data.antialiasing;

        alphaMult = ClientPrefs.data.splashAlpha / 100;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (cameras != strum.cameras)
            cameras = strum.cameras;
    }
}