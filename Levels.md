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


## Level streaming

Level streaming is the act of loading in Actors and assets as they are needed as the player moves around a Map.
This is done to improve performance or to allow for parallel level building by the game development team.
The new level storing architecture in Unreal Engine 5 may change this coming from Unreal Engine 4.
In Unreal Engine 5 there i no more a single file on disk per level, but one per Actor in the level.

A Level is a collection of Actors. A Map is a collection of Levels.
Think of a Map as an image of the Levels in that Map as the layers in the image.
Just as the layers in an image can cover different parts of the image, and can be hided or shown individually, the Levels of a Map can populate different parts of the world and can be shown or hidden independently.

There are two types of levels in Unreal Engine: Persistent Levels and Streaming Levels.
The Persistent Levels are always loaded while the associated map is open.
Persistent Levels are opened with the Open Level Blueprint function.
The Persistent Level should contain things that are needed all the time.
A recommendation is things the player can collide with such as ground, floor, and walls.
Things needed to prevent the game from breaking even if the player moves faster than the level streaming.

Open the Levels Panel with Top Menu Bar > Window > Levels.
All the levels in the Map is shown in a list.
From the Levels Panel create a new Level with Levels > Create New….
Typically select Empty Level.
The new Level show up both in the Levels Panel and in the Content Browser.
Do right-click > Change Streaming Method to decide if a Level is Persistent or Streaming.
Click the eye next to the Level in the Levels Panel to show or hide the Actors in that Level in the Viewport.

The Level currently being edited is shown in the lower-right corner of the Viewport.
It's a button that can be clicked to switch which Level is being edited.

Adding Actors to a Streaming Level may display the following warning:
```
Actor will be placed outside the bounds of the current level. Continue?
```
This warning can be disabled from Top Menu Bar >Project Settings > Level Editor > Miscellaneous > Levels > Prompt when adding to level outside bounds.
I would rather learn how to set the bounds of the Level.
Right next to it is Minimum bounds for checking size, perhaps that's the level bounds.

The loading and unloading of Streaming Levels is controlled with Level Streaming Volumes.
They are Actors that can be found in Place Actor Panel > Volumes > Level Streaming Volume.
The Level Streaming Volumes must be added to the Persistent Level.
Check which Level you're currently editing in the lower-right corner of the Viewport.
Each Level Streaming Volume is associated with a set of Streaming Levels and when the player is inside the volume the Streaming level will be active.
Associate a Streaming Level with a Level Streaming Volume by selecting the Streaming Level in the Levels Panel in click the Level Details button next to the Levels button.
In Level Details Panel > Level Streaming > Streaming Volumes add the Level Streaming Volumes you want to associate with the selected Streaming Level.
Place Level Streaming Volumes associated with a Streaming level so that all the Actors in the Streaming Level are covered, but also so that all points from which those Actors can be seen are covered as well.
Consider you level design so that only a limited set of Streaming Levels need to be loaded at any one time for every point in your level.

[Unreal Engine 4 Tutorial - Level Streaming by Ryan Laley @ youtube.com](https://www.youtube.com/watch?v=PyMMgWKd5QM)