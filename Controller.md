2020-04-11_11:18:18

# Controller

Drives a `Pawn`.
Two kinds: `PlayerController` and `AIController`.
User interacting with the game pad causes events to fire in the `PlayerController`.
The `PlayerController` hold input functionality for the game.
The `PlayerController` sends generic signals out to the `Pawns`.
An `AIController` is a brain that you can plug into a `Pawn`.

[[2020-04-11_09:21:04]] Pawn
[[2020-04-11_09:24:51]] Character
[[2020-04-11_11:27:52]] PlayerController
[[2020-04-11_11:28:47]] AIController
