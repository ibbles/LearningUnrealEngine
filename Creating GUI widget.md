2020-07-04_19:53:32

# Creating GUI widget

## Creating new Widget asset

A widget is an asset, so it exists within the Content Browser.
Right-click > User Interface > Widget Blueprint.
Double-clicking a Widget Blueprint opens the Widget Editor.
It contains a Design Board, in the Designer tab, and a Node Graph, in the Graph tab.
Switch tabs in the upper right corner.
GUI Widgets are used both for in-game HUD elements and for full-screen menus.
Variables held by Actors can be displayed in the GUI Widget.


## Adding sub-widgets

Widgets are added by dragging them from the Palette panel into either the Design Board or the Hierarchy panel.
Widgets are renamed in the top of the widget's Details panel.

Widgets can be dragged to any location on the screen.
It is recommended to set an anchor point for each widget.
The anchor point can be any of the sides, corner, center point, row, or column, or the entire canvas.
Not sure when this matters. When using different screen ratios, perhaps.

The default-created root of the Widget, a Canvas Panel, can be removed, making a new Widget component the new root.
Do this when creating sub-Widgets, but keep the Canvas Panel when creating the Widget that will be added to the viewport.


## Displaying data

Many widgets display data.
Such widgets can have a binding.
A bindings is a function that fetch and format that data.
Create a binding for a data field in a Widget's Details panel by clicking Bind > Create New Binding next to the data field in the Details panel.
A new function is created.
The functions can be renamed.
The function need an object reference to read the data from.
It is common to display data from the player character, which can be fetched with the Get Player Character node.

This type of function binding isn't recommended for data that isn't updated every frame since the binding function is called every frame.
Better to have a variable in the Widget, bind to that, and have some other communication mechanism for updating the variable when the data changes.

## Instantiating root widgets

Root Widgets must be instantiated before they are seen.
This can be done from Begin Play, for example in a Player Controller, Pawn or the Level Blueprint.
An instance is created with the Create Widget node.
Select your Widget class from the drop down.
Next add it to the viewport with the Add to Viewport node.
The created Widget is often promoted to a variable.




[[2020-08-10_20:32:35]] [UMG](./UMG.md)  
[[2020-08-10_20:34:24]] [Widget Blueprint](./Widget%20Blueprint.md)  