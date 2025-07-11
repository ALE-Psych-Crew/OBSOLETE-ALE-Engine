package funkin.visuals.game;

import flixel.sound.FlxSound;

import flixel.group.FlxGroup;

import flixel.util.FlxSort;
import flixel.math.FlxRect;
import flixel.math.FlxAngle;

import core.enums.ALECharacterType;
import core.enums.Rating;

import core.structures.ALESection;
import core.enums.NoteType;

class StrumLine extends FlxGroup
{
    public var strums:FlxTypedGroup<Strum>;
    
    public var notes:FlxTypedGroup<Note>;
    public var sustains:FlxTypedGroup<Note>;

    public var allNotes:Array<Note> = [];

    public var splashes:FlxTypedGroup<Splash>;

    private var downScroll:Bool = ClientPrefs.data.downScroll;

    public var scrollSpeed:Float = 1;

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

    public var unspawnNotes:Array<Note> = [];

    public function new(character:Character, superNotes:Array<Array<Dynamic>>, startPosition:Float)
    {
        chartNotes = superNotes;

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

		for (noteData in chartNotes)
		{
            var time = noteData[0];

            if (time < startPosition)
                continue;

            var data = noteData[1];
            var length = noteData[2];
            var variant = noteData[3];

            var note:Note = new Note(time, data, variant, NORMAL, character.type);
            unspawnNotes.push(note);

            if (length > 0)
            {
                var steps:Float = length / Conductor.stepCrochet;
                var totalSustains:Int = steps - Math.floor(steps) <= 0.8 ? Math.floor(steps) : Math.round(steps);

                if (totalSustains <= 0)
                    totalSustains = 1;

                for (i in 0...totalSustains)
                {
                    var child:Note = new Note(time + i * Conductor.stepCrochet, data, variant, i == totalSustains - 1 ? SUSTAIN_END : SUSTAIN, character.type);

                    note.children.push(child);

                    unspawnNotes.push(child);
                }
            }
		}

		unspawnNotes.sort(
			function(obj1:Note, obj2:Note)
				return FlxSort.byValues(FlxSort.ASCENDING, obj1.time, obj2.time)
		);

        visible = character.type != EXTRA;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
		var justPressed:Array<Bool> = [
			FlxG.keys.justPressed.D,
			FlxG.keys.justPressed.F,
			FlxG.keys.justPressed.J,
			FlxG.keys.justPressed.K
		];

		var justReleased:Array<Bool> = [
			FlxG.keys.justReleased.D,
			FlxG.keys.justReleased.F,
			FlxG.keys.justReleased.J,
			FlxG.keys.justReleased.K
		];
        
        spawnNotes();

        updateStrums(justPressed, justReleased);

        updateNotes(justPressed, justReleased);
    }

    private function spawnNotes()
    {
		var spawnTime:Float = 2000 / Math.min(scrollSpeed, 1);

        while (unspawnNotes[0] != null && Conductor.songPosition + spawnTime > unspawnNotes[0].time)
        {
            var note:Note = unspawnNotes.shift();

            if (noteSpawnCallback != null)
                noteSpawnCallback(note);

            addNote(note);

            if (postNoteSpawnCallback != null)
                postNoteSpawnCallback(note);
        }
    }

    private function updateStrums(justPressed:Array<Bool>, justReleased:Array<Bool>)
    {
        if (botplay)
            return;

        for (index => strum in strums)
        {
			if (justPressed[index])
				strum.animation.play('pressed', true);

			if (justReleased[index])
				strum.animation.play('idle', true);
        }
    }

    private function updateNotes(justPressed:Array<Bool>, justReleased:Array<Bool>)
    {
        var despawnTime:Float = 350 / Math.min(scrollSpeed, 1);

        var clickedData:Array<Int> = [];

        for (note in allNotes)
        {
            var diff:Float = note.time - Conductor.songPosition;
            var absDiff:Float = Math.abs(diff);
            
            var strum:Strum = strums.members[note.data];
            var splash:Splash = splashes.members[note.data];

            if (diff < -despawnTime)
            {
                removeNote(note);

                continue;
            }

            note.direction = strum.direction;

            setNotePosition(note, strum, note.direction, 0, diff * 0.45 * scrollSpeed + (note.noteType == NORMAL ? 0 : strum.height / 2));

            if (note.state == MISSED)
                continue;

            if (diff < -175 && !botplay)
            {
                missNote(note);

                continue;
            }

            if (note.noteType == NORMAL)
            {
                if ((note.state == NEUTRAL && justPressed[note.data] && absDiff <= 175 && !clickedData.contains(note.data) && !botplay) || (botplay && diff <= 0))
                {
                    clickedData.push(note.data);
                    
                    var rating:Null<Rating> = null;

                    if (!botplay)
                    {
                        if (absDiff <= 50)
                            rating = SICK;
                        else if (absDiff <= 95)
                            rating = GOOD;
                        else if (absDiff <= 140)
                            rating = BAD;
                        else if (absDiff <= 175)
                            rating = SHIT;
                    }

                    hitNote(note, rating, strum, splash);
                }
            } else {
                if (justReleased[note.data] && note.state == HELD && !botplay)
                    note.state = MISSED;

                if (note.state == HELD && diff <= 0)
                {
                    if (noteHitCallback != null)
                        noteHitCallback(note, null);
                    
                    hitNote(note, null, strum, null);

                    strum.animation.play('hit', true);

                    if (postNoteHitCallback != null)
                        noteHitCallback(note, null);
                }
            }
        }
    }

    function hitNote(note:Note, rating:Null<Rating>, strum:Strum, splash:Null<Splash>)
    {
        if (noteHitCallback != null)
            noteHitCallback(note, rating);

        note.state = HIT;

        for (child in note.children)
            child.state = HELD;

        for (sound in voices)
            if (sound.volume != 1)
                sound.volume = 1;

        strum.animation.play('hit', true);

        if (splash != null && !botplay && rating == SICK)
            splash.animation.play('splash', true);
        
        character.idleTimer = 0;
        
        character.animation.play('sing' + ['LEFT', 'DOWN', 'UP', 'RIGHT'][note.data], true);

        if (postNoteHitCallback != null)
            postNoteHitCallback(note, rating);

        removeNote(note);
    }

    public function missNote(note:Note)
    {
        if (noteMissCallback != null)
            noteMissCallback(note);

        for (child in note.children)
            child.state = MISSED;

        for (sound in voices)
            if (sound.volume != 0)
                sound.volume = 0;

        note.state = MISSED;

        if (note.ignorable || note.noteType != NORMAL)
        {
            if (postNoteMissCallback != null)
                postNoteMissCallback(note);

            return;
        }

        character.idleTimer = 0;

        character.animation.play('sing' + ['LEFT', 'DOWN', 'UP', 'RIGHT'][note.data] + 'miss', true);

        if (postNoteMissCallback != null)
            postNoteMissCallback(note);
    }

    inline function addNote(note:Note)
    {
        var group:FlxTypedGroup<Note> = note.noteType == NORMAL ? notes : sustains;

        group.add(note);

        allNotes.push(note);
    }

    inline function removeNote(note:Note)
    {
        var group:FlxTypedGroup<Note> = note.noteType == NORMAL ? notes : sustains;

        note.kill();

        group.remove(note, true);

        allNotes.remove(note);

        note.destroy();
    }
	
	inline function setNotePosition(note:Note, strum:Strum, angle:Float, offsetX:Float, offsetY:Float)
	{
		offsetX += strum.width / 2 - note.width / 2;

		angle = FlxAngle.asRadians(angle);

		note.x = strum.x + Math.cos(angle) * offsetX + Math.sin(angle) * offsetY;
		note.y = strum.y + Math.cos(angle) * offsetY + Math.sin(angle) * offsetX;
	}
}