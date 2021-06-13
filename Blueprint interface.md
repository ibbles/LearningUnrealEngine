2021-06-05_16:16:53

# Blueprint interface

A Blueprint Interface is a set of functions that Blueprint classes implementing the interface must (can?) provide the implementation for.

Create a new Blueprint Interface by Content Browser > right-click > Blueprints > Blueprint Interface.
To make a Blueprint class implement an interface, add the interface to Class Settings > Interfaces > Implemented Interfaces.

The implementation points are red event nodes in the Event Graph, one for each function.
Implement the logic and behavior off of the execution pin of the event node.
Add the event node by right-click the Event Graph background and select Add Event > Event *Interface function name*.


The functions in an Interface can be called on anything.
If the thing does implement the interface, then its implementation of the function is called.
If the thing doesn't implement the interface, then nothing happens.

[Building Better Blueprints by Unreal Engine @ youtube.com](https://www.youtube.com/watch?v=WA8ihra87cM)

[[2020-05-10_11:07:00]] [Interface](./Interface.md)  