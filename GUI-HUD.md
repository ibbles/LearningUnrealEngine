2020-05-10_10:35:51

## GUI / HUD

A HUD is a way to provide 2D visual feedback and interaction to a user.
Text, sliders, etc.


GUIs are built from `Widgets`.
Works much like many other GUI tool kits in that `Widgets` are placed into container `Widgets`.
A new `Widget` is created in the Content Browser by right-click → User Interface → Blueprint Widget.
The `Widget` editor contains two parts: Designer and and Graph.
The Designer part is where sub-widgest are created and placed.
The Graph part is where behavior and functionality is added.
A HUD is created from the `PlayerController`'s `BeginPlay` by calling `CreateWidget`.
The HUD needs something to talk to in order to get state updates and send user input.
It therefore be given a `PlayerController` variable that is marked Expose on Spawn.
The widget needs an Owning Player, which should be <TODO more text here.>
The created widget is added to the viewport with `Add to Viewport`.


The Designer contains a 2D viewport showing all the sub-`Widget`s that has been added to the new `Widget`.
A library of widgets is listed in the Palette Panel.
A tree of added widgets is shown in the Hierarchy Panel.
Added widgets have an anchor point that define what it will be positioned relative to.
Often a screen corner or edge center.
Set in the Details Panel when the widget is selected.
Data displays, such as text boxes, have bindings.
A binding is a function that is called when widget is to be rendered.
Set in the Details Panel next to the field where the default data is set.
A binding function is just like any other Blueprint script, built as a network of nodes.
The return value is the data that is shown on screen.
The data is often passed to the GUI by a game logic entity, such as an `Actor` or the `GameState`.
The game-specific HUD should implement a game-specific HUD interface that e.g., the `GameState` can have a reference to.
The interface should contain functions for setting the data that the HUD should display.
Or maybe events, I'm getting mixed signals from Unreal Editor.
The interface has functions, but I get the message "Interface <name> is already implemented as a function graph but is expected as an event.".
In the HUD Blueprint: add the interface from Class Settings, compile, right-click Event Graph viewport, search for the event name, implement the data setter from the execute pin.
Each data widget binding function should read, process, and format the data received and stored by the interface functions.


Buttons have OnClicked events.
Add a script to a button by clicking the `+` next to the OnClicked event in the Events section of the Button's Details Panel.
The event is added as an execution node in the Graph part of the `Widget` editor.
Buttons often trigger functions in the game-specific interface that the HUD implements.
Call such functions as a Message, not a reguilar call.
I don't know why, or even what that means.

The interface is also implemented by the `PlayerController`.
Shows up as Events in the `PlayerController` Blueprint script, when added.
When the HUD Blueprint send the Event Message then the corresponding event is triggered in the `PlayerController`.


`SetInputModeGameAndUI` is used to specify something. What?

[[2020-05-10_11:04:12]] GameState
[[2020-05-10_10:56:26]] Blueprint script
[[2020-05-10_11:07:00]] Interface
[[2020-04-11_11:27:52]] PlayerController