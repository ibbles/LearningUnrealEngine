2020-07-04_16:13:21

# AI task

A Task is how we cause things to happen in a Behavior tree.
A task is a Blueprint Script that has a collection of events.

Created by clicking the New Task button in the Behavior Tree tool bar.
Tasks are Assets, so they get added to the Content Browser, in the same folder as the Behavior Tree, and with a default generated name. Rename it.
Also set Details panel > Description > Node Name to something sane.
The Node Name will be used when creating instances of the Task in a Behavior Tree.

Tasks get events that it can respond to.
One important event is `Receive Execute AI`.
This is where the actual work happens.
Given the Controller and the Pawn.
Should end with a `Finish Execute` node.

Another event is `Receive Abort AI`.
Here we often clear Blackboard values for the old action.
For moving Pawns we often call `Stop Movement` on the Owner Controller.
Abort paths should end with a `Finish Abort` node.

Tasks end with Finish Execute.
Has a success boolean output.

Tasks contains variables.
A special variable type is `Blackboard Key Selector`.
This creates a variable that points into the AI's Blackboard.
Such variables must be marked editable, i.e., the eye next to the variable must be open.
Blackboard variables should never be Set.
Instead use the `Set Blackboard Variable` nodes.
We clear a Blackboard value with `Clear Blackboard Value`.
This is the same as a variable `Set` with no given value.
References are set to null.

There are a few built-in tasks:

- Wait.

[[2020-07-04_15:46:00]] Behavior tree