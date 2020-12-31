2020-11-30_10:36:27

# Creating components in constructor

Only components created in an Actor's constructor will show up in the Blueprint Editor.
Create the components with `CreateDefaultSubobject`.
The function may only be called in the constructor of the owning object, the object that has the pointer as a member variable.
It is a template function, with the type parameter being the the type to instantiate.
It takes (at least?) one parameter, which is the label/name of the created object.

```cpp
MyProperty = CreateDefaultSubobject<UMyType>(TEXT("MyLabel"));
```

It is common to not configure a lot of details on the created components.
In particular, one rarely assign assets to e.g. meshes in C++.
It is better to assign assets in a Blueprint subclass of the C++ class, or in instance of the C++ class in the Level Editor.
Because asset references in C++ are clunky and cannot be automatically updated by Unreal Editor the way Blueprint references can.


> TODO: Add text here about attachments and such.

Always close Unreal Editor when compiling changes to constructors or header files.
Really, always close Unreal Editor when compiling.