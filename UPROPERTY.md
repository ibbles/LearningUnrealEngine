2020-03-09_21:43:36

# UPROPERTY
The `UPROPERTY` decorator macro exposes a `UCLASS` member variable to the Unreal Engine type system, possibly, depending of the specifiers given, making the member variable editable from the Unreal Editor GUI tools and the Blueprint visual scripting language.
`UPROPERTIES` can be primitive types, structs declared with the `USTRUCT(BlueprintType)` specifier, or pointers to classes declared with the `UCLASS(BlueprintType)` specifier and that inherit, ultimately, from `UObject`.
I'm not sure if we can have pointers to `USTRUCT` structures or embedded `UCLASS` objects.
Pointers to `UCLASS` classes (and possibly `USTRUCT` structs) participate in garbage collection / reference counting.

Specifiers can be added to the `UPROPERTY` macro to change the way it behaves within Unreal Editor.
The following are some of the specifiers available to the `UPROPERTY` macro:

- `BlueprintReadOnly` Blueprint Visual Scripts can read, but not write, the property.
- `BlueprintReadWrite` Blueprint Visual Scripts can both read and write the property.
- `Category` The category/section/submenu to put the property in in the property editor / Details Panel.
- `EditFixedSize` Only for arrays. The elements can be edited, but the number of elements if fixed.
- `EditInline` Only for pointers. The properties of the pointed-to object is shown instead of the pointer. See more below.


- `EditAnywhere` Both the default value set in the Blueprint editor and per-instance values can be edited in the property windows.
- `VisibleAnywhere` The value can be seen, but not edited, both in the Blueprint editor and per-instance in the Level Editor.
- `EditDefaultsOnly` The default value can be edited in the Blueprint editor, but not on instances.
- `VisibleDefaultOnly` The default value is visible in the Blueprint editor, but not on instances.
- `EditInstanceOnly` The value can be edited on instances, but the default value is locked.
- `VisibleInstanceOnly` Instance values can be seen, but not edited.

The system:
`Edit` vs `Visible`: Whether the property can be edited or just seen.
`DefaultsOnly` vs `InstanceOnly`: Whether the `Editor` or `Visible` part applies to defaults or a particular instance.
`Anywhere`: Both defaults and instance.

The `Blueprint(ReadOnly)|(ReadWrite)` and `(Edit)|(Visible)(DefaultsOnly)|(InstanceOnly)|(Anywhere)` specifiers are independent. One is about Blueprint Visual Scripts and the other is about the property windows in the Unreal Editor.

Components created with `CreateDefaultSubobject` should never be `Edit<something>`, only `Visible<something>`.
Components created with `CreateDefaultSubobject` should never be `BlueprintReadWrite`, only `BlueprintReadOnly`.
The Components are still editable even though they are set to Read Only.
It is the Component pointer that is Read Only, not the Component itself.
So  Read Only Component cannot be replaced with another Component.
Setting Read Write and then replacing the Component afterwards will mess up serialization.
It is safe to replace Components created by a parent class in the child class' constructor.
```cpp
UPROPERTY(VisibleAnywhere, BlueprintReadOnly)
UMyComponent* MyComponent; // Possible to edit the Component, but not the pointer.
```

To read the value of a `UPROPERTY` in a Blueprint Visual Script, right-click the Visual Script background and type `get <NAME>`.
An expression node with the variable's current value as its only output pin is created.
To set the value of a `UPROPERTY` in a Blueprint Visual Script, right-click the Visual Script background and type `set <NAME>`.
An execution node is created with the variables new value as its only input pin is created.

## EditInline

The point of the "Instanced" keyword and "EditInlineNew" is that you create them in-place.
(
Not sure what I mean by this. Trying a different forumulation:
)

An array of pointers to class instances, such as `TArrach<UMyClass*>`, can be configured to create actual instances when manipulated in Unreal Editor, instead of just a collection of `nullptr`. We do this by marking the array with the `Instanced` Property Specifier and the class that the array holds with `EditInlineNew`.

```cpp
UCLASS(EditInlineNew)
class MYMODULE_API UMyClass : public UObject
{
    GENERATED_BODY();
};

UCLASS()
class MYMODULE_API UMyManager : public UObject
{
    GENERATED_BODY();
public:
    UPROPERT(EditAnywhere, Instanced)
    TArray<UMyClass*> ManagedThings;
};
```


[[2020-03-09_21:34:05]] [UCLASS](./UCLASS.md)  
[[2020-03-09_21:48:56]] [UFUNCTION](./UFUNCTION.md)  
[[2020-03-09_21:54:48]] [Blueprints](./Blueprints.md)  
