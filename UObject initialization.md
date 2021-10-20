2021-06-21_17:08:23

# UObject initialization

`UObject` has a bunch of callbacks that are called during different parts of the initialization.

- `PostInitProperties`: Called immediately after the UProperties has been given their default values from the Class Default Object.
  Is it always the Class Default Object, or is it whatever template the object has? I.e., will the UProperties get values set in a Blueprint?
- `PostLoad`: Called when the object is loaded from something. Not called when created with an Actor' Add Component button.

## Play In Editor session

The following steps are taken when a `UObject` is created as part of world duplication when creating a Play In Editor session.

- **Allocation**  
I don't know much about the memory handling strategy employed by Unreal Engine, but in some way a bunch of bytes are allocated for the new object.
- **Zeroing**  
All the bytes of the allocated memory are are set to zero. This means that all `bool` will be `false`, all integers will be `0`, all floating points will be `0.0`, and all pointers will be `nullptr` when the constructor starts.
This is not something that's done universally in Unreal Engine, so don't mindlessly assume that all members of all classes are zeroed.
- **Construction**  
The constructor for the object is run. The constructor is responsible for setting up the default state of the object.
- **`FObjectInitializer::InitProperties`**  
`UPROPERTIES` are copied from the Class Default Object to the new instance.
Notice that any value set in the constructor is overwritten by the value in the Class Default Object.
- **`virtual PostInitProperties`**  
Here the class type can do whatever additional configuration it might need on top of the constructor/CDO data.
Any `UPROPERTY` written to here will be considered a Construction Script modified property and will be grayed out in the Details Panel.
Add `SkipUCSModifiedProperties` to the list of Property Specifiers for the `UPROPERTY` to prevent they graying-out.
- **`UObject::Serialize`**  
The Editor object was serialized at some point and here those bytes are de-serialized into the new object.
If any Property has been modified by the Level Designed in Unreal Editor then that value will overwrite any value set in a previous step.
- **`virtual PostLoad`**  
Here the class type can do whatever additional configuration it might need on the fully loaded object. No more behind-the-scenes edits will be made by Unreal Engine.
`PostLoad` is not always called, for example not on the initial creation.
I'm not sure what the complete list of "initial creation" times are, and what the negation of that set is.
- **`virtual PostDuplicate`**  
Not sure what this is.
- **`virtual BeginPlay`**  
The last callback for the object creation process.

## Blueprint Reconstruction

When a Component is created as part of Blueprint Reconstruction the order of callbacks is different for some reason.

- **PostInitProperties**
- **PostDuplicate
- **PostLoad**
- **Copy UProperties from the reconstructed Component**
- **OnRegister**


[[2020-10-03_10:52:02]] [UObject](./UObject.md)  
