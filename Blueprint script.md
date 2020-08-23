2020-05-10_10:56:26

# Blueprint script

Also called a Visual Script or Event Graph.
Looks like a flow chart.
A way to specify/describe functionality without having to write code in text.
Fully integrated into Unreal Editor, no external editor required.
Create and connect nodes which provide functionality.
Execution goes from node to node along the connections.
Execution starts at an Event node. We call this an event pulse.
The pulse propagates through the connected nodes along the wires connecting execution pins.
Common events are BeginPlay and Tick.
Blueprint script is object-oriented, have access to many of the engine's C++ classes.
Either through composition, using Components, class inheritance, or function calls.
Many of the nodes are implemented with C++ code.
C++ classes can be inherited from by a Blueprint class.
Blueprints can be converted to C++ code.
Blueprint scripts are used in many contexts where custom behavior is required.
E.g. the Class Blueprint Event Graph, the Material editor, AI, Animation, HUD, etc.
Actor events, such as `EventTick`, input callbacks, such as `MoveForward`, the level Blueprint, material definitions, and HUD element update bindings are all implemented as a Blueprint script.

[[2020-05-08_22:12:48]] Blueprint function
[[2020-03-12_19:29:24]] Blueprint Editor
[[2020-03-12_20:16:37]] Level Blueprint
[[2020-07-02_15:48:19]] Blueprint script editor