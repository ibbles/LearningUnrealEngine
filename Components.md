2020-04-03_09:42:50

# Componets

Components are objects that belong to other objects.
Components are the pieces that make up an Actor.
Components are added to Actors to give them behaviors/functionality.
They are building blocks.
Using a mesh to give an Actor a visual representation is one use of a Component.
A Component must have the `BlueprintSpawnableComponent` metadata specifier in order to be added to an Actor in Unreal Editor.
There are two types of Components: `UActorComponent` and `USceneComponent`.
There are many subclasses of each.
`USceneComponent` inherits from `UActorComponent`.
`USceneComponents` have a transformation and can he arranged in a hierarchy, making the transformations relative to each other.

Component instances are created using factory functions.

[[2020-12-31_12:14:21]] [Constructing objects](./Constructing%20objects.md)  
[[2020-03-10_21:29:17]] [Actor](./Actor.md)  
