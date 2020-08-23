2020-03-10_21:29:17

# Actor

An Actor is something that can be placed in the world.
There are many types and subclasses of Actor.

Actors can be created from a Blueprint script with the `SpawnActor` node.
Select the type of `Actor` to spawn from the drop-down, or pass in as a parameter.

`Actor`s can inherit from each other.
To create a child class, right-click the parent Blueprint and select Create Child Blueprint Class.
Components, functions, macros, variables, and events are inherited by the child.
When a function or an event takes a `class` of the parent type a child type can be passed.



[[2020-04-11_09:21:04]] Pawn
[[2020-04-11_09:24:51]] Character
[[2020-05-10_18:32:07]] Custom event