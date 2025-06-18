package funkin.visuals.game;

import flixel.sound.FlxSound;

import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import flixel.math.FlxRect;

import core.enums.ALECharacterType;
import core.enums.Rating;

import core.structures.ALESection;
import core.enums.NoteType;

class StrumLine extends FlxGroup
{
    public var strums:FlxTypedGroup<Strum>;
    public var sustains:FlxTypedGroup<Note>;
    public var notes:FlxTypedGroup<Note>;

    public var splashes:FlxTypedGroup<Splash>;

    private var downScroll:Bool = ClientPrefs.data.downScroll;

    public var scrollSpeed:Float = 1;

    public var scrollTween:FlxTween;

    public var botplay:Bool;

    public var character:Character;

    public var noteHitCallback:(Note, Rating) -> Void;
    public var postNoteHitCallback:(Note, Rating) -> Void;
    
    public var noteMissCallback:Note -> Void;
    public var postNoteMissCallback:Note -> Void;

    public var noteSpawnCallback:Note -> Void;
    public var postNoteSpawnCallback:Note -> Void;

    public var voices:Array<FlxSound> = [];

	public var chartNotes:Array<Array<Dynamic>> = [];

	public var notePool:Array<Note> = [];

    public function new(character:Character, superNotes:Array<Array<Dynamic>>, startPosition:Float)
    {
        super();

        this.character = character;

        botplay = this.character.type != PLAYER;

        add(strums = new FlxTypedGroup<Strum>());
        add(sustains = new FlxTypedGroup<Note>());
        add(notes = new FlxTypedGroup<Note>());

        add(splashes = new FlxTypedGroup<Splash>());

        for (i in 0...4)
        {
            var strum:Strum = new Strum(i, character.type, this);
            strums.add(strum);

            var splash:Splash = new Splash(i);
            splashes.add(splash);
            splash.strum = strum;
        }

		var daNotes:Array<Array<Dynamic>> = superNotes;

		daNotes.sort(
			function(obj1:Array<Dynamic>, obj2:Array<Dynamic>)
				return FlxSort.byValues(FlxSort.ASCENDING, obj1[0], obj2[0])
		);

		for (note in daNotes)
		{
            if (note[0] < startPosition)
                continue;

			chartNotes.push([note[0], note[1], note[2], note[3], NoteType.NORMAL]);

            if (note[2] > 0)
            {
                var rawLoop:Float = note[2] / Conductor.stepCrochet;

                var susLoop:Int = rawLoop - Math.floor(rawLoop) <= 0.5 ? Math.floor(rawLoop) : Math.round(rawLoop);

				if (susLoop <= 0)
					susLoop = 1;

                for (i in 0...susLoop)
					chartNotes.push([note[0] + Conductor.stepCrochet * i, note[1], note[2], 0, i == susLoop - 1 ? NoteType.SUSTAIN_END : NoteType.SUSTAIN]);
            }
		}

        visible = character.type != EXTRA;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

		var spawnT:Float = 2000;
		var despawnT:Float = 200;

		if (scrollSpeed < 1)
		{
			spawnT /= scrollSpeed;
			despawnT /= scrollSpeed;
		}

		while (chartNotes[0] != null && Conductor.songPosition + spawnT > chartNotes[0][0])		
		{
			var note:Array<Dynamic> = chartNotes.shift();

            var object:Note = requestNote(note[0], note[1], note[2], note[3], note[4]);

            if (noteSpawnCallback != null)
                noteSpawnCallback(object);

			addNote(object);

            if (postNoteSpawnCallback != null)
                postNoteSpawnCallback(object);
		}

        for (group in [notes, sustains])
            for (note in group)
            {
                if (Conductor.songPosition >= note.strumTime + despawnT)
                    removeNote(note);
                
                if (Conductor.songPosition - note.strumTime > 175 && note.state == NEUTRAL)
                    onNoteMiss(note);
            }

        for (note in notes)
        {
            var strum:Strum = strums.members[note.data];

            Note.setNotePosition(note, strum, strum.direction, 0, (note.strumTime - Conductor.songPosition) * scrollSpeed * 0.45 * (downScroll ? -1 : 1));
        
            if (botplay)
            {
                if (Conductor.songPosition >= note.strumTime && note.state == NEUTRAL)
                    onNoteHit(note);
            }
        }

        for (sustain in sustains)
        {
            if (sustain.state == HELD || true)
                if (Conductor.songPosition >= sustain.strumTime)
                    onNoteHit(sustain);

            var strum:Strum = strums.members[sustain.data];

            Note.setNotePosition(sustain, strum, strum.direction, 0, (downScroll ? -1 : 1) * strum.height / 2 + (sustain.strumTime - Conductor.songPosition) * scrollSpeed * 0.45 * (downScroll ? -1 : 1));
            
            /*
            var parent = sustain.parentNote;

            if (parent != null)
            {
                var strum:Strum = strums.members[sustain.data];

                if (parent.state == HELD)
                {
                    sustain.state = HELD;

                    sustain.sustainHitLenght = Conductor.songPosition - sustain.strumTime;

                    var rect = new FlxRect(0, 0, sustain.frameWidth, sustain.frameHeight);

                    var minSize:Float = sustain.sustainHitLenght - (Conductor.stepCrochet);
                    var maxSize:Float = Conductor.stepCrochet;

                    if (minSize > maxSize)
                        minSize = maxSize;

                    if (minSize > 0)
                        rect.y = (minSize / maxSize) * sustain.frameHeight;

                    sustain.clipRect = rect;

                    var holdPercent:Float = (sustain.sustainHitLenght / parent.noteLenght);
                }
            }
                */
        }
    }

    public function justPressKey(data:Int)
    {
        if (botplay)
            return;

        var pressedData:Int = -1;

        for (note in notes)
            if (data == note.data && note.state == NEUTRAL && note.ableToHit)
            {
                pressedData = note.data;

                var difference = Math.abs(note.strumTime - Conductor.songPosition + 22.5);

                var rating:Rating = null;

                if (difference <= 50)
                    rating = SICK;
                else if (difference <= 95)
                    rating = GOOD;
                else if (difference <= 140)
                    rating = BAD;
                else if (difference <= 175)
                    rating = SHIT;

                onNoteHit(note, rating);

                break;
            }
        
        for (strum in strums)
            if (data == strum.data && strum.data != pressedData)
                strum.animation.play('pressed', true);
    }

    public function releaseKey(data:Int)
    {
        if (botplay)
            return;

        for (sustain in sustains)
            if (data == sustain.data && sustain.state == HELD /*&& Math.abs(sustain.strumTime - Conductor.songPosition) > 50*/)
                onNoteMiss(sustain);
        
        for (strum in strums)
            if (data == strum.data)
                strum.animation.play('idle', true);
    }

    public function onNoteMiss(note:Note)
    {
        if (noteMissCallback != null)
            noteMissCallback(note);

        for (sound in voices)
            if (sound.volume != 0)
                sound.volume = 0;

        note.state = LOST;

        if (note.ignorable || note.noteType != NORMAL)
        {
            if (postNoteMissCallback != null)
                postNoteMissCallback(note);

            return;
        }

        character.idleTimer = 0;

        character.animation.play('sing' + (switch (note.data)
            {
                case 0:
                    'LEFT';
                case 1:
                    'DOWN';
                case 2:
                    'UP';
                case 3:
                    'RIGHT';
                default:
                    '';
            }) + 'miss',
            true
        );

        if (postNoteMissCallback != null)
            postNoteMissCallback(note);
    }

    public function onNoteHit(note:Note, ?rating:Rating)
    {
        if (noteHitCallback != null)
            noteHitCallback(note, rating);
        
        note.state = HIT;

        for (child in note.children)
            child.state = HELD;

        removeNote(note);
        
        strums.members[note.data].animation.play('hit', true);
        
        if (!botplay && rating == SICK)
            splashes.members[note.data].animation.play('splash', true);
        
        character.idleTimer = 0;
        
        if (true)    
            character.animation.play('sing' + switch (note.data)
                {
                    case 0:
                        'LEFT';
                    case 1:
                        'DOWN';
                    case 2:
                        'UP';
                    case 3:
                        'RIGHT';
                    default:
                        '';
                },
                true
            );

        for (sound in voices)
            if (sound.volume != 1)
                sound.volume = 1;

        if (postNoteHitCallback != null)
            postNoteHitCallback(note, rating);
    }

    public function addNote(note:Note)
    {
        if (note.noteType == NORMAL)
            notes.add(note);
        else
            sustains.add(note);
    }

    public function removeNote(note:Note)
    {
        note.active = false;
        notePool.push(note);

        if (note.noteType == NORMAL)
            notes.remove(note, true);
        else
            sustains.remove(note, true);
    }

	function requestNote(time:Float, data:Int, length:Float, variant:Null<String>, type:NoteType):Note
	{
		var result:Note;

		if (notePool[0] != null)
		{
			result = notePool.pop();
			result.resetNote(time, data, length, variant, type);
		} else {
			result = new Note(time, data, length, variant, character.type, type);
		}

        result.updateHitbox();

        result.character = this.character;

		return result;
	}
}