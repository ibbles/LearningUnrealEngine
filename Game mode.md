2020-04-11_11:26:21

# Game Mode

The rules for the game, such as win states and lose states.

The Game Mode is a Blueprint.
Create a new Game Mode by Content Browser > right-click > New Class > Game Mode Base.
Set the project's default Game Mode in Project Settings > Project > Maps & Modes > Default Modes > Default Game Mode.
This value can be overridden on a per-level basis.
The Game Mode is created when a level is loaded, and destroyed with the level.


The Game Mode contains the following important settings:
- Game Session Class.
- Game State Class.
- Player Controller Class. Which Player Controller to use,
- Player State Class.  
Holds any data or functionality that transcends all the levels.
(
Not sure if this should be on Player Controller or Player State.
)
(
How can anything survive between levels if the entire Game Mode is destroyed and recreated on level transitions?
)
- HUD Class.
- Default Pawn Class. Which Pawn to use for the player, unless override for a particular level.
- Spectator Class.
- Replay Spectator Player Controller
- Server Stat Replicator Class.



The selected Pawn should probably contain a `Camera`

The Game Mode used is determined by the first of:
- `?game=xxx` in the URL. (command line parameter?)
- Game Mode Override value set in the World Settings.
- Default Game Mode entry set in the game's Project Settings.

To set the Game Mode for a particular level, overriding the project's Game Mode, change Level Editor > Toolbar > Settings > World Settings > Game Mode Override.

To set the Default Game Mode for the project, change Project Settings > Maps & Modes > Default Game Mode.

The default Pawn type can be set in a C++ `AGameModeBase` subclass with the following code:
```cpp
static ConstructorHelpers::FClassFinder<APawn> PlayerPawnClass(
    TEXT("Blueprint'/Game/Blueprints/BP_MyPawn'"));
if (PlayerPawnClass.Class != nullptr)
{
    DefaultPawnClass = PlayerPawnClass.Class;
}
```

The path is found by right-click on the Blueprint class for the Pawn in Unreal Editor and selecting Copy Reference.
Delete the extra `.<CLASS NAME>` part at the end, it shouldn't be there.
The principle is the same for the `PlayerControllerClass` inherited member variable.
The code tries to load the Blueprint at the given path.
The `.Class` member that we access on the `FClassFinder` is of type `TSubclassOf<APawn>`.
`TSubclassOf` is part of the reflection system.
It is a pointer to a class, not to an object. Well, to an object that represents a class.

A Blueprint Game Mode inheriting from your C++ Game Mode class can be created.
Not sure what the point of that is though.
To create Blueprint Visual Script functions and variables, perhaps.

[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-11_11:18:18]] [PlayerController](./PlayerController.md)  
[[2020-05-08_21:50:52]] [Camera](./Camera.md)  