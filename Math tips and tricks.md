2021-06-05_20:39:15

# Math tips and tricks

## Project look-at to line on plane

This is based on an [Unreal Live Stream](https://www.youtube.com/watch?v=WA8ihra87cM) where a 3D/in-world slider is created and controlled with a look-at type of interaction.
Look at the slider head, hold an interact button, turn the view and the slider head should follow the rotation of the camera but still stay within the bounds of the slider base.
The central part to this is to find where the slider head should be placed on the slider base given an arbitrary camera placement.
The idea is to imagine the slider attached to an infinite plane, as if the slider was screwed in place on a wall.
A line is traced from the camera to the infinite plane and the point on the slider base that is closest to the line/plane intersection becomes the new slider head position.

To do this we need to find the following:
- The plane that the slider is attached to.
- A line from the camera through the center of the view frustum.
- The point where the line intersects with the plane.
- The point on the slider base line that is closest to the line/plane intersection.
- Clamp the slider base line point to the range of the slider base.

It is important to keep track of which coordinate system each of these are computed in.
And to be conscious of any coordinate system conversions that may be necessary.

We will neither create an actual plane geometry nor perform an actual line trace.
Instead everything will be done with linear algebra.

All function names listed below are Blueprint functions but I expect there to be C++ equivalents for all of them.
The logic is expressed as scripts which represents the equivalent node graph.

*The plane that the slider is attached to*
A plane consists of an origin and a normal.
The origin is any point on the plane.
The normal is the vector pointing out of the plane.
The normal is orthogonal to the vector going from the plane origin to any other point on the plane.
In our case the location of the slider Actor is on the plane so we can chose that as the plane origin.
The rotation of the Actor be be used to find the normal, if we know which local direction define the facing direction of the slider.
The default forward direction in Unreal Engine is the X axis. [[2020-04-11_08:23:56]] [Coordinate system](./Coordinate%20system.md)
In the example the slider was oriented in it's local coordinate system facing along the Y axis.
Your particular model may have any direction as its forward, check the viewport.
Following the example, we will use the Y axis here.
```
(self → Target) Get Actor Location (Return Value → Slider Location)
(self → Target) Get Actor Rotation (Return Value → Slider Rotation)
({0.0, 1.0, 0.0} → Vector, Slider Rotation → Rotation) Rotate Vector (Return Value → Slider Facing)

Slider Location → Plane Origin
Slider Facing → Plane Normal
```

*A line from the camera through the center of the view frustum*
We will represent the line with its start and end positions in world space.
```
(0 → Player Index) Get Player Camera Manager (Return Value → Player Camera Manager)
(Player Camera Manager → Target) Get Camera Location (Return Value → Camera Location)
(Player Camera Manager → Target) Get Camera Rotation (Return Value → Camera Rotation)
(Camera Rotation) Get Rotation X Vector (Return Value → Camera Direction)
(Camera Direction → A, 5000.0 → B) * (Return Value → Interact Reach)
(Camera Location → A, Interaction Reach → B) + (Return Value → Interact Reach Location)

Camera Location → Line Start
Interact Reach Location → Line End
```

*The point where the line intersects with the plane*
There is a function that does this for us, Line Plane Intersection.
Its inputs are the things we computed above.
```
(Line Start → Line Start, Line End → Line End, Plane Origin → Plane Origin, Plane Normal → Plane Normal) Line Plane Intersection (Intersection → Line Plane Intersection)

Line Plane Intersection → Look At Point
```

*The point on the slider base that is closest to the line/plane intersection*
To find the point on the slider base that is closest to the line/plane intersection we need to know where the slider base is.
We define this with a begin point and a direction.
We don't yet model the extent of the slider base, just its position and orientation in the world.
In this example, the start of this line is at the slider Actor's position.
That is, the local origin of the slider Actor is at one of the end points of the slider base.
The slider is oriented with the X axis pointing down the slider base.
The line direction is therefore the local X axis transformed to the world space.
We compute the line direction the same way as the plane normal, using Get Actor Rotation and Rotate Vector.
```
(self → Target) Get Actor Location (Return Value → Slider Location)
(self → Target) Get Actor Rotation (Return Value → Slider Rotation)
({1.0, 0.0, 0.0} → Vector, Slider Rotation → Rotation) Rotate Vector (Return Value → Base Direction)
(Look At Point → Point, Slinder Location → Line Origin, Base Direction → Line Direction) Find Closest Point on Line (Return Value → Point On Line)

Point On Line → Slider Target Location
```

*Clamp the slider base line point to the range of the slider base*
The example define two Vector variables that define the range of the slider base in the Actor's local space.
These are named Start and End.
The Slider Target Location we computed above is in world space, we need it in local space.
An Actor's transformation is a local-to-world transformation.
We turn it into a local-to-world by inverting it.
There are helper functions that hides the actual inverting so we don't need to actually invert anything ourselves.
These helper functions may also be faster than explicitly computing the inverse.
The function we need is named Inverse Transform Location.
```
(self → Target) Get Actor Transform (Return Value → Slider Transform)
(Slider Transform → T, Slider Target Location → Location) Inverse Transform Location (Return Value → Local Target)
(Local Target → Value, Begin → Min, End → Max) Clamp (Return Value → Clamped Target)
(Slider → Target, Clamped Target → New Location) Set Relative Location ()
```

## Deproject from screen

Use `APlayerController::DeprojectMousePositionToWorld` to get a world position from a screen coordinate.

## Project to screen

```cpp

/**
 * Project a world position to screen space.
 * The returned
 *   X and Y: Normalized screen coordinates.
 *   Z: In front (>0) or behind (<0) the camera.
 *   W: Distance from the camera.
 *
 * @param Complete model-view-projection matrix.
 * @param The world position to compute the screen space position for.
 */
FVector4 ProjectToScreen(const FMatrix& Matrix, const FVector& WorldPos)
{
    FVector4 Result = Matrix.TransformFVector4(FVector4(WorldPos, 1.0f));
    float ResultW = Result.W;
    if(FMath::IsNearlyZero(ResultW))
    {
        // Avoid division by 0.
        ResultW = (1.e-6f);
    }
    
    // Reciprocal of the Homogeneous W, to get the perspetive effect.
    const float RHW = 1.0f / ResultW;

    return {Result.X * RHW, Result.Y * RHW, Result.Z * RHW, Result.W};
}
```

From [Building Better Blueprints by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=WA8ihra87cM)  
Part 2: [Oct 4, 2018 Unreal Livestream Makeup video by Zak Parrish @ youtube.com](https://www.youtube.com/watch?v=M0MpyfFaPsA)
