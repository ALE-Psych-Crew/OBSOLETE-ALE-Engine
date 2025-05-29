import flixel.group.FlxTypedGroup;

var sky:FlxSprite;

var clouds:FlxSprite;
var mountains:FlxSprite;
var buildings:FlxSprite;

var ruins:FlxSprite;

var smokeLeft:FlxSprite;
var smokeRight:FlxSprite;
var watchTower:FlxSprite;

var tank:FlxSprite;
var runningTankmans:FlxTypedGroup<FlxSprite>;

var ground:FlxSprite;

var foreground:FlxTypedGroup<FlxSprite>;

var tankSpeed:Float = FlxG.random.float(5, 7);
var tankAngle:Float = FlxG.random.int(-90, 45);

function onCreate()
{
	sky = createSprite('sky', -400, -400, 1, 0);

	if (!ClientPrefs.data.lowQuality)
	{
		clouds = createSprite('clouds', FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 1, 0.1);
		clouds.velocity.x = FlxG.random.float(5, 15);

		mountains = createSprite('mountains', -300, -20, 1.2, 0.2);

		buildings = createSprite('buildings', -200, 0, 1.1, 0.3);
	}

	ruins = createSprite('ruins', -200, 0, 1.1, 0.35);

	if (!ClientPrefs.data.lowQuality)
	{
		smokeLeft = createSprite('smokeLeft', -200, -100, 1, 0.4, true, [['smoke', 'SmokeBlurLeft']], true);
		smokeRight = createSprite('smokeRight', 1100, -100, 1, 0.4, true, [['smoke', 'SmokeRight']], true);

		watchTower = createSprite('watchTower', 100, 50, 1, 0.5, true, [['idle', 'watchtower gradient color']]);
	}

	runningTankmans = new FlxTypedGroup<FlxSprite>();
	add(runningTankmans);

	tank = createSprite('tank', 0, 0, 1, 0.5, true, [['idle', 'BG tank w lighting']], true);

	ground = createSprite('ground', -420, -150, 1.15);
}

function postCreate()
{
	foreground = new FlxTypedGroup<FlxSprite>();
	add(foreground);

	foreground.add(createSprite('tank0', -500, 650, 1, 1.5, true, [['idle', 'fg']]));

	foreground.members[foreground.members.length - 1].scrollFactor.x = 1.7;

	if (!ClientPrefs.data.lowQuality)
	{
		foreground.add(createSprite('tank1', -300, 720, 1, 0.2, true, [['idle', 'fg']]));

		foreground.members[foreground.members.length - 1].scrollFactor.x = 2;
	}

	foreground.add(createSprite('tank2', 450, 940, 1, 1.5, true, [['idle', 'foreground']]));

	if (!ClientPrefs.data.lowQuality)
		foreground.add(createSprite('tank4', 1300, 900, 1, 1.5, true, [['idle', 'fg']]));

	foreground.add(createSprite('tank5', 1620, 700, 1, 1.5, true, [['idle', 'fg']]));

	if (!ClientPrefs.data.lowQuality)
	{
		foreground.add(createSprite('tank3', 1300, 1200, 1, 2.5, true, [['idle', 'fg']]));

		foreground.members[foreground.members.length - 1].scrollFactor.x = 3.5;
	}

	if (!ClientPrefs.data.lowQuality && getCharacter('extra', 0).name == 'pico-speaker')
		createRunningTankmans();
}

function onBeatHit(curBeat:Int)
{
	for (sprite in foreground)
		sprite.animation.play('idle', true);
}

function onUpdate(elapsed:Float)
{
	tankAngle += elapsed * tankSpeed;
	tank.angle = tankAngle - 90 + 15;
	tank.x = 400 + 1500 * Math.cos(Math.PI / 180 * (tankAngle + 180));
	tank.y = 1300 + 1100 * Math.sin(Math.PI / 180 * (tankAngle + 180));

	if (!ClientPrefs.data.lowQuality && getCharacter('extra', 0).name == 'pico-speaker')
		updateTankmans();
}

function createSprite(image:String, ?x:Float, ?y:Float, ?scale:Float, ?scroll:Float, ?addInState:Bool, ?animations:Array<Array<String>>, ?loop:Bool):FlxSprite
{
	var sprite:FlxSprite = new FlxSprite(x, y);

	if (animations == null)
	{
		sprite.loadGraphic(Paths.image('stages/tank/' + image));
	} else {
		if (loop == null)
			loop = false;

		sprite.frames = Paths.getSparrowAtlas('stages/tank/' + image);

		for (anim in animations)
			sprite.animation.addByPrefix(anim[0], anim[1], 24, loop);

		sprite.animation.play(animations[0][0]);
	}

	if (addInState == null)
		addInState = true;

	if (addInState)
		add(sprite);

	sprite.scale.x = sprite.scale.y = scale ?? 1;
	sprite.updateHitbox();
	sprite.scrollFactor.x = sprite.scrollFactor.y = scroll ?? 1;
	sprite.antialiasing = ClientPrefs.data.antialiasing;

	return sprite;
}

function onNoteHit(note:Note)
{
	if (getCharacter('extra', 0).name == 'pico-speaker' && note.type == 'extra')
		getCharacter('extra', 0).animation.play('shoot' + (note.data % 2 == 0 ? FlxG.random.int(1, 2) : FlxG.random.int(3, 4)), true);
}

var spawnTimes:Array<Array<Float>> = [];

function createRunningTankmans()
{
	for (note in this.strumLines.extras.members[0].chartNotes)
		if (FlxG.random.bool(16) && note[0] > 1000)
			spawnTimes.push([note[0], note[1] % 2 == 0]);
}

function updateTankmans()
{
	if (spawnTimes.length > 0 && spawnTimes[0][0] <= Conductor.songPosition + 1000)
		createTankman(spawnTimes.shift()[1]);
}

function createTankman(noFlipX:Bool):FlxSprite
{
	var sprite:FlxSprite = new FlxSprite(noFlipX ? 1700 : -800, 200 + FlxG.random.int(50, 100));
	sprite.frames = Paths.getSparrowAtlas('stages/tank/killedTankman');
	sprite.animation.addByPrefix('run', 'tankman running', 24, true);
	sprite.animation.addByPrefix('shot', 'John Shot ' + FlxG.random.int(1, 2), 24, false);
	sprite.animation.play('run', true);
	sprite.animation.curAnim.curFrame = FlxG.random.int(0, sprite.animation.curAnim.frames.length - 1);
	sprite.scale.set(0.8, 0.8);
	sprite.updateHitbox();
	runningTankmans.add(sprite);
	sprite.antialiasing = ClientPrefs.data.antialiasing;
	sprite.flipX = !noFlipX;
	sprite.velocity.x = (750 * FlxG.random.float(0.6, 1)) * (noFlipX ? -1 : 1);

	sprite.animation.onFinish.add(
		(name:String) -> {
			if (name == 'shot')
				runningTankmans.remove(sprite, true);
		}
	);

	FlxTimer.wait(1, () ->
		{
			sprite.animation.play('shot', true);

			if (sprite.flipX)
			{
				sprite.offset.x = 300;
				sprite.offset.y = 200;
			}

			sprite.velocity.x = 0;
		}	
	);
	
	return sprite;
}