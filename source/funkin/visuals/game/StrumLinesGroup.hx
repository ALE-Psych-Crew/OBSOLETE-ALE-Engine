package funkin.visuals.game;

class StrumLinesGroup
{
    public var extras:Array<StrumLine> = [];
    public var opponents:Array<StrumLine> = [];
    public var players:Array<StrumLine> = [];

    public function new() {};

    public function getGroups()
        return [extras, players, opponents];

    public function update()
    {
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