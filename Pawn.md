2020-04-11_09:21:04

# Pawn

A Pawn is a type of Actor that can be controlled.
By a player with a controller/keyboard/mouse/joystick/etc, or by an AI.
These are represented by a Player Controller or an AI Controller, respectively.
We say that the Pawn is possessed by the Controller.
Can be a character, a vehicle, a fish, etc.
Often comes with a Camera Component which the player sees through while controlling the pawn.
The Game Mode has a default Pawn.

The Pawn has a set of input events that it listens for and reacts to.
Inputs such as key or button presses, mouse clicks and drags, thumb sticks, and triggers.
Unreal Engine maps these device inputs to named input events.
The device input to input event mapping is done in Top Menu Bar > Edit > Project Settings > Engine > Input > Bindings.
The input events can be added to a Blueprint Pawn's Event Graph.
The input events can be bound to a C++ Pawn's member functions in `Pawn::SetupPlayerInputComponent`.

[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  

This paragraph is for C++.
See [[2020-12-31_17:03:18]] [C++ inputs](./C++%20inputs.md) for more details.
`SetupPlayerInputComponent` is a `virtual` function that is called at the beginning of the game.
It is passed a `UInputComponent` on which we create input mapping bindings.
Call `BindAction` and/or `BindAxis` on the `UInputcomponent` to setup input event > member function bindings.

## Spawning

The main Pawn in a level is either one placed in a level or created by the Game Mode.
If the Pawn is placed in the level then set its Details Panel > Pawn > Auto Possess Player property to one of the players.
If created by the Game Mode then:
- Set Game Mode > Details Panel > Default Pawn Class to the wanted Pawn class.
- Set that Game Mode either on the level (World Settings Panel > Game Mode Override) or in Project Settings > Project > Maps & Modes > Default Game Mode.
- Create and position a Player Start Actor. This is where the Pawn will be spawned at the start of the game.

If there is no Player Start then Play In Editor sessions will spawn the Pawn at the current camera location.
I don't know what will happen if the project is packaged and run stand-alone.

[[2020-04-11_11:26:21]] [Game mode](./Game%20mode.md)  

Unreal Engine has a Default Pawn class that is used if no Pawn has been selected.
The Default Pawn is a spectator type Pawn that can fly around the level.


## Possessing

The initial possession happens when the default Pawn is spawned by the game.
See Spawning above.

The Pawn knows which Controller is currently controlling it, if any.
Set to the `AController* Controller` property.

`TODO:` Write about how to move the Player Controller from Pawn to Pawn here.

[[2021-05-30_18:44:11]] [Possessing](./Possessing.md)  


## Movement

There is a lot of movement helper code available if one inherits from Character instead of Pawn.

One way to do movement is to set speed and direction variables based on the input axis values.
Use the speed and direction values in `Tick`.
Get the Actor location, add `Speed * Direction * DeltaTime`, set the Actor location.




## Free-floating top-down view Pawn

For e.g., a RTS or RPG game.
A simple player controlled Pawn is created from a StaticMesh, a SpringArm, and a Camera.
Attach the SpringArm to the StaticMesh and the Camera to the pringArm.
Position and rotate the StaticMesh until you get the view point you want.
The StaticMesh is often a sphere.
I don't know what the purpose of the StaticMesh is.

[[2020-03-10_21:29:17]] [Actor](./Actor.md)  
[[2020-04-11_09:24:51]] [Character](./Character.md)  
[[2020-04-11_11:18:18]] [Controller](./Controller.md)  
[[2020-04-11_11:26:21]] [Game mode](./Game%20mode.md)  
[[2021-01-01_16:41:46]] [C++ Pawn](./C++%20Pawn.md)  
[[2021-05-30_18:44:11]] [Possessing](./Possessing.md)  