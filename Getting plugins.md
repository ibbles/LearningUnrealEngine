2020-10-01_20:51:56

# Getting plugins

Adding a plugin into an Unreal Engine project means putting the plugin's folder into the `Plugins` folder of the project.

## Source releases

If the plugin is open source in a public repositor then it is often enough to checkout, clone, or whatever the source control system in question calls it, the repository into the `Plugins` directory.
An example using git:
```
~/UnrealProjects/MyProject/Plugins$ git clone https://github.com/ue4plugins/TextAsset
```

Regenerate project files using `GenerateProjectFiles.(bat|sh)`, close Unreal Editor,  build the project, and relaunch Unreal Editor to use the new plugin.


## Binary releases

[[Build systems]] [Build systems](./Build%20systems.md)