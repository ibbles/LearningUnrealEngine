2020-07-04_20:32:29

# Event vs function

Functions have return values.
Functions can have local variables.
Events can use Delay and Timeline nodes.
Events can be replicated.
Event graphs can have multiple entry points and merging flow.
Events can have functions/other events bound to them. (Check this)

Functions represent an abstraction of a side effect or computation. It is executed immediately within the bounds of the calling graph/script. The calling script will not continue until the function has completed. Function calls are blocking.

An event forms a separate chains of execution. The event is put on the task queue and will be execute at some point by the task system. Event triggering is asynchronous.

[[2020-12-28_13:28:11]] [Blueprint events](./Blueprint%20events.md)  