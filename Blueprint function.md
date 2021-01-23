2020-05-08_22:12:48

# Blueprint function

A function is container for nodes.
Each Function Graph has a purple execution start node.
They function very much like the red Event Nodes in that execution starts here and flows along the wires connected to the execution pins.
Functions are added to a Blueprint by clicking the `+` button in the title of the Functions category of the My Blueprint panel in the [Blueprint Editor](./Blueprint%20Editor.md).

A Blueprint function is similar to a Blueprint macro.
A function does an actual call.
Functions are executed immediately when the execution reaches the node.
This is different from Events, which are executed later.

A function can have inputs and outputs. These are the function's parameters and return values.
Inputs and outputs are added in the `Details` Panel in the function's tab when the function execution start node, the purple one, is selected.
Each input and output has a name and a type.
A function as an `Access Specifier`.
* Public: Any other Blueprint can call this function.
* Protected: Only the Blueprint itself and its children (subclasses?) can call the function.
* Private: Only the Bluepritn itself can call the function.
A function can be `Pure`, means that it doesn't have execution pins.
It becomes an expression node rather than an execution node. Evaluated when needed by an execution node.
Functions are called in the Blueprint itself by dragging it from the `Functions` section of the `My Blueprint` tab.
Functions are called from other Blueprints by dragging off of a reference to an instance of the Blueprint class and selecting the function in the list.

A function call is a node with a blue cursive `f` first in the title of the node, and the rest of the title is the name of the function.
Hover over the data pins to see what type they take.

A function cannot use time-based features such as Delay or Timeline.

Functions can be called either on `Self`, when we're in the Blueprint of the class itself, or on a reference to an instance of the Blueprint owning the function, if we have a reference to the instance, the reference has the correct type (and not that of a parent class) and the function is public.

[[2020-05-08_22:13:22]] [Blueprint macro](./Blueprint%20macro.md)  
[[2020-03-12_19:29:24]] [Blueprint Editor](./Blueprint%20Editor.md)  