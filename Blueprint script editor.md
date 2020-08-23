2020-07-02_15:48:19

# Blueprint script editor

The Blueprint script editor is where game logic is created using a network of nodes.
Each node is either an execution node or an expression node.
Execution nodes have the white arrow execution pins.
Execution flows from the left to the right through the nodes along the wires.
Execution starts at an Event Node, colored in red.
Computation of expressions are performed on demand.
When an execution node has an input pin connected to an expression node, then that node is evaluated.
If the expression node has input pins of its own, then those expression nodes are evaluated as well.
An expression node is evalutated, i.e., executed, every time its value is requested.

Create new nodes along an execution path by dragging off of an execution pin and select a function from the list that appars.

Wire enpoints can be moved by holding control and dragin off of a connected pin.
New nodes are created either by right-click on the background, or by draging off of a pin.

Move the viewport to an event node by double-clicking it in the Graphs section of the My Blueprint panel.

After pasting code between Blueprints that contains variables that the receiving Blueprint doesn't have, right-click the variable reference and select `Create variable`.

[[2020-05-08_22:13:22]] Blueprint macro