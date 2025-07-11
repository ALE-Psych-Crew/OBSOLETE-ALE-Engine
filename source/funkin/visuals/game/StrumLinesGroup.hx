package funkin.visuals.game;

class StrumLinesGroup
{
    public var extras:Array<StrumLine> = [];
    public var opponents:Array<StrumLine> = [];
    public var players:Array<StrumLine> = [];

    public function new() {};

    public function getGroups()
        return [extras, players, opponents];

    public function forEachStrumLine(func:StrumLine -> Void):Void
    {
        for (group in getGroups())
            for (line in group)
                func(line);
    }
}