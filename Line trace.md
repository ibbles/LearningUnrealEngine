2021-06-05_12:42:40

# Line trace

A line trace is a type of collision query where we ask for overlaps with a line that we provide.
Imagine pointing a laser pointer and getting back the object that the laser hit.
There are a few types of line traces:
- By Channel
- By Profile
- For Objects
I don't really know what these mean.
I have only used By Channel.


## Line Trace By Channel
There are two options for Channel:
- Visibility
I assume this means line trace against everything that is visible.
- Camera
Seem to always it the camera itself.

The Line Trace By Channel node has an Hit output pin that can be split into a whole bunch of stuff.
For a line trace the Location and Impact Point are always the same.
This is because the sweeped shape, a point, has no volume.
Normally Location is the location of the sweeped shape when the overlap happened and Impact Point is the point where the shape and the object touch.


## Line Trace By Profile

## Line Trace For Objects


[[2021-06-05_15:59:02]] [Sphere trace](./Sphere%20trace.md)  
