2020-05-08_22:26:42

# Blueprint variables

A variable is a container for data.
Number, string, arrays, etc.

Variables are *created* in a Blueprint by clicking the `+` next to the `Variables` section title of the `My Blueprint` panel.
Each variables has a name, a type, and a category.
A default value can be set once the variable has been given a type and the script been compiled.
The type can be either a primitive type (Boolean, Integer, Float, String, Vector, etc), a structure, an object reference, or a class reference.
Each variable can be a single value, an array, a set, or a map.

The *Instance Editable* checkbox makes the variable show up in the Details Panel when an instance of the Blueprint class is selected in the Level Viewport so that a level designer can decide what the value of that variable should be for that particular instance.

The *Blueprint Read Only* checkbox controls whether or not it should be possible to modify the variable's value during runtime from a Blueprint script.

The *Show 3D Widget* checkbox is only available on variables of type Vector.
It will render an octahedron in the viewport that can be moved around with the regular Transform Gizmo.
The relative position of that octahedron becomes the value of the Vector variable.

[[2020-04-11_08:29:46]] [Object placement and positioning](./Object%20placement%20and%20positioning.md)  

The *Enabling Expose on Spawn* checkbox makes this variable an input pin on Spawn Actor and Add Component nodes.

*Blueprint Read Only* means that Blueprints can't change the variable's value from Visual Scripts, not even Visual Scripts within the class itself.

I don't know what *Expose to Cinematics* means.
Obviously, it exposes the variable to cinematics, but I don't know what that _actually_ means.

Setting a *Category* on a variable puts it in that collapsible group within the Details Panel when an instance of this Blueprint class is selected in the Level Viewport.
The categories (appear to be, verify) sorted by inheritance order with immediate members at the top and variables of more and more distance ancestors further and further below.
It could also be that immediate members are at the top and inherited, regardless of from where, is placed below in some other order.
Variables can be put into inherited categories. That will place the variable in the lower category in the Details Panel when an instance is selected in the Level Viewport rather than moving the category up or splitting the category in two.


