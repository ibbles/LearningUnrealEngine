2020-08-04_21:51:14

# Blueprints
A Blueprint is a container for content.
Different types of blueprints can hold different things.
Each Blueprint has a certain structure, which is described by the Blueprint class.
Such as Components, variables, functions, events, scripts, etc.
For example, an Actor Blueprint can contain meshes, lights, sounds, logic, event calls.
Each Blueprint class has a parent class.
A Blueprint class inherits from a parent class, OO-style.

A new Blueprint class is created by right-click in the Content Browser and select Blueprint Class.
An instance of a Blueprint is created in the level by dragging it from the Content Browser to the Level Viewport.
Multiple instances can be created from the same Blueprint.
Changing the Blueprint will change all instances.

The behaviors/logic within a Blueprint is defined by Blueprint scripts.
A Blueprint script is also called an Event Graph.

Blueprint is Event Based.
Events trigger the execution of a node network.
Nodes can trigger other Events, causing a chain of events to execute.

Blueprint uses references to access data and functionality in other Blueprints.
References can be set to none.
Beware of circular dependencies.
Beware of invalid references, causes errors.
Errors show up in the Message Log.


Blueprint scripts run in a virtual machine.
There is a performance cost with using a Blueprint over C++ code.
Much of what is done with Blueprints can also be done with C++.
There are some C++ APIs that are not yet exposed to Blueprints.




[[2020-05-10_10:56:26]] Blueprint script
[[2020-08-10_20:09:42]] Types of Blueprints
[[2020-04-03_09:42:50]] Components
[[2020-05-10_10:56:26]] Blueprint script
[[2020-08-10_20:15:40]] Blueprint class