2020-03-12_20:16:37

# Level Blueprint

The Level Blueprint is a Blueprint script that is tied to a particular level.
Used to script level-specific functionality.
The Level Blueprint is accessed from Main Tool Bar > Blueprints > Open Level Blueprint.
A Level Blueprint can have variables, functions, graphcs, macros, and events.
Those are listed in the My Blueprint Panel.
Cannot contain Components and thus does not have a Viewport tab.
Has the Event Graph tab.


Objects (Actors only?) in the level are accessed with `Create Reference To <NAME>`. (Where is this?)

Actors in the level can be dragged from the World Outlines into the Level Blueprint Event Graph.

Some people have a tendency to dump too much logic and responsibility into the Level Blueprint.
Makes functionality difficult to reuse between levels.
Makes a mess.

## Run events from console

Events in the Leevel Blueprint's Event Graph can be run from the Console.
Type `cd <EVENT_NAME>`.
