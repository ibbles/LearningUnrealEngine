2021-06-21_12:25:46

# In-editor visualization

This note lists various ways that visualizations can be added to Unreal Editor.
These are things that help the game developer understand what is happening behind the scenes.
Things that should not be visible to the player.
This note contains both how to enable visualizations already in Unreal Editor and how to create new ones.


**Component Visualizer**  
Simple line drawing in the Level Viewport that is enabled when an Actor containing that type of Component is selected.

[[2020-08-06_18:48:41]] [Component visualizer](./Component%20visualizer.md)  


**Component Sprite**  
A Component can have a sprite associated with it.
The sprite is always shown in the Level Viewport.
Useful for Components that doesn't have an inherent visual representation.

[[2021-05-06_21:33:14]] [Adding icon-sprite to Actor](./Adding%20icon-sprite%20to%20Actor.md)  
[[2021-04-03_18:13:02]] [Adding icon-sprite to Component](./Adding%20icon-sprite%20to%20Component.md)  


**PhysX collision volumes**

The console command `pxvis collision 1` enables visualization of 