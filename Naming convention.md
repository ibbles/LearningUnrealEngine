2020-03-10_21:23:32

# Naming convention
Classes, structs, and other types in an Unreal Engine projects should be prefixed according to the following:

- `A`: Classes inheriting from Actor.
- `U`: Classes inheriting from UObject.
- `T`: Template classes.
- `F`: Other classes and structs.
- `E`: Enum

Assets should be follow the following naming convention:

Template: `<type>_<name>[_<revision>][_variant]`
- `type`: A abbreviation of the type of the asset.
- `name`: A user-defined name.
- `revision`: A counter for how many revisions of the asset there has been. Optional.
- `variant`: Used if several assets of the same type is required to make a whole. Optional.

Some examples:
- `BP_<name>`: Blueprint class.
- `M_<name>`: Material.
- `MF_<name>`: Material function.
- `MI_<name>`: Material instance.
- `SKM_<name>`: Skeletal mesh.
- `SM_<name>`: Static mesh.
- `T_<name>`: Texture.
- `T_<name>_D`: Texture containing diffuse colors.
- `T_<name>_BC`: Texture containing base colors.
- `T_<name>_N`: Texture containing normals.
