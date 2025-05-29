package funkin.visuals.game;

class StrumLinesGroup extends FlxTypedGroup<FlxTypedGroup<StrumLine>>
{
    public var extras:FlxTypedGroup<StrumLine>;
    public var opponents:FlxTypedGroup<StrumLine>;
    public var players:FlxTypedGroup<StrumLine>;

    override public function new()
    {
        super();

        extras = new FlxTypedGroup<StrumLine>();
        add(extras);

        opponents = new FlxTypedGroup<StrumLine>();
        add(opponents);

        players = new FlxTypedGroup<StrumLine>();
        add(players);
    }

    public function getGroups()
        return [extras, players, opponents];

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (Controls.NOTE_LEFT_P)
            forEachStrumLine((strum:StrumLine) -> { strum.justPressKey(0); });

        if (Controls.NOTE_DOWN_P)
            forEachStrumLine((strum:StrumLine) -> { strum.justPressKey(1); });

        if (Controls.NOTE_UP_P)
            forEachStrumLine((strum:StrumLine) -> { strum.justPressKey(2); });

        if (Controls.NOTE_RIGHT_P)
            forEachStrumLine((strum:StrumLine) -> { strum.justPressKey(3); });

        if (Controls.NOTE_LEFT_R)
            forEachStrumLine((strum:StrumLine) -> { strum.releaseKey(0); });

        if (Controls.NOTE_DOWN_R)
            forEachStrumLine((strum:StrumLine) -> { strum.releaseKey(1); });

        if (Controls.NOTE_UP_R)
            forEachStrumLine((strum:StrumLine) -> { strum.releaseKey(2); });

        if (Controls.NOTE_RIGHT_R)
            forEachStrumLine((strum:StrumLine) -> { strum.releaseKey(3); });
    }

    public function forEachStrumLine(func:StrumLine -> Void):Void
    {
        for (group in getGroups())
            for (line in group)
                func(line);
    }
}