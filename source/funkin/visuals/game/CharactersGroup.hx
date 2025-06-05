package funkin.visuals.game;

class CharactersGroup
{
    public var extras:Array<Character> = [];
    public var opponents:Array<Character> = [];
    public var players:Array<Character> = [];

    public function new() {}

    public function getGroups():Array<Array<Character>>
        return [extras, opponents, players];
}