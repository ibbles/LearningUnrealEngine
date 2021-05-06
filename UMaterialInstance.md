2020-08-11_11:13:52

# UMaterialInstance

The C++ version of a Material Instance.

There are two subclasses of of `UMaterialInstance`: 
- `UMaterialInstanceConstant`: Parameters only editable in editor, not during Play.
- `UMaterialInstanceDynamic`: Parameters also editable during Play.

Use the `Set.+ParameterValue` family of functions to set parameter values.
Always call `PostEditChange` after calling a `Set.+ParameterValue` function.
Examples for `.+`: `Scalar`, `Vector`.

[[2020-05-10_11:01:04]] [Materials](./Materials.md)  
[[2021-05-06_08:51:54]] [UMaterial](./UMaterial.md)  
[[2020-08-11_13:53:42]] [UMaterialInstanceConstant](./UMaterialInstanceConstant.md)  
[[2020-08-11_13:53:57]] [UMaterialInstanceDynamic](./UMaterialInstanceDynamic.md)  
