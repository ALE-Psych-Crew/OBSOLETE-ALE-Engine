package funkin.visuals.objects;

import funkin.vis.dsp.SpectralAnalyzer;

import lime.media.AudioSource;

import flixel.group.FlxGroup;

class Visualizer extends FlxGroup
{
    public var bars:FlxTypedGroup<FlxSprite>;
    public var analyzer:SpectralAnalyzer;

    public final width:Int;
    public final height:Int;

    public function new(audioSource:AudioSource, ?width:Float, ?height:Float, barCount:Int = 16, color:FlxColor = FlxColor.RED)
    {
        super();

        analyzer = new SpectralAnalyzer(audioSource, barCount, 0.1, 10);

        bars = new FlxTypedGroup<FlxSprite>();
		add(bars);

        this.width = Math.floor(width ?? FlxG.width);
        this.height = Math.floor(height ?? FlxG.height);

		for (i in 0...barCount)
		{
			var spr = new FlxSprite((i / barCount) * this.width, 0).makeGraphic(Std.int((1 / barCount) * this.width) - 4, this.height, color);
            spr.origin.set(0, this.height);
			bars.add(spr);
		}
    }

    @:generic static inline function min<T:Float>(x:T, y:T):T
        return x > y ? y : x;

    override function draw()
    {
        @:privateAccess var levels = analyzer.audioSource == null ? [for (i in 0...bars.members.length) {value: 0.0, peak: 0.0}] : analyzer.getLevels();

        for (i in 0...min(bars.members.length, levels.length))
            bars.members[i].scale.y = levels[i].value;

        super.draw();
    }
}
