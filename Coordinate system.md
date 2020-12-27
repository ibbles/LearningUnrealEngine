2020-04-11_08:23:56

# Coordinate system

Unreal uses a left-handed coordinate system with:
X: Forward.
Y: Right.
Z: Up.

Each object with a transformation has both a global/world and a local/object space.
Switch mode with the Cycle Transform Gizmo Coordinate System button in the top-right of the viewport.

We can find the current transformation of an `Actor` using `GetActorTransform`.
We can find the current transformation of a `Component` with `GetComponentTransform`.
We can find the local/relative transformation of a Component with `GetRelativeTransform`.
With a `Transform` we can do `TransformDirection`.



[[2020-03-10_21:29:17]] [Actor](./Actor.md)  
[[2020-04-03_09:42:50]] [Components](./Components.md)  
[[2020-08-10_14:32:14]] [Rotations](./Rotations.md)  