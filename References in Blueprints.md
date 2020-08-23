2020-08-23_10:19:06

# References in Blueprints

Setting references in the Blueprint Editor doesn't work like in the Level Editor.
In the Level Editor, at least for Blueprint references, one have a picker button next to each reference variable and clicking that let's one click on an Actor in the viewport and the reference is then set to that Actor.
This doesn't work on Components, and doesn't work in the Blueprint Editor.
There is no picker icon and the drop-down menu doesn't contain the Components owned by the Blueprint.
The built-in physics uses names.
The referencing component has a hidden reference and a public name.
On BeginPlay a lookup is made using the name and the reference set to whatever is found.
I don't like it, names are hard and brittle. Changing the name of a component doesn't update the references.
An alternative approach is to set the reference in a Blueprint Script, either the Construction Script or BeginPlay.
The advantage here is that we can drag out the object we want to reference into the graph and use it directly as a parameter to a Set node.
This seems safer.
I currently prefere the Construction script because that makes the binding visible in the Level Editor on an instance of the Blueprint.
The drawback is that the reference is fixed, a Level Designer cannot change it on an instance of the Blueprint.
