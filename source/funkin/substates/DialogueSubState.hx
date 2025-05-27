package funkin.substates;

import funkin.visuals.cutscenes.DialogueCharacter;
import funkin.visuals.objects.TypedAlphabet;

import core.structures.ALEDialogue;

import utils.ALEParserHelper;

import haxe.ds.StringMap;

class DialogueSubState extends MusicBeatSubState
{
    public var subCamera:FlxCamera;

    public var bg:FlxSprite;

    public var bubble:FlxSprite;

    public var text:TypedAlphabet;

    public var dialogue:ALEDialogue;
    public var currentDialogue:Int = 0;

    public var characters:StringMap<DialogueCharacter>;
    public var currentCharacter:String = '';

    public var finishCallback:Void -> Void;

    public var canSelect:Bool = true;

    override public function new(path:String, ?finishCallback:Void -> Void)
    {
        super();

        this.dialogue = ALEParserHelper.getALEDialogue(Json.parse(File.getContent(Paths.getPath(path + '.json'))));

        this.finishCallback = finishCallback;
    }

    override public function create()
    {
        super.create();

        for (line in dialogue.lines)
            if (line.sound != '')
                Paths.sound(line.sound);

        subCamera = new FlxCamera();
        subCamera.bgColor = FlxColor.TRANSPARENT;

        characters = new StringMap<DialogueCharacter>();

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0;
        bg.cameras = [subCamera];
        FlxTween.tween(bg, {alpha: 0.25}, 1, {ease: FlxEase.cubeOut});

        bubble = new FlxSprite(70, FlxG.height - 370);
        bubble.frames = Paths.getSparrowAtlas('ui/dialogueBubble');
        bubble.cameras = [subCamera];

        var bubAnim:Array<Dynamic> = [
            ['default', 'speech bubble normal', true],
            ['defaultOpen', 'Speech Bubble Normal Open', false],

            ['defaultMiddle', 'speech bubble middle', true],
            ['defaultMiddleOpen', 'Speech Bubble Middle Open', false],

            ['angry', 'AHH speech bubble', true],
            ['angryOpen', 'speech bubble loud open', false],

            ['angryMiddle', 'AHH Speech Bubble middle', true],
            ['angryMiddleOpen', 'speech bubble Middle loud open', false]
        ];

        for (anim in bubAnim)
            bubble.animation.addByPrefix(anim[0], anim[1], 22, anim[2]);

        bubble.animation.onFinish.add(
            (name) -> {
                bubble.animation.play(
                    switch(name)
                    {
                        case 'defaultOpen':
                            'default';
                        case 'defaultMiddleOpen':
                            'defaultMiddle';
                        case 'angryOpen':
                            'angry';
                        case 'angryMiddleOpen':
                            'angryMiddle';
                        default:
                            'default';
                    }
                );

                showText();
            }
        );

        bubble.animation.onFrameChange.add(
            (name:String, frameNumber:Int, frameIndex:Int) -> {
                bubble.centerOffsets();
                bubble.centerOrigin();
            }
        );

        bubble.animation.play('defaultOpen');

        bubble.scale.set(0.9, 0.9);

        bubble.antialiasing = ClientPrefs.data.antialiasing;

        text = new TypedAlphabet(175, FlxG.height - 220, '');
        text.setScale(0.7);
        text.cameras = [subCamera];

        FlxG.cameras.add(subCamera, false);

        add(bg);

        spawnCharacters();
        
        add(bubble);
        add(text);

        changeDialogue(0);
    }

    function spawnCharacters()
    {
        var characterArray:Array<String> = [];

        for (line in dialogue.lines)
            if (characterArray.indexOf(line.character) == -1)
                characterArray.push(line.character);

        for (character in characterArray)
        {
            var object:DialogueCharacter = new DialogueCharacter(0, 60, character);
            add(object);
            object.cameras = [subCamera];
            object.animation.play(object.animation.getNameList()[0]);

            object.animation.onFinish.add(
                (name) -> {
                    if (object.alpha == 0)
                        return;

                    if (text.finishedText)
                        object.animation.play(name + '-idle', true);
                    else
                        object.animation.play(name, true);
                }
            );

            object.x = object.data.position == CENTERED ? FlxG.width / 2 - object.width / 2 : object.data.position == RIGHT ? FlxG.width - object.width - 100 : 0;

            object.x += object.data.screenPosition[0];
            object.y += object.data.screenPosition[1];

            object.defaultY = object.y;

            object.y += 100;
            object.alpha = 0;

            characters.set(character, object);
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        
        if (canSelect && (Controls.ACCEPT || Controls.UI_LEFT_P || Controls.UI_RIGHT_P))
            changeDialogue(Controls.UI_LEFT_P ? -1 : 1);
    }

    var curCharacter:DialogueCharacter;

    var cameraTween:FlxTween;

    function changeDialogue(change:Int)
    {
        currentDialogue += change;

        if (currentDialogue < 0)
        {
            currentDialogue = 0;

            return;
        } else if (currentDialogue > dialogue.lines.length - 1) {
            canSelect = false;

            currentDialogue = dialogue.lines.length - 1;

            cameraTween = FlxTween.tween(subCamera, {alpha: 0}, 0.5, {
                onComplete: (_) -> {
                    if (finishCallback != null)
                        finishCallback();

                    close();
                }
            });

            return;
        }

        FlxG.sound.play(Paths.sound('dialogueClose'));

        var line = dialogue.lines[currentDialogue];

        if (line.character != currentCharacter && curCharacter != null)
        {
            FlxTween.cancelTweensOf(curCharacter);
            FlxTween.tween(curCharacter, {alpha: 0, y: curCharacter.defaultY + 100}, 0.2, {ease: FlxEase.cubeIn});
        }

        curCharacter = characters.get(line.character);

        text.visible = false;
        text.text = text.sound = '';

        curCharacter.animation.play(line.animation);

        FlxTween.cancelTweensOf(curCharacter);
        FlxTween.tween(curCharacter, {alpha: 1, y: curCharacter.defaultY}, 0.3, {ease: FlxEase.cubeOut});

        currentCharacter = line.character;

        if (line.boxState == NORMAL)
            bubble.animation.play(curCharacter.data.position == CENTERED ? 'defaultMiddleOpen' : 'defaultOpen');
        else
            bubble.animation.play(curCharacter.data.position == CENTERED ? 'angryMiddleOpen' : 'angryOpen');

        bubble.flipX = (curCharacter.data.position == LEFT && line.boxState == NORMAL) || (curCharacter.data.position == RIGHT && line.boxState == ANGRY);

        bubble.x = FlxG.width / 2 - bubble.width / 2;
        bubble.y = FlxG.height - 370;
    }

    function showText()
    {
        var line = dialogue.lines[currentDialogue];

        text.delay = line.speed;

        text.sound = 'dialogue';

        if (line.sound != '')
            text.sound = line.sound;

        text.visible = true;

        text.text = line.text;

        text.y = FlxG.height - 220;
        
        if (text.rows > 2)
            text.y -= 24;
    }

    override function destroy()
    {
        super.destroy();
            
        if (cameraTween != null)
            cameraTween.cancel();

        FlxG.cameras.remove(subCamera);
    }
}