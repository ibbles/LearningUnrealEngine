2020-05-10_11:04:12

## GameState

Holds the data that defines the state of the game itself, but not that of the individual `Actor`s or players.
For the player data there is the `PlayerState`.
Communicates with the HUD through a game-specific HUD interface.

In Blueprint scripts the GameState is accessed using `GetGameState`. 
The return value is often cast to the game-specific GameState subclass.
Do this in BeginPlay and the cache the result. It is guaranteed to not change during a game session.

Examples of game state:

- Time. In the GameState's EventTick we may update some internal representation of the in-game wall clock time and calendar.

[[2020-03-10_21:29:17]] Actor
[[2020-05-10_11:05:27]] PlayerState
[[2020-05-10_10:35:51]] GUI-HUD