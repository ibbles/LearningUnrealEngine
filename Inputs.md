2020-04-10_21:46:17

# Inputs

Inputs are named events that the user can trigger and that Blueprints listen for.
They are created in the Project Settings, the Engine → Input category.
There are Action Mappings and Axis mappings.
Action mappings are one-off binary pressed/released events, like keys and buttons.
Axis mappings are continuous both in time and value, like thumbstics and joysticks.
We can bind many keys/sticks to each mapping, i.e., we can have several buttons for "jump".
We can bind keys and buttons to axis mappings and set a scale that can be negative.
This makes it possible to have keyboard fallback for events that are usually continuous.

We can also bind low-level inputs directly, i.e., create keyboard, mouse, and gamepad event nodes.
In an Actor's Event Graph, right-click and select something from the Gamepad or Keyboard categories.
These low-level events must be enabled in an actor by calling Enable Input, passing in Get Player Controller, in BeginPlay.

Some Components have build-in events that can be added to a Blueprints event graph.
Select a Component in the Components panel in the Blueprint Editor and scroll the Details panel down to the Events category.
Click the `+` next to the event you want.
It is not possible to create these events when multiple Components are selected.

[[2020-04-10_21:40:28]] [col] TwinStickShooter
[[2020-03-09_21:54:48]] [col] Blueprints

