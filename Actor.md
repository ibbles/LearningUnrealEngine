2020-03-10_21:29:17

# Actor

An Actor is something that can be placed in the world.
There are many types and subclasses of Actor.

Actors can be created from a Blueprint script with the `SpawnActor` node.
Select the type of Actor to spawn from the drop-down, or pass in as a parameter.

Actors can inherit from each other.
Components, functions, macros, variables, and events are inherited by the child.
When a function or an event takes a `class` of the parent type a child type can be passed.

Unreal Engine comes with a large library of Actor classes, both ready for use and intended for subclassing.
Commonly subclassed Actor classes are Pawn, Character, Controller.

## Creating new Actor classes

To create a Blueprint child class from a Blueprint class, right-click the parent Blueprint and select Create Child Blueprint Class.
To create a Blueprint child class from any parent class, right-click the Content Browser and select Create Basic Asset > Blueprint Class.
To create a C++ Actor class either right-click the Content Browser and select C++ Class or create the `.h` and `.cpp` files in the proper subdirectories of a module's `Source` directory.

## Actor Components

Actors can contain Actor Components.


[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-11_09:24:51]] [Character](./Character.md)  
[[2020-05-10_18:32:07]] [Custom event](./Custom%20event.md)  
[[2020-12-30_17:02:30]] [C++ Actor](./C++%20Actor.md)  
[[2020-09-10_19:55:50]] [Modules](./Modules.md)  
[[2020-04-03_09:42:50]] [Components](./Components.md)  
