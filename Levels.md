2020-04-11_11:58:35

# Levels

The default level is set in the Project Settings → Maps & Modes.
Can set editor default and game default separately.
When exporting a game we can list the levels that should be exported.
`TODO:` Where do we list this?


## Level switching

To switch between levels, call the Open Level Blueprint function.
The function takes a single input that is the name of the level to switch to.
The player will be spawned at the Player Start in the new level.
Each Player Start can have a tag, which is of type string.
Set it with Player Start > Details Panel > Object > Player Start Tag.
Which one is selected is controlled by the current Game Mode, through it's Choose Player Start virtual function.
You can override this in your Game Mode derived class.
The return value is a Player Start.
Can find all Player Starts in the level with Get All Actors of Class, selecting Player Start for Actor Class.
Can use the Game Instance to transfer data from the end of one level to the start of the next.
Use whatever logic you need to select on of the Player Starts based on the data you stored in the Game Instance.
Often doing something with Player Start > Get Player Start Tag.

Unfortunately, overriding Choose Player Start doesn't seem to actually place the player at that Player Start.
Seems to me that it should.
To actually place the Player at the chosen Player Start we use Begin Play Event in the Level Blueprint.
From the Begin Play Event, call Get Game Mode -> Find Player Start -> Get Actor Transform.
Pass the returned transform to Get Player Character -> Set Actor Transform.

You may want to hide the level loading transition somehow, but the video doesn't describe how.
Maybe a full-screen UMG widget. Maybe with a progress bar. I wonder how one get the level loading progress.

[Unreal Engine 4 Tutorial - Level Travelling by Ryan Laley @ youtube.com](https://www.youtube.com/watch?v=4fGuPd6Hkzs)

[[2020-03-12_20:16:37]] [Level Blueprint](./Level%20Blueprint.md)  
[[2021-09-12_20:06:11]] [Sublevel](./Sublevel.md)  
[[2021-09-12_20:07:46]] [Level streaming](./Level%20streaming.md)  


[Unreal Engine 4 Tutorial - Level Streaming by Ryan Laley @ youtube.com](https://www.youtube.com/watch?v=PyMMgWKd5QM)