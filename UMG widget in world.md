2021-06-13_08:36:54

# UMG widget in world

UMG widgets can be created in the world, as opposed to an on-screen overlay / HUD.
This can be used to create things such as control- and info panels, computer interfaces, buttons and dials, and such.

This is done by adding a *Widget Component* to an Actor.
Widget Component has a *User Interface > Widget Class* property that should be set to the Widget Blueprint that should be shown.
I have not figured out how the make the size of the Widget Component match the size of the Widget Blueprint.
Set *User Interface > Draw Size* so that no content is clipped.

The *widget is oriented* so that is should be viewed from its local positive X axis, down towards smaller X values.
Enable *Rendering > Is Two Sided* to be able to see the widget from both sides.

The rendered widget *does not seem to update itself* when the Widget Blueprint is changed and compiled.
I assume it should, so I may be doing something wrong, or missing a step.
To manually trigger a *reload* of the widget set User Interface > Widget Class to None and then back to your Widget Blueprint.

[[2020-07-04_19:53:32]] [Creating GUI widget](./Creating%20GUI%20widget.md)  
[[2020-08-10_20:34:24]] [Widget Blueprint](./Widget%20Blueprint.md)  
