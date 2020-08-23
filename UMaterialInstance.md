2020-08-11_11:13:52

# UMaterialInstance

The C++ version of a Material Instance.

There are two subclasses of of `UMaterialInstance`: 
- `UMaterialInstanceConstant`: Parameters only editable in editor, not during Play.
- `UMaterialInstanceDynamic`: Parameters also editable during Play.

Use the `Set.+ParameterValue` family of functions to set parameter values.
Always call `PostEditChange` after calling a `Set.+ParameterValue` function.
Examples for `.+`: `Scalar`, `Vector`, `Scalar`.

