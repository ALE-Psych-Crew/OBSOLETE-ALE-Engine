package funkin.visuals.game;

import core.enums.ALECharacterType;
import core.enums.NoteState;
import core.enums.NoteType;

import funkin.visuals.shaders.RGBPalette;
import funkin.visuals.shaders.RGBPalette.RGBShaderReference;

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

    public var noteLenght:Float = 0;

	public var prevNote:Note;
	public var parentNote:Note;

	public var characterIndex:Int;
	public var selected:Bool = false;

	public var ableToHit(get, never):Bool;
	function get_ableToHit():Bool
		return state == NEUTRAL && Math.abs(strumTime - Conductor.songPosition) < 175;

	var noteAnim(get, never):String;
	function get_noteAnim():String
		return switch (data) {
			case 0: 'purple';
			case 1: 'blue';
			case 2: 'green';
			case 3: 'red';
			default: '';
		};

    public var texture(default, set):String;
    public function set_texture(value:String):String
    {
        texture = value;

		frames = Paths.getSparrowAtlas('notes/' + texture);

        switch (noteType)
        {
            case NORMAL:
                animation.addByPrefix('idle', noteAnim + '0', 24, false);
            case SUSTAIN:
                animation.addByPrefix('idle', noteAnim + ' hold piece', 24, false);
            case SUSTAIN_END:
                animation.addByPrefix('idle', noteAnim + ' hold end', 24, false);
        }
        
        scale.set(0.7, 0.7);

		animation.play('idle', true);

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

        return texture;
    }

	public var shaderRef:RGBShaderReference;

    public function new(strumTime:Float, data:Int, noteLenght:Float, noteVariant:Null<String>, type:ALECharacterType, noteType:NoteType, texture:String = 'note')
    {
		super();

		this.noteVariant = noteVariant;

		this.strumTime = strumTime;
		this.data = data;
		this.noteLenght = noteLenght;

		this.type = type;
        this.noteType = noteType;

        this.texture = texture;

		var rgbPalette = new RGBPalette();
		shaderRef = new RGBShaderReference(this, rgbPalette);
		var shaderArray:Array<FlxColor> = ClientPrefs.data.arrowRGB[data];
		shaderRef.r = shaderArray[0];
		shaderRef.g = shaderArray[1];
		shaderRef.b = shaderArray[2];

		flipY = noteType == SUSTAIN_END && ClientPrefs.data.downScroll;

		antialiasing = ClientPrefs.data.antialiasing;

		animation.play('idle', true);
    }

	public function resetNote()
	{
		visible = true;

		state = NEUTRAL;
		type = null;
        noteType = null;
		spawned = false;

		noteLenght = 0;
		
		clipRect = null;
	}
	
	public static function setNotePosition(note:FlxSprite, target:FlxSprite, angle:Float, offsetX:Float, offsetY:Float)
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
}