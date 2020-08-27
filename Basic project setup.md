2020-05-05_11:19:32

# Basic project setup

A basic project consists of the following pieces:

- GameMode
- GameState
- Pawn
- PlayerController

GameMode should be Game Logic.
GameState should be accessible stuffs.

## Game mode

[[2020-04-11_11:26:21]] Game mode

## GameState
<TODO> Add GameState note and a link here. </todo>

## Pawn

The Pawn is the entity that the player controls.
`Character` is a type of Pawn.
It should have a mesh and a camera, and possibly also a CharacterMovement.
The camera is often attached to a spring arm.

[[2020-04-11_09:21:04]] Pawn

## PlayerController

A PlayerController has a Pawn that can be accessed with GetControlledPawn after the OnPossessed event has been triggered.
The PlayerController listens for input events that have been setup in Project Settings > Engine > Input.


[[2020-04-11_11:27:52]] PlayerController
[[2020-07-05_21:45:23]] Basic player setup
