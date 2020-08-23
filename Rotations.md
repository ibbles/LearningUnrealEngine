2020-08-10_14:32:14

# Rotations
Unreal uses a left-handed coordinates system with the X-axis pointing forward.

| Axis of rotation | Axis motion | Effect | Handedness |
|------------------|-------------|--------|------------|
| Positive around X | Z → Y | Roll right | Right-handed |
| Positive around Y | X → Z | Pitch up | Right-handed |
| Positive around Z | X → Y | Yaw right | Left-handed |

The `FRotator` triple-float constructor doesn't take it's arguments in the regular
`around-X`, `around-Y`, `around-Z` (or roll, pitch, yaw) order.
Instead it takes them in
`around-Y`, `around-Z`, `around-X` (pitch, yaw, roll) order.
`amount-to-lift-X`, `amount-to-turn-Y`, `amount-to-tilt-Z`.

The Blueprint `Make Rotator` node follows the traditional (roll, pitch, yaw) order.



[[2020-04-11_08:23:56]] Coordinate system