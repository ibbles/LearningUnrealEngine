2020-07-04_15:46:00

# Behavior tree

Is an Asset, which means that it exists in the Content Browser.
Created using right-click in Content Browser, select Actificial Intelligence > Behavior Tree.
A Behavior Tree require a Blackboard, which is also an Asset created in a similar fashion.
The Backboard used by a Behavior Tree is selected in the Behavior Tree's Details panel.

A behavior tree consists of a hierarchy of nodes.
Three main types of nesting:

- Selector. Run a bunch of tasks, stop when one succeeds.
- Sequence. Run a bunch of tasks, stop when one fails.
- Simple parallel. Run a task in parallel with something else.

Simple parallel can be used for supervision.
For example, the main task can be a Move To type of task, and the parallel task can check if the move still makes sense and stop it (`Stop Mevement`) if something changes in the world which makes the move no longer necessary.

Nodes are run left to right.

Some nodes represent Tasks.
Create a new Task using the New Task button in the tool bar.

Nodes are created by right-click and then selecting the node you want.

After instantiating a Task in the Behavioral Tree creating bindings for the Task's public variables in the Details panel.
Bindings assign Blackboard Key Selectors to actual Blackboard keys.
The selector and the key often have the same name.
The public variables and their bindings are also shown in the node in the Behavioral Tree.
The default binding is to SelfActor. Not sure what that means.

[[2020-07-04_16:13:21]] AI task