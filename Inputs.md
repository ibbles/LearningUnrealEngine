2020-04-10_21:46:17

# Inputs

Inputs are named events that the user can trigger and that Blueprints listen for.
Example input event names are "Jump" and "Move Forward".
Each input event is bound to some hardware device input.
Such as key or button presses, mouse clicks and drags, thumb stick angle, and triggers.
Bindings are created in Top Menu Bar > Edit > Project Settings > Engine > Input > Bindings.
There are Action Mappings and Axis mappings.
`Action mappings` are one-off binary pressed/released events, like keys and buttons.
`Axis mappings` are continuous both in time and value, like thumb sticks, joysticks, and mouse movements.
Axis events are fired every frame, with a potentially new value every time.
We can bind many keys/sticks to each mapping, i.e., we can have several buttons for "Jump".
We can bind keys and buttons to axis mappings and set a scale that can be negative.
This makes it possible to have keyboard fallback for events that are usually continuous.
For example, `w` can be bound to the axis event "Forward" with the value 1 and `s` to the same axis event with the value -1.
If multiple device inputs bound to the same input event is held then their values are aggregated before passed to the callback.

Input events are bound to `callbacks`.
The callbacks can be in the currently possessed Pawn, the Player Controller, the Level Blueprint, or an input-enabled/accepts-input Actor.
Enable input for an Actor instance by calling the Enable Input function.

[[2021-06-05_12:17:19]] [Enable input](./Enable%20input.md)  

So the order is hardware device input > input event > callback function.
The callback function owners are considered in the following order:
- Input-enabled / accepts-input Actor.
- Player Controller.
- Level Blueprint.
- Possessed Pawn.

We can also bind low-level inputs directly, i.e., create keyboard, mouse, and gamepad event nodes.
In an Actor's Event Graph, right-click and select something from the Gamepad or Keyboard categories.
These low-level events must be enabled in an actor by calling Enable Input, passing in Get Player Controller, in BeginPlay.
The recommended way to bind inputs is with proper input events, not binding to the device inputs directly.

Some Components have build-in events that can be added to a Blueprints event graph.
`TODO:` List some examples here. I don't know any, so not sure what I meant here.
Select a Component in the Components panel in the Blueprint Editor and scroll the Details panel down to the Events category.
Click the `+` next to the event you want.
It is not possible to create these events when multiple Components are selected.

Movement inputs on a Pawn can either be handled directly and manually, i.e., with `SetActorLocation` and such,
or with a Movement Component.
The Character class comes with an Character Movement Component that handles a bunch of movement related tasks.
The Movement Component is usually accessed through the Pawn member function families `AddControllerInput` and `AddMovementInput`.

[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-11_09:24:51]] [Character](./Character.md)  
[[2020-12-31_17:03:18]] [C++ inputs](./C++%20inputs.md)  
[[2021-06-05_12:17:19]] [Enable input](./Enable%20input.md)  
[[2020-04-10_21:40:28]] [~TwinStickShooter](./%E7TwinStickShooter.md)  
[[2020-03-09_21:54:48]] [~Blueprints](./%E7Blueprints.md)  
