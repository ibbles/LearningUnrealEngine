2020-07-04_16:38:27

# Blackboard

A Blackboard is used by a behavior tree.
A Balckboard is a key/value table.
Each value has a type from a list of allowed types.
The generic object reference type is Object.
The Object type can be limited to objects of a specific class, in Blackboard Details > Key > Key Type > Base Class.
Tasks can have variables that point into the Blackboard.
This is done by setting the variable type to `Blackboard Key Selector`.

AIController has a Use Blackboard function.

[[2020-07-04_15:46:00]] [Behavior tree](./Behavior\%20tree.md)  
[[2020-07-04_16:13:21]] [AI task](./AI%20task.md)