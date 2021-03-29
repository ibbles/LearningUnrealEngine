2021-03-20_09:31:05

# Timeline

A Timeline is a node in a Blueprint Visual Script.
A Timeline is a repeated callback that for each call pass one or more values to the callback.
Each value is a called a track.
Each value appear as an output pin on the Timeline node.
Each track has a type: float, vector, color, or event.
Curves are used to define the function used to compute a float track's value at any point in time.
As time progresses the timeline sweep along the curve.
A timeline has a length that define the number of seconds it should take to complete a sweep.
The shape of the curve is defined by points.
Add points with shift+left-click.
The curve editor can do interpolation between points.
Right-click a node to select between interpolation modes.
