package core.structures;

typedef DataJson =
{
    var developerMode:Bool;
    var scriptsHotReloading:Bool;

    var initialState:String;
    var freeplayState:String;
    var storyMenuState:String;
    var masterEditorMenu:String;
    var mainMenuState:String;

    var pauseSubState:String;
    var gameOverScreen:String;
    var transition:String;

    var title:String;
    var icon:String;

    var bpm:Float;

    var discordID:String;
}