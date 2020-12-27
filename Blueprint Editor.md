2020-03-12_19:29:24

# Blueprint Editor

The Blueprint Editor is where we design and configure our Blueprint classes.
In the Components Panel we can view and add Components to our Blueprint.
In the Main Tool Bar we can compile and save our Blueprint, and find, settings, defaults, simulation, and play.
Class settings define class specific settings for the Blueprint.
Class default. Default properties for this Blueprint.
What's the difference between Simulation and Play?
Details Panel lists the properties that are available for the currently selected part of the Blueprint.
In the Viewport we can see the components of the Blueprint.

After any change to the Blueprint the Compile button will display a question mark.
Uncompiled changes are visible in the Blueprint Editor only, and not on any instance of the Blueprint.
After a successful compile the question mark will change to a check mark and the changes are applied to the instances.
All uncompiled Blueprints are automatically compiled when starting a Play session or when packaging the game.

Construction Script customizable parameters for the Blueprint.
For example to provide parameters that are visible outside of the Blueprint Editor, for use by artists.
For example a light color or intensity.
The Construction Script is executed every time any change is made to the Blueprint, and when the game begins.

The Event Graph contains the moment to moment script this is run during gameplay.

My Blueprint panel shows graphs, functions, macros, variables, including Components, and event dispatchers.
Event dispatchers are a way to communicate between Blueprints.

Types of nodes that can be added:
- Event. Execution of a network always start at an event.
- Execution. Exection moves from one exeuction node to the next.
- Expression. Execution nodes can take inputs, which are computed with expression nodes.

The list of `EditAnywhere` and `EditDefaultsOnly` `UPROPERTY` C++ class members can be shown in the Details Panel by clicking `Class Defaults` in the tool bar.
The `UPROPERTY` is accessed by right-clicking on the Blueprint grid and typing the name of the `UPROPERTY`.

The parent class of the current Blueprint class is shown in the top right corner of the Blueprint editor.

Variables are added by clicking the `+` next to the `Variables` label in `MyBlueprint` tab.
Variables of object type can be either:

- Object Reference
- Class Reference
- Soft Object Reference
- Soft Class Reference

Object Reference seems to be what one usually wants.
Mark the variable `Instance Editable` to make it show up in the Details Panel.

Instances of classes are created with the `Construct Object From Class` node.

Variables are used by dragging them from the My Blueprint panel into the graph.
Hold `Alt` or `Ctrl` to select get or set.

For more information see [Blueprints](./Blueprints.md).



[[2020-03-09_21:54:48]] Blueprints
[[2020-03-11_21:08:39]] Blueprints and UPROPERTY
[[2020-03-09_21:43:36]] UPROPERTY
[[2020-05-08_22:13:22]] Blueprint macro
