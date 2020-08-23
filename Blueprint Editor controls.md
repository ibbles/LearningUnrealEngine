2020-08-08_14:27:59

# Blueprint Editor controls

Left-click and drag to select multiple nodes.
Right-click and drag to pan around the node graph.
Mouse wheel to zoom.
Default zoom will not go closer than 1:1. Hold Ctrl to zoom closer.

Right-click to open the context menu.
It's a context sensitive list of nodes you can add.
Contents depend on what kind of graph you are in and the current selection.
Selecting a component in the Components panel will show functions that can be called on that component.
Context filtering can be turned off with the checkbox in the top-right.
Allows adding nodes that may not work, use with caution.
The context menu is also shown when dragging off of a node pin.

Types of nodes that can be added:
- Event. Execution of a network always start at an event.
- Execution. Exection moves from one exeuction node to the next.
- Expression. Execution nodes can take inputs, which are computed with expression nodes.

Nodes are connected by left-clicking and dragging off of a node pin.
Execution pins connect to other execution pins, value pins connect to other value pins.
Connection wires are removed by holding Alt and clicking on a pin.
Connection wire ends are moved by holding Ctrl and dragging off of a connected pin.

Comment boxes are created by selecting zero or more nodes and pressing the `c` key.
Can also right-click and select Add Comment from the context menu.
