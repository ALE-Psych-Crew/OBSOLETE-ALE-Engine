package funkin.visuals.objects;

import flixel.graphics.FlxGraphic;

class HealthIcon extends FlxSprite
{
    public var anims:Int = 2;

    public var texture(default, set):String;
    public function set_texture(value:String):String
    {
        texture = value;

        var name:String = 'icons/' + texture;

        if (!Paths.fileExists('images/' + name + '.png'))
            name = 'icons/icon-' + texture;

        if (!Paths.fileExists('images/' + name + '.png'))
            name = 'icons/face';

        var animsArray:Array<Int> = [];

        for (i in 0...anims)
            animsArray.push(i);
        
        var graphic:FlxGraphic = Paths.image(name);

        loadGraphic(graphic, true, Math.floor(graphic.width / anims), Math.floor(graphic.height));

        animation.add(texture, animsArray, 0, false);
        animation.play(texture);

        updateHitbox();

        antialiasing = ClientPrefs.data.antialiasing && !texture.endsWith('pixel');

        return texture;
    }

    override public function new(name:String, ?anims:Int = 2)
    {
        super();

        if (anims < 1)
            anims = 1;
        
        this.anims = anims;

        texture = name;
    }
}