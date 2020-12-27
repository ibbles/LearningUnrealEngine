2020-12-27_20:29:38

# Common classes

```
Object
├Actor
 ├Pawn
  └Character
  ─
```

## Object

Base class for many objects in Unreal Engine.
Kept track of by the reflection system.

## Actor

Can be placed in a level.
Can be spawned and destroyed dynamically during runtime.
Can contain Actor Components.
Can be anything from static objects, props, and destructible items.

[[2020-03-10_21:29:17]] [Actor](./Actor.md)  

## Pawn

Can be possessed by a Controller.
Receives input from a player or an AI.
Each game/level has a Default Pawn that is the pawn that the player will control when the game or level starts.

[[2020-04-11_09:21:04]] Pawn  

## Character

A type of Pawn made for humanoid characters.
Has a Capsule Component for collision detection.
Has a Character Movement Component to help with movement.