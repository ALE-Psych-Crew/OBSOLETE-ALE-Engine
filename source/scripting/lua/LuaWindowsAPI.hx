package scripting.lua;

import cpp.*;

import winapi.WindowsAPI.MessageBoxIcon;

class LuaWindowsAPI extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('sendNotification', WindowsAPI.sendNotification);
    
        set('setDesktopPosition', function(?x:Int, ?y:Int)
            {
                if (x != null)
                    WindowsAPI.moveDesktopWindowsInX(x);
    
                if (y != null)
                    WindowsAPI.moveDesktopWindowsInY(y);
            }
        );
    
        set('toggleTaskbar', WindowsAPI.hideTaskbar);
    
        set('obtainRAM', WindowsAPI.obtainRAM);
    
        set('screenCapture', function(path:String)
            {
                WindowsAPI.screenCapture(Paths.modFolder() + '/' + path);
            }
        );
    
        set('getCursorX', WindowsAPI.getCursorPositionX());
    
        set('getCursorY', WindowsAPI.getCursorPositionY());
    
        set('setWindowBorderColor', WindowsAPI.setWindowBorderColor);
    
        set('showMessageBox', function(title:String, message:String, icon:String)
            {
                WindowsAPI.showMessageBox(title, message,
                    switch (icon.toUpperCase().trim())
                    {
                        case 'ERROR':
                            MessageBoxIcon.ERROR;
                        case 'QUESTION':
                            MessageBoxIcon.QUESTION;
                        case 'WARNING':
                            MessageBoxIcon.WARNING;
                        default:
                            MessageBoxIcon.INFORMATION;
                    }
                );
            }
        );
    
        set('clearTerminal', WindowsAPI.clearTerminal);
    
        set('showConsole', WindowsAPI.showConsole);
    
        set('setConsoleTitle', WindowsAPI.setConsoleTitle);
    
        set('disableCloseConsole', WindowsAPI.disableCloseConsoleWindow);
    
        set('hideConsole', WindowsAPI.hideConsoleWindow);
    }
}