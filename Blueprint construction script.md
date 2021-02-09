2020-08-08_16:47:45

# Blueprint construction script

A Blueprint construction script is a script that is run when a Blueprint instance is created and every time anything in that Blueprint (variables, variable values, components, etc) is changed in the Blueprint Editor, or any such property is changed on an instance of the Blueprint.
It is like a constructor for the Blueprint class.
A bit like Begin Play, but the result of the script is seen in the Blueprint Editor while desning the Blueprint class.
With the help of the construction script we can setup class configuration variables, which is just Instance Editable variables that are read and acted upon in the construction script.

We can create components in the Construction Script, but they will be… weird.
To see them we need to uncheck Top Menu Bar > Editor Preferences > Content Editors - Blueprint Editor > `Hide Construction Script Components in Details View`.
The properties of a Component created in a Construction Script cannot be edited.
The Details Panel is empty when selecting a Component created in a Construction Script.
All configuration must be done in the Construction Script.
Components created in a Construction Script does not have names.
This makes it very difficult to reference them from other Components.


[[2020-08-08_16:43:21]] Class configuration variable