2020-05-08_22:13:22

## Blueprint macro

A Blueprint macro is similar to a Blueprint function.
A macro acts as-if the nodes in the macro had been placed into the calling Blueprint.
A macro can use time-based features such as Delay and Timeline.
A macro can be created by selecting a bunch of Blueprint nodes, right-click, select `Collaps to Macro`.
A macro can have inputs, each with a name and a type.
The output exec pin can be named `then` to signal that it's the default output exec pin.

Macros can be used for Blueprint execution initialization, for example to set local variables from casts.
By creating the macro in one Blueprint we can copy the macro node to a new Blueprint, double-click to open, right-click each Set variable and select Create Local Variable to create the variables in the new Blueprint as well.

[[2020-05-08_22:12:48]] Blueprint function