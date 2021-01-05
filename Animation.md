2021-01-04_19:23:55

# Animation

The Character (or any Actor? Pawn?) talks to an Anim Instance to drive animation.
Decides which animation to play at each point in time.
We can create our own subclasses of Anim Instance, both C++ and Blueprint.
To create a C++ subclass one must check the Show All Classes checkbox in the New C++ Class wizard.
Has a virtual member function named `NativeInitializeAnimation`.
Is called once at the beginning of the game.
The Anim Instance can get access to the Pawn it's animating through `TryGetPawnOwner`.

To create a new Blueprint subclass select Content Browser > Context Menu > Animation > Animation Blueprint.
The Animation Blueprint class can have the C++ Anim Instance class as its base class.

Each Anim Instance is associated with a skeleton.
Blueprint animations are opened in the Animation Editor.
Has an Event Graph and an Anim Graph.

An Animation Blueprint consists of the following levels, each nested inside the one above:
- AnimInstance (C++ class)
- Animation Blueprint (Can inherit from AnimInstance)
- Anim Graph
- State Machine
- State
- Transition Rule

The Anim Graph contains one or more State Machines.
Each state in each State Machine is associated with one of the animations available for the skeleton selected for the Anim Instance.
Each State Machine is typically associated with some family of animations, such as ground locomotion.
The Anim Graph has an Output Pose Node.
The output from a state machine connects to the input of the Output Pose.

Each State Machine contains a graph starting with an Entry node with an execution pin.
New states are created by dragging off of the execution pin and selecting Add State….
Each state has a name that describe what the Actor is doing when that state is active.
The state that is connected to the Entry node is the default state, the state in which the Actor starts.
States are connected by Transition Rules by dragging off of the border of one and connecting it to another.
The Transition Rules determine when and to which new state a transition should happen.
A State Machine can contain nested State Machines.

In a State Machine, double-click a Transition Rule to open it.
The Transition Rule Graph as an Result output node that takes a Can Enter Transition bool input.
The Transition Rule Graph can contain nodes that call into the C++ code for the Anim Instance.

States are themselves graphs, with an Output Animation Pose node.
The State tab of the Animation Editor has an Asset Browser Panel.
There all the available animations are listed.
Drag one into the State Graph to create a Play Animation node.
Connect the Play Animation node's output pin to the input pin of the Output Animation Pose node to play that animation.
The speed of the animation can be set in the Play Animation node's Detail Panel > Play Rate.
Check the checkbox to the right of Details Panel > Play Rate to make it a node input.
This is how we programmatically and dynamically control the animation speed, for example from the Character's movement speed.

A sibling of sort to the Anim Graph is the Event Graph.
It contains the Event Blueprint Update Animation execution start node.
This event is fired every frame.
This is where we can read and store state used by the Transition Rules in the State Machines.

An animation is assigned to a Character in the Character sub-class' Details Panel with the Mesh Component selected.
Set Mesh > Animation > Animation Mode to Use Animation Blueprint.
Set Mesh > Animation > Anim Class to your Animation Blueprint.