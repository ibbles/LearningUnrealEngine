2020-04-11_08:29:46

# Object placement and positioning

## Editor

Switch to the Move, Rotate, and Scale tools with W, E, and R, respectively.
This changes the shape of the transform gizmo/widget in the viewport.
Or Space to cycle between them.
Hold Alt when moving to duplicate the object.
Hold shift when moving to move the camera with the object.
Works with multiple selected objects as well.

- `Ctrl`+`LMB`: Move/rotate/scale selected object along X.
- `Ctrl`+`RMB`: Move/rotate/scale selected object along Y.
- `Ctrl`+`LMB`+`RMB`: Move/rotate scale selected object along Z.

Grid snapping is enabled in the top-right corner of the viewport.
There are multiple snapping grid sizes to chose from.
Snapping happens in local space, not world space.
Meaning that if snapping is 10 then the object will move in steps of ten.
Not snap to the nearest world coordinate evenly divisible by ten.
```
new_pos = old_pos + n*snap_size
```
where the integer `n` is the number of `snap_size` that the cursor is moved.

Next to Grid Snapping there is a button labeled Surface Snapping.
This will make the moved object align its Z axis (I think) along the normal of the object it's placed on.

When dragging in Actors from the Content Browser or the Place Actors Panel the Actor will snap to the world grid but not while still moving, only when released.

World building is easier if tileable building blocks match one of the available snap sizes.

Each object with a transformation has both a global/world and a local/object space.
Switch mode with the Cycle Transform Gizmo Coordinate System button in the top-right of the viewport.
`Ctrl`+`\`.

Multiple objects can be grouped together with `Ctrl`+`g`.
Grouped objects are selected and transformed together.
The group is represented by a Group Actor in the World Outliner.
Ungroup the group with `Shift`+`g`.

An Actor instance can be replaced by another by right-click > Replace Selected Actor With.
This is useful when a bunch of Actors, meshes for example, has been created procedurally and we want to manually add some variation.


## Runtime

Objects can be positioned/placed/posed relative to their attachment parent with Set Relative Transform.
There is also Set Relative Location, Set Relative Rotation, and Set Relative Scale 3D.
The same set of functions also exist for World instead of Relative.

Scene Components can be attached to other Scene Components.
With Attach Component to Component, or Attach Actor to Component.




[[2021-06-05_12:05:01]] [Scene Component](./Scene%20Component.md)  
