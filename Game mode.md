2020-04-11_11:26:21

# Game Mode

The rules for the game.
Which Pawn to use for the player, `Default Pawn Class`.
Which PlayerController to use, `Player Controller Class`.
Holds any data or functionality that trancends all the levels.

The selected Pawn should probably contain a `Camera`

The GameMode used is determined by the first of:
- ?game=xxx in the URL. (command line parameter?)
- GameMode Override value set in the World Settings.
- DefaultGameMode entry set in the game's Project Settings.

[[2020-04-11_09:21:04]] Pawn
[[2020-04-11_11:18:18]] PlayerController
[[2020-05-08_21:50:52]] Camera