2020-12-30_19:06:05

# Tick

A "tick" is when the game world is moved from one state to the next.
It often corresponds to the change from one frame to the next.
Many classes, such as `AActor` and `UActorComponent`, has a `Tick` callback function.
This function takes a `float DetalTime` parameter, which is the amount of time that has passed since the previous tick.
