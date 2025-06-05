package funkin.visuals.editors.chart;

import funkin.visuals.shaders.RGBPalette;
import funkin.visuals.shaders.RGBPalette.RGBShaderReference;

class ChartNote extends FlxSprite
{
    private var CELL_SIZE:Int;

    public var selected(default, set):Bool = false;
    public function set_selected(value:Bool):Bool
    {
        selected = value;

        var editorColors:Dynamic = {
            chart: {
                selectedNoteFill: [0, 50, 50],
                selectedNoteFirstOutline: [0, 100, 100],
                selectedNoteSecondOutline: [0, 200, 200]
            }
        }
        
        if (selected)
        {
            shaderRef.r = CoolUtil.colorFromArray(editorColors.chart.selectedNoteFill);
            shaderRef.g = CoolUtil.colorFromArray(editorColors.chart.selectedNoteFirstOutline);
            shaderRef.b = CoolUtil.colorFromArray(editorColors.chart.selectedNoteSecondOutline);
        } else {
            var shaderArray:Array<FlxColor> = ClientPrefs.data.arrowRGB[data];
            shaderRef.r = shaderArray[0];
            shaderRef.g = shaderArray[1];
            shaderRef.b = shaderArray[2];
        }

        return selected;
    }

    public var sustain:FlxSprite;

    public var length(default, set):Float = 0;
    function set_length(value:Float)
    {
        length = Math.max(0, value);

        if (sustain != null)
        {
            sustain.scale.y = msToPixels(length, CELL_SIZE * Conductor.stepsPerBeat * Conductor.beatsPerSection);
            sustain.updateHitbox();

            updateSustain();
        }

        return length;
    }

    function msToPixels(ms:Float, theHeight:Float):Float
        return ms / Conductor.sectionCrochet * theHeight;

    public var data(default, set):Int;
    function set_data(value:Int):Int
    {
        data = value % 4;

        animation.play(switch (data)
        {
			case 0:
                'purple';
			case 1:
                'blue';
			case 2:
                'green';
			case 3:
                'red';
			default:
                '';
        }, true);

        return data;
    }

    public var time:Float;
    public var variant:Null<String>;
    public var gridIndex:Int;

    private var curTime:Float = 0;

	public var shaderRef:RGBShaderReference;

    override public function new(cell:Int, time:Float, data:Int, length:Float, variant:Null<String>, gridIndex:Int)
    {
        super();

		frames = Paths.getSparrowAtlas('notes/note');

        for (anim in ['purple', 'blue', 'green', 'red'])
            animation.addByPrefix(anim, anim + '0', 1, false);

		animation.onFrameChange.add((name:String, frameNumber:Int, frameIndex:Int) -> {
            centerOffsets();
            centerOrigin();
		});

        this.CELL_SIZE = cell;

        this.time = time;
        this.data = data;
        this.variant = variant;

        this.gridIndex = gridIndex;

        setGraphicSize(CELL_SIZE);
        updateHitbox();

		var rgbPalette = new RGBPalette();
		shaderRef = new RGBShaderReference(this, rgbPalette);

        sustain = new FlxSprite().makeGraphic(Math.floor(CELL_SIZE / 6), 1);
        
        this.length = length;

        this.selected = false;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (selected)
        {
            curTime += elapsed;

            alpha = Math.sin(curTime * 2 + time / 100) * 0.25 + 0.5;
        } else {
            alpha = Conductor.songPosition > time ? 0.25 : 1;
        }

        updateSustain();
    }

    public function updateSustain()
    {
        sustain.x = x + width / 2 - sustain.width / 2;
        sustain.y = y + height / 2;
        sustain.alpha = alpha * 0.5;
    }
}