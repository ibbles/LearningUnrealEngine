2020-03-09_21:43:36

# UPROPERTY
The `UPROPERTY` decorator macro exposes a `UCLASS` member variable to the Unreal Engine type system, possibly, depending of the specifiers given, making the member variable editable from the Unreal Editor GUI tools and the Blueprint visual scripting language.
`UPROPERTIES` can be primitive types, structs declared with the `USTRUCT(BlueprintType)` specifier, or pointers to classes declared with the `UCLASS(BlueprintType)` specifier and that inherit, ultimately, from `UObject`.
I'm not sure if we can have pointers to `USTRUCT` structures or embedded `UCLASS` objects.

Specifiers can be added to the `UPROPERTY` macro to change the way it behavs within the Unreal Editor.
The following are some of the specifiers available to the `UPROPERTY` macro:

- `BlueprintReadOnly` Blueprints can read, but not write, the property.
- `BlueprintReadWrite` Blueprints can both read and write the property.
- `Category` The category/section/submenu to put the property in in the property editor.
- `EditFixedSize` Only for arrays. The elements can be edited, but the number of elements if fixed.
- `EditInline` Only for pointers. The properties of the pointed-to object is shown instead of the pointer.


- `EditAnywhere` Both the default value set in the Blueprint editor and per-instance values can be edited in the property windows.
- `VisibleAnywhere` The value can be seen, but not edited, both in the Blueprint editor and on a per-instance level.
- `EditDefaultsOnly` The default value can be edited in the Blueprint editor, but not on instances.
- `VisibleDefaultOnly` The default value is visible in the Blueprint editor, but not on instances.
- `EditInstanceOnly` The value can be edited on instances, but the default value is locked.
- `VisibleInstanceOnly` Instance values can be seen, but not edited.

The system:
`Edit` vs `Visible`: Wheter the property can be edited or just seen.
`DefaultsOnly` vs `InstanceOnly`: Wheter the `Editor` or `Visible` part applies to defaults or a particular instance.
`Anywhere`: Both defaults and instance.

The `Blueprint(ReadOnly)|(ReadWrite)` and `(Edit)|(Visible)(DefaultsOnly)|(InstanceOnly)|(Anywhere)` specifiers are independent. One is about Blueprint scripts and the other is about the property windows in the Unreal Editor.




[[2020-03-09_21:34:05]] UCLASS
[[2020-03-09_21:48:56]] UFUNCTION
[[2020-03-09_21:54:48]] Blueprints