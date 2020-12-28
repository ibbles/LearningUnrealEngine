2020-08-08_16:47:45

# Blueprint construction script

A Blueprint construction script is a script that is run when a Blueprint instance is created and every time anything in that Blueprint (variables, variable values, components, etc) is changed in the Blueprint Editor, or any such property is changed on an instance of the Blueprint.
It is like a constructor for the Blueprint class.
A bit like Begin Play, but the result of the script is seen in the Blueprint Editor while desning the Blueprint class.
With the help of the construction script we can setup class configuration variables, which is just Instance Editable variables that are read and acted upon in the construction script.

[[2020-08-08_16:43:21]] Class configuration variable