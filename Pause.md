2020-08-24_15:32:07

# Pause

`Set Game Paused` Blueprint node.
Calls `SetPause` on the active Player Controller.

Setting time dialation to zero is another way to stop everything.


@Dieter on Unreal Slackers Discord:  
> It seems to add the player state to paused player states, which in turn influences the return value of UWorld::IsPaused(), which is used in the UWorld::Tick to check if the game is paused, and if it is, the delta time does not get updated and it does not perform the tick on actors
> oh, I did also put CustomTimeDilation = 1.f on that same actor
> maybe that's relevant

If you Pause game, all your delay and timeline stuff freeze too, even if timeline has Ignore time dilation and actor has tick when paused.


Camera while paused:
https://www.tomlooman.com/moving-camera-paused-ue4/

> You can enable camera movement while the game is paused by setting a few simple options: bShouldPerformFullTickWhenPaused and bIsCameraMoveableWhenPaused.