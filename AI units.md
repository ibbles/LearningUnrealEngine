2020-12-26_20:07:31

# AI units

In this section we create a AI controlled unit that moves around.
It is based on the following tutorial:

Unreal Engine Beginner Tutorial: Building Your First Game  
https://www.youtube.com/watch?v=QJpfLkEsoek  
Creates evil cubes.

The first step is to create the AI, the brain of the 

Create a new Blueprint class with `AIController` as parent named `UnitAI`.
In the event graph, add an `AI MoveTo`.
Drag from the `Pawn` pin and select `Get Controller Pawn`.
This find find the pawn that this AI is attached to.
Create a `Set Timer by FunctionName` to have the `AI MoveTo` trigger every now and then.
Give it the function name `MoveToCorner`, set time to 1.0, and enable looping.
Right-click and create a custom event with the same name, i.e., `MoveToCorner`.
Drag from `Event BeginPlay` to the timer to start the timer loop.
Connect `MoveToCorner` to `AI MoveTo`.
Now the `AI MoveTo` will be called once every second.

The second step is to create the unit that the AI is controlling.
Create a new blueprint class with `Pawn` as the parent.
Add static meshes of whatever else you want for a visual representation.
Also add a `Floating Pawn Movement`.
This is where we define how the unit is allowed to move.
Speed and acceleration and the like.
Select the root object, i.e. the `Pawn`, in the `Components` tab and look at the `Pawn` section of the details tab.
Find `AI Controller Class` and set it to the `UnitAI` class we created previously.

The third step is to create a navigation mesh.
In the `Place` mode, under `Volumes`, find `Nav Mesh Bounds`.
Scale it to cover the entive level.
In the viewport, click `Show` in the top-left and then click Nativation.
Walkable areas will be colored green.
There must be a mesh to walk on, so make sure you have a floor.
Not sure how to do a flying unit.