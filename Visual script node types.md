2021-05-31_18:05:37

# Node types

## AI

[[2020-07-04_19:50:49]] [~AI](./%E7Collection%20AI.md)  

## Animation

## Blueprint

- Execution node.
Any node that has the white execution pins. The execution nodes are executed when the flow of execution reaches the node's execution input pin. When executed, the node first evaluates its input pins and then performs its action. Then execution continues to the execution node connected to the output execution pin. Execution nodes can have side effects that alters the state of the game.

- Expression node.
Nodes without an execution pin. The sole purpose of expression nodes is to return one or more values at their output pins, which can be connected to the input pin of another node, either an expression node or an execution node. An expression node is evaluated when an input pin connected to one of the node's output pin is evaluated. When evaluated, the expression node will first evaluate its input pins, then do its computation, and then send the computed value(s) to the output pin(s). Expression nodes should not have any side effects.

- Event node. Red title background.
A type of execution node. The event node is the source of a flow of execution. Something external to the node graph triggers the event and the flow of execution starts.

- Function node. Blue title background.
A function is an abstraction for multiple connected nodes. When the function node, also called a function call node, is executed the flow of execution jumps from the function node to the function's node graph, starting at the function's entry node and executing until it reaches one of its return nodes. The values at the function node's input pins are passed to the output pins of the entry node in the function's node graph. When the return node is reached the values passed to the input pins of the return node are assigned to the output pins of the function node's output pins and execution continue from the output execution pin on the function node.

- Function entry and return nodes. Purple title background.
Flow control nodes for entering and exiting a function. Only exists within functions. Never in the Event Graph.

[[2020-12-28_13:28:11]] [Blueprint events](./Blueprint%20events.md)  

## Material

##  Niagara

