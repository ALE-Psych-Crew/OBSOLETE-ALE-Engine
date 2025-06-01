package utils;

import flixel.util.FlxSave;

import core.structures.OptionsCategory;
import core.structures.OptionsOption;

class ALESave
{
    public var preferences:FlxSave;

    public var custom:FlxSave;

    public var controls:FlxSave;

    public function new()
    {
        preferences = new FlxSave();
		preferences.bind('preferences', CoolUtil.getSavePath(false));

        custom = new FlxSave();
        custom.bind('custom', CoolUtil.getSavePath());

        controls = new FlxSave();
        controls.bind('controls', CoolUtil.getSavePath(false));
    }

    public function loadPreferences()
    {
		if (preferences.data.settings != null)
		{
			for (field in Reflect.fields(preferences.data.settings))
				if (Reflect.field(ClientPrefs.data, field) != null)
					Reflect.setField(ClientPrefs.data, field, Reflect.field(preferences.data.settings, field));
		}

        if (custom.data.settings != null)
        {
            ClientPrefs.custom = custom.data.settings;
                    
            if (Paths.fileExists('options.json'))
            {
                var jsonData:Dynamic = Json.parse(File.getContent(Paths.getPath('options.json')));

                if (jsonData.categories is Array)
                    for (cat in cast(jsonData.categories, Array<Dynamic>))
                        if (cat.options != null)
                            for (option in cast(cat.options, Array<Dynamic>))
                                if (Reflect.fields(CoolUtil.save.custom.data.settings).contains(option.variable))
                                    Reflect.setField(ClientPrefs.custom, option.variable, Reflect.field(CoolUtil.save.custom.data.settings, option.variable));
                                else
                                    Reflect.setField(ClientPrefs.custom, option.variable, option.initialValue);
            }
        } else {
            ClientPrefs.custom = {};
        }

		if (ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		} else {
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
    }

    public function savePreferences()
    {
		preferences.data.settings = ClientPrefs.data;
		preferences.flush();

		custom.data.settings = ClientPrefs.custom;
		custom.flush();
    }

    public function loadControls()
    {
        if (controls.data.settings != null)
            ClientPrefs.controls = cast controls.data.settings;
    }

    public function saveControls()
    {
        controls.data.settings = ClientPrefs.controls;
        controls.flush();
    }
}