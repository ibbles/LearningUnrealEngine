2020-08-10_20:34:24

# Widget Blueprint

A Widget Blueprint is an Asset that exists in the Content Browser.
Has an Event Graph.
Has a Designer Tab.
In the Designer Tab we layout visually how the UI elements are to appear.
Can add buttons, checkboxes, text fields, animations, etc. These are all Widgets.
Widgets are added by dragging them from the Palette Panel either to the Designed Viewport or the Hierarchy Panel.
When dragging to the Hierarchy, the orange outline will show if the new component is placed inside/on-top-off another Widget, or before/between/after other widgets.
Some space can be added between Widgets by setting Details > Slot > Padding to some non-zero value.

Rename a Widget in the Hierarchy by pressing F2.

The "flower" is an anchor. It controls what the widget is placed relative to. When resizing the window the anchor position will decide where the widget end up.

Containers are used to place Widgets inside of Widget.
Common containers are Vertical Box and Horizontal Box.
Selecting Details Panel > Layout > Size > Fill will resize the selected Widgets to fill the remaining space of the container. Equally, I think.

Buttons, and other event-generating Widgets, show up in My Blueprint > Variables in the Graph view.


Widgets are instantiated from the Event Graph of a Blueprint class.
Often then Pawn or Player Controller. Is there a recommendation for which to use?
Often in BeginPlay.
The node is named Create Widget.
Select the name of the Widget Blueprint in the Class input.
Often a good idea to save the created in a variable.

Changing Color under the Content category will change the color of everything inside a container.
Changing Color under the Appearance category will change only the selected widget.

Dragging a variable into the Event Graph with Ctrl held will create a get node.
Dragging a variable into the Event Graph with Alt held will create  a set node.

Sometimes we want mouse camera control part of the time, and cursor control at other times.
This is setup in the Pawn Blueprint class.
In BeginPlay, get the Player Controller and call Show Mouse Cursor, passing in true.
Have a variable of type Boolean named `bCameraMove`.
Add Branch nodes between the InputAxis Turn/LookUp events and the Add Controller Input nodes.
Only allow the execution to reach the Add Controller Input nodes if `bCameraMove` is true.
Add a Right Mouse Button event to the Event Graph.
On Pressed, set `bCameraMove` to true. On Released, set `bCameraMove` to false.
Can also call Show Mouse Cursor on the Player Controller here as well.


[[2020-08-10_20:32:35]] UMG
[[2020-07-04_19:53:32]] Creating GUI widget