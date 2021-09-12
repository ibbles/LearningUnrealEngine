2021-09-12_20:07:46

# Level streaming

Level streaming is the act of loading in Actors and assets as they are needed as the player moves around a Map.
This is done to improve performance or to allow for parallel level building by the game development team.
The new level storing architecture in Unreal Engine 5 may change this coming from Unreal Engine 4.
In Unreal Engine 5 there is no longer a single file on disk per level, but one per Actor in the level.

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


## Level Streaming Volumes

The loading and unloading of Streaming Levels is controlled with Level Streaming Volumes.
They are Actors that can be found in Place Actor Panel > Volumes > Level Streaming Volume.
The Level Streaming Volumes must be added to the Persistent Level.
Check which Level you're currently editing in the lower-right corner of the Viewport.
Each Level Streaming Volume is associated with a set of Streaming Levels and when the player is inside the volume the Streaming level will be active.
Associate a Streaming Level with a Level Streaming Volume by selecting the Streaming Level in the Levels Panel in click the Level Details button next to the Levels button.
In Level Details Panel > Level Streaming > Streaming Volumes add the Level Streaming Volumes you want to associate with the selected Streaming Level.
Place Level Streaming Volumes associated with a Streaming level so that all the Actors in the Streaming Level are covered, but also so that all points from which those Actors can be seen are covered as well.
Consider you level design so that only a limited set of Streaming Levels need to be loaded at any one time for every point in your level.

## Loading and unloading Streaming Levels

A Streaming Level can be loaded from a Blueprint Visual Script with the Load Stream Level node or from C++ with a similarly named function, I assume.
A Streaming Level is unloaded with Unload Stream Level.

A Streaming Level can be controlled with a Level Streaming Volume, bringing a particular level in when the player enters the volume and removed when the player leaves the volume.

A Streaming Level can be set to Always Loaded from the Levels Panel right-click menu, so that the Streaming Level is always loaded when the owning Persistent Level is loaded.

A Streaming Level can be controlled by World Composition.
I don't know much about this one.
Levels can have an associated distance group, so that some levels are shown only when they are far away, and other levels are shown when they are close.

[[2021-09-12_20:06:11]] [Sublevel](./Sublevel.md)  
[[2020-04-11_11:58:35]] [Levels](./Levels.md)  
