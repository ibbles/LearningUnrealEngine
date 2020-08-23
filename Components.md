2020-04-03_09:42:50

# Componets

Components are the pieces that make up a Blueprint.
Components are added to Actors to give them behaviors/functionality.
They are building blocks.
A Component must have the `BlueprintSpawnableComponent` metadata specifier in order to be added to an Actor.
There are two types of Components: `UActorComponent` and `USceneComponent`.
There are many subclasses of each.
`USceneComponent` inherits from `UActorComponent`.
`USceneComponents` have a transformation and can he arranged in a hierarchy, making the transformations relative to each other.
