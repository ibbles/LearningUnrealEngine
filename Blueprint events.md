2020-12-28_13:28:11

## Blueprint events

Events mark the starting point of a Blueprint Visual Script execution.
Events are red nodes that have an output execution pin.
Some events have output data pins as well.
Events are triggered as a response to things happening elsewhere in the system.
The flow of control follows the execution wire from the event's execution pin from execution node to execution node, evaluating the required expression nodes as it goes.

Some nodes take an event as one of its inputs.
For example Set Timer By Event.
The event can be passed by connecting a wire from the red output square on the event to the red input square on the node.
Another way is to create a Create Event node and select the wanted event in the drop-down.


[[2020-07-04_20:32:29]] [Event vs function vs macro](./Event%20vs%20function%20vs%20macro.md)  
[[2021-03-10_10:35:35]] [Timer](./Timer.md)  
[[2020-06-29_13:29:35]] [Events](./Events.md)  
