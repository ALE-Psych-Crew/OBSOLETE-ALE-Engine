package core.backend;

#if cpp
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

import sys.thread.Thread;

import cpp.Function;
import cpp.RawConstPointer;
import cpp.RawPointer;
import cpp.ConstCharStar;

import lime.app.Application;

class DiscordRPC
{
    public static var initialized:Bool = false;

    private static var presence:DiscordRichPresence = new DiscordRichPresence();

    @:unreflective private static var thread:Thread;

    public static function initialize(id:String)
    {
        if (!ClientPrefs.data.discordRPC)
            return;

        var eventHandlers:DiscordEventHandlers = new DiscordEventHandlers();
        eventHandlers.ready = Function.fromStaticFunction(onReady);
        eventHandlers.disconnected = Function.fromStaticFunction(onDisconnected);
        eventHandlers.errored = Function.fromStaticFunction(onError);

        Discord.Initialize(id, RawPointer.addressOf(eventHandlers), false, null);

        if (!initialized)
            dcTrace('Client Initialized');

        if (thread == null)
        {
            thread = Thread.create(function():Void
                {
                    while (true)
                    {
                        #if DISCORD_DISABLE_IO_THREAD
                        Discord.UpdateConnection();
                        #end

                        Discord.RunCallbacks();

                        Sys.sleep(1);
                    }
                }
            );
        }

		Application.current.window.onClose.add(function()
            {
			    if (initialized)
                    shutdown();
		    }
        );

        initialized = true;
    }

    public static function shutdown()
    {
        initialized = false;

        Discord.Shutdown();
    }

    public static function changePresence(details:String, ?state:String, ?largeImage:String, ?smallImage:String, ?usesTime:Bool = false, ?endTime:Float = 0)
    {
        var startTime:Float = 0;

        if (usesTime)
            startTime = Date.now().getTime();

        if (endTime > 0)
            endTime = startTime + endTime;

        presence.state = state;
        presence.details = details;
        presence.largeImageKey = largeImage;
        presence.largeImageText = 'Engine Version: ' + CoolVars.engineVersion;
        presence.smallImageKey = smallImage;
        presence.startTimestamp = Std.int(startTime / 1000);
        presence.endTimestamp = Std.int(endTime / 1000);

        updatePresence();
    }

    public static function updatePresence()
    {
        Discord.UpdatePresence(RawConstPointer.addressOf(presence));
    }

    private static function onReady(request:RawConstPointer<DiscordUser>):Void
    {
		final user:String = request[0].username;
		final discriminator:Int = Std.parseInt(request[0].discriminator);

	    dcTrace('Connected to User ' + (discriminator == 0 ? user : user + ' #' + discriminator));
    }

	private static function onDisconnected(errorCode:Int, message:ConstCharStar):Void
	{
		dcTrace('Disconnected (' + errorCode + ': ' + message + ')');
	}

	private static function onError(errorCode:Int, message:ConstCharStar):Void
	{
		dcTrace('Error ' + errorCode + ': ' + message);
	}

	private static function dcTrace(data:Dynamic)
	{
		debugTrace(data, CUSTOM, 'DISCORD', 0xFF5865F2);
	}
}
#else
class DiscordRPC
{
    public static var initialized:Bool = false;

    private static var presence:Dynamic = null;

    public static function initialize(id:String) {}

    public static function shutdown() {}

    public static function changePresence(details:String, ?state:String, ?largeImage:String, ?smallImage:String, ?usesTime:Bool = false, ?endTime:Float = 0) {}

    public static function updatePresence() {}

    private static function onReady(request:Dynamic):Void {}

	private static function onDisconnected(errorCode:Int, message:Dynamic):Void {}

	private static function onError(errorCode:Int, message:Dynamic):Void {}

	private static function dcTrace(data:Dynamic) {}
}
#end