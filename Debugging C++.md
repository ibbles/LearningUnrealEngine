2021-10-04_07:59:28

# Debuggin C++

Build your project either in Debug or Development mode.
Debug:
```
$UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh \
    Linux Debug \
    -Project=$PROJECT_ROOT/$PROJECT.uproject \
    -TargetType=Editor
```
Development:
```
$UE_ROOT/Engine/Build/BatchFiles/Linux/Build.sh \
    Linux Development \
    -Project=$PROJECT_ROOT/$PROJECT.uproject \
    -TargetType=Editor
```

Debug is a bit slower than Development, but the debugger works reliably.
Development has debug symbols but optimizations are enabled so stepping is unpredictable and many variables optimized out.


## Mouse capture

We sometimes want to debug code triggered by a mouse click.
This is problematic because the mouse is captured by Unreal Editor while the click is being processed.
This makes it impossible to use the mouse in other applications, mouse clicks are ignored.
In some Window Managers it is possible to uncapture the mouse cursor again.
In KDE, try Alt+Space, which should open KRunner and give it focus.
In Gnome, try Super+Tab.
In Gnome, it may also help to enable Gnome Tweaks > Windows > Window Focus > Focus on Hover.
You can also create a script that uses `xdotool` to move `windowfocus` to you IDE and bind that to a global hotkey.
Another alternative is a script with `xdotool kex UF86Ungrab` and bind that to a global hotkey.