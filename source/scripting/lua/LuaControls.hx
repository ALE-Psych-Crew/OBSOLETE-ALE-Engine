package scripting.lua;

class LuaControls extends LuaPresetBase
{
    override public function new(lua:LuaScript)
    {
        super(lua);

        set('getKeybindState', function(id:String)
            {
                return switch (id.toUpperCase())
                {
                    case 'NOTE_LEFT':
                        Controls.NOTE_LEFT;
                    case 'NOTE_LEFT_P':
                        Controls.NOTE_LEFT_P;
                    case 'NOTE_LEFT_R':
                        Controls.NOTE_LEFT_R;
                        
                    case 'NOTE_DOWN':
                        Controls.NOTE_DOWN;
                    case 'NOTE_DOWN_P':
                        Controls.NOTE_DOWN_P;
                    case 'NOTE_DOWN_R':
                        Controls.NOTE_DOWN_R;
                        
                    case 'NOTE_UP':
                        Controls.NOTE_UP;
                    case 'NOTE_UP_P':
                        Controls.NOTE_UP_P;
                    case 'NOTE_UP_R':
                        Controls.NOTE_UP_R;
                        
                    case 'NOTE_RIGHT':
                        Controls.NOTE_RIGHT;
                    case 'NOTE_RIGHT_P':
                        Controls.NOTE_RIGHT_P;
                    case 'NOTE_RIGHT_R':
                        Controls.NOTE_RIGHT_R;

                    case 'UI_LEFT':
                        Controls.UI_LEFT;
                    case 'UI_LEFT_P':
                        Controls.UI_LEFT_P;
                    case 'UI_LEFT_R':
                        Controls.UI_LEFT_R;

                    case 'UI_DOWN':
                        Controls.UI_DOWN;
                    case 'UI_DOWN_P':
                        Controls.UI_DOWN_P;
                    case 'UI_DOWN_R':
                        Controls.UI_DOWN_R;

                    case 'UI_UP':
                        Controls.UI_UP;
                    case 'UI_UP_P':
                        Controls.UI_UP_P;
                    case 'UI_UP_R':
                        Controls.UI_UP_R;

                    case 'UI_RIGHT':
                        Controls.UI_RIGHT;
                    case 'UI_RIGHT_P':
                        Controls.UI_RIGHT_P;
                    case 'UI_RIGHT_R':
                        Controls.UI_RIGHT_R;

                    case 'ACCEPT':
                        Controls.ACCEPT;
                    case 'BACK':
                        Controls.BACK;
                    case 'RESET':
                        Controls.RESET;

                    case 'MOUSE_WHEEL':
                        Controls.MOUSE_WHEEL;
                    case 'MOUSE_WHEEL_DOWN':
                        Controls.MOUSE_WHEEL_DOWN;
                    case 'MOUSE_WHEEL_UP':
                        Controls.MOUSE_WHEEL_UP;

                    case 'MOUSE':
                        Controls.MOUSE;
                    case 'MOUSE_P':
                        Controls.MOUSE_P;
                    case 'MOUSE_R':
                        Controls.MOUSE_R;

                    default:
                        false;
                }
            }
        );
    }
}