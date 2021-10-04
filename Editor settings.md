2021-06-30_18:09:33

# Editor settings

Set Top Menu Bar > Edit > Editor Preferences > General > Appearance > Asset Editor Open Location to Main Window.

Enable Show Developer Content, Show Engine Content, and Show Plugin Content in Content Browser > View Options.

Components created by a Blueprint's Construction Script are considered internal and are by default hidden in the Component list.
We can show them again by disabling Top Menu Bar > Edit > Editor Preferences > Content Editors > Blueprint Editor > Workflow > Hide Construction Script Components in Details View.
This is not enough to make Components created from C++ visible, I think `AActor::AddInstanceComponent` will do that.