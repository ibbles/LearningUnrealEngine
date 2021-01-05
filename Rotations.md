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

We can find the principal axes after a rotation by an `FRotator` using `FRotationMatrix`.
Example:
```cpp
const FRotator Rotation = ...;
const FRotationMatrix Matrix(Rotation);
const FVector NewForward = Matrix.GetUnitAxis(EAxis::X);
const FVector NewRight = Matrix.GetUnitAxis(EAxis::Y);
const FVector NewUp = Matrix.GetUnitAxis(EAxis::Z);
```

The same result can be produced with `RotateVector`:
```cpp
const FRotator Rotation = ...;
const FVector NewForward = Rotation.RotateVector(FVector::ForwardVector);
const FVector NewRight = Rotation.RotateVector(FVector::RightVector);
const FVector NewUp = Rotation.RotateVector(FVector::UpVector);
```

[[2020-04-11_08:23:56]] [Coordinate system](./Coordinate%20system.md)  