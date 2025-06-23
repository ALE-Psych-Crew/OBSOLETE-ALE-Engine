package funkin.visuals.game;

import core.enums.ALECharacterType;
import core.enums.NoteState;
import core.enums.NoteType;

import funkin.visuals.shaders.RGBPalette;
import funkin.visuals.shaders.RGBShaderReference;

import flixel.math.FlxAngle;

class Note extends FlxSprite
{
	public var data:Int;
    
    public var strumTime:Float = 0;

	public var children:Array<Note> = [];

	public var sustainHitLenght:Float;

    public var spawned:Bool = false;
    
	public var state:NoteState = NEUTRAL;
	public var type:ALECharacterType;
    public var noteType:NoteType = NORMAL;

	public var noteVariant:String = '';

    public var noteLength:Float = 0;

	public var prevNote:Note;
	public var parentNote:Note;

	public var characterIndex:Int;
	public var selected:Bool = false;
	
	public var ignorable:Bool = false;

	public var character:Character;

	public var ableToHit(get, never):Bool;
	function get_ableToHit():Bool
		return state == NEUTRAL && Math.abs(strumTime - Conductor.songPosition) < 175;

    public var texture(default, set):String;
    public function set_texture(value:String):String
    {
        texture = value;

		frames = Paths.getSparrowAtlas('notes/' + texture);

		for (anim in [['0', 'note'], [' hold piece', 'piece'], [' hold end', 'end']])
			for (col in ['purple', 'blue', 'green', 'red'])
				animation.addByPrefix(anim[1] + CoolUtil.capitalize(col), col + anim[0], 24, false);
        
		animation.onFrameChange.add((name:String, frameNumber:Int, frameIndex:Int) -> {
            centerOffsets();
            centerOrigin();
		});

        scale.set(0.7, 0.7);

		if (noteType == NORMAL)
		{
			centerOffsets();
			centerOrigin();
		}

		if (prevNote != null && prevNote.noteType != NORMAL)
		{
			prevNote.animation.play('idle');
			prevNote.scale.y *= Conductor.stepCrochet / 1000 * 1.05;
			prevNote.updateHitbox();
		}

        updateHitbox();
		
		setMeta(data, noteType);

        return texture;
    }

	public var shaderRef:RGBShaderReference;

    public function new(strumTime:Float, data:Int, noteLength:Float, noteVariant:Null<String>, type:ALECharacterType, noteType:NoteType, texture:String = 'note')
    {
		super();

		this.noteVariant = noteVariant;

		this.strumTime = strumTime;
		this.data = data;
		this.noteLength = noteLength;

		this.type = type;
        this.noteType = noteType;

		var rgbPalette = new RGBPalette();
		shaderRef = new RGBShaderReference(this, rgbPalette);
		
		var shaderArray:Array<FlxColor> = ClientPrefs.data.arrowRGB[data];
		shaderRef.r = shaderArray[0];
		shaderRef.g = shaderArray[1];
		shaderRef.b = shaderArray[2];

        this.texture = texture;

		flipY = noteType == SUSTAIN_END && ClientPrefs.data.downScroll;

		antialiasing = ClientPrefs.data.antialiasing;
    }
	
	public static inline function setNotePosition(note:FlxSprite, target:FlxSprite, angle:Float, offsetX:Float, offsetY:Float)
	{
		offsetX += target.width / 2 - note.width / 2;

		var radians = FlxAngle.asRadians(angle - 90);

		note.x = target.x + Math.cos(radians) * offsetX + Math.sin(radians) * offsetY;
		note.y = target.y + Math.cos(radians) * offsetY + Math.sin(radians) * offsetX;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		/*
		if (strum != null)
		{
			alpha = strum.alpha * (noteType == NORMAL ? 1 : state == LOST ? 0.25 : 0.5);
			angle = strum.angle;
			scale.x = strum.scale.x;
			scale.y = strum.scale.y;
		}
			*/
	}

	public function setMeta(data:Int, noteType:NoteType)
	{
		this.data = data;
		this.noteType = noteType;

		var anim = switch(noteType)
		{
			case NORMAL:
				'note';
			case SUSTAIN:
				'piece';
			case SUSTAIN_END:
				'end';
		}

		var color = switch (data)
		{
			case 0:
				'Purple';
			case 1:
				'Blue';
			case 2:
				'Green';
			case 3:
				'Red';
			default:
				'';
		};

		animation.play(anim + color, true);
		
		var shaderArray:Array<FlxColor> = ClientPrefs.data.arrowRGB[data];
		shaderRef.r = shaderArray[0];
		shaderRef.g = shaderArray[1];
		shaderRef.b = shaderArray[2];
	}

	public function resetNote(strumTime:Float, data:Int, noteLength:Float, noteVariant:Null<String>, noteType:NoteType)
	{
		this.strumTime = strumTime;
		this.noteLength = noteLength;
		this.noteVariant = noteVariant;

		state = NEUTRAL;

		y = FlxG.height * 2;

		setMeta(data, noteType);

		active = true;
		
		flipY = noteType == SUSTAIN_END && ClientPrefs.data.downScroll;
	}
}