2021-06-05_12:05:01

# Scene Component

A Scene Component is a Component that has a placement, i.e., position and rotation, within the owning Actor.
Many of the build-in Components inherit from Scene Component.

A Scene Component can be used to mark positions within an actor, for example for an attachment point.

Scene Components form a hierarchy.
Child components apply their own transformation on top of the transformation of the parent.
Moving one Scene Component will move all child Scene Components as well.

A Scene Component is attached to another Scene Component with the Attach To Component function.
There are two Attach To Component functions, one on Scene Component and one on Actor.

UE4.45: The function names may have changed. We now have Attach Component to Component and a separate Attach Actor To Component.

[[2020-04-03_09:42:50]] [Components](./Components.md)  