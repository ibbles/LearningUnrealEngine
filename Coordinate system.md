2020-04-11_08:23:56

# Coordinate system

Uneral uses a left-handed coordinate system with:
X: Forward.
Y: Right.
Z: Up.

Unreal Engine uses a left-handed coordinate system with X forward, Y right, and Z up.
We can find the current transformation of an `Actor` using `GetActorTransform`.
We can find the current transformation of a `Component` with `GetComponentTransform`.
We can find the local/relative transformation of a Component with `GetRelativeTransform`.
With a `Transform` we can do `TransformDirection`.



[[2020-03-10_21:29:17]] Actor
[[2020-04-03_09:42:50]] Components