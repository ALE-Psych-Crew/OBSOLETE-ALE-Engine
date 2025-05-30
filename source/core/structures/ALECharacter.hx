package core.structures;

typedef ALECharacter = {
    var animations:Array<ALECharacterJSONAnimation>;

    var antialiasing:Bool;

    var image:String;

    var position:Array<Int>;

    var icon:String;

    var flipX:Bool;

    var barColor:Array<Int>;

    var cameraPosition:Array<Float>;

    var scale:Float;

    var format:String;
    
    var deadVariant:String;
}