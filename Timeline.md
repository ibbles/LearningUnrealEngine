2021-03-20_09:31:05

# Timeline

A Timeline is a node in a Blueprint Visual Script, specifically the Event Graph.
A Timeline is a repeated callback that for each call pass one or more values to the callback.
Each value is a called a track.
Each value appear as an output pin on the Timeline node.
Open the Timeline Editor by double-clicking the Timeline node.
Each track has a type: float, vector, color, or event.
Curves are used to define the function used to compute a float track's value at any point in time.
As time progresses the timeline sweep along the curve.
A timeline has a length that define the number of seconds it should take to complete a sweep.
The shape of the curve is defined by points.
Add points with shift+left-click.
The curve editor can do interpolation between points.
Right-click a node to select between interpolation modes.

A Timeline is an asynchronous construction.
It does not need to be triggered by the Event Graph on every tick.
Instead it will act as an execution source, like an event node, while the Timeline is active.
