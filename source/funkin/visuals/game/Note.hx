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
    
    public var time:Float = 0;

	public var children:Array<Note> = [];

	public var direction:Float = 0;

	public var sustainHitLenght:Float;

    public var spawned:Bool = false;
    
	public var state:NoteState = NEUTRAL;

	public var type:ALECharacterType;

    public final noteType:NoteType;

	public var noteVariant:String = '';

	public var characterIndex:Int;

	public var selected:Bool = false;
	
	public var ignorable:Bool = false;

	public var character:Character;

    public var texture(default, set):String;
    public function set_texture(value:String):String
    {
        texture = value;

		frames = Paths.getSparrowAtlas('notes/' + texture);

		var color:String = ['purple', 'blue', 'green', 'red'][data];
				
		animation.addByPrefix('idle',
			switch (noteType)
			{
				case NORMAL:
					color + '0';
				case SUSTAIN:
					color + ' hold piece';
				case SUSTAIN_END:
					color + ' hold end';
			},
		24, false);

        scale.set(0.7, 0.7);

		animation.play('idle', true);

		centerOffsets();
		centerOrigin();
        updateHitbox();

        return texture;
    }

	public var shaderRef:RGBShaderReference;

    public function new(time:Float, data:Int, noteVariant:Null<String>, noteType:NoteType, type:ALECharacterType, texture:String = 'note')
    {
		super();

		this.noteVariant = noteVariant;

		this.time = time;
		this.data = data;

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
}