2022-02-09_12:15:18

# Windowed vs Fullscreen in Packaged Application

## Project Settings File

(
Note to self: Figure out what to write to which file to have packaged applications run in windowed mode by default.
)

## Installation Settings File

Whether to use a window or fullscreen when launching a packaged application is controlled from `GameUserSettings.ini`.
This file is in `<EXPORT_DIR>/<PROJECT_NAME>/Saved/Config/LinuxNoEditor/GameUserSettings.ini`.
Add the following:
```
[/Script/Engine.GameUserSettings]
FullscreenMode=2
LastConfirmedFullscreenMode=2
PreferredFullscreenMode=2
ResolutionSizeX=1920
ResolutionSizeY=1080
LastUserConfirmedResolutionSizeX=1920
LastUserConfirmedResolutionSizeY=1080
DesiredScreenWidth=1920
DesiredScreenHeight=1080
LastUserConfirmedDesiredScreenWidth=1920
LastUserConfirmedDesiredScreenHeight=1080
Version=5
```

`FullscreenMode` is one of
- 0 = Fullscreen
- 1 = Windowed fullscreen
- 2 = Windowed

Not sure why the window size is specified so many times, or what each is used for.

The `Version=5` line is important.


I have not been able to get this to work in Shipping builds, only Development.
Not sure why that would be, or what to do instead.


## Command line arguments

I believe there are command line arguments to set windows mode and window size as well.
https://docs.unrealengine.com/4.27/en-US/ProductionPipelines/CommandLineArguments/ claim that `ResX=1920 ResY=1080 WINDOWED` should work, but I still get a fullscreen window.

I saw another example where someone had `-ForceRes` and `-`s on the other parameters.
```
-Windowed -ForceRes -ResX=1920 -ResY=1080
```

## Blueprint script

The Game Mode Blueprint script can get the user settings with `GetGameUserSettings` and on that change the fullscreen mode.
Call `Apply Settings` on `GameUserSettings` to have the changes take effect.