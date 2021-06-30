2021-06-22_08:34:55

# UProperties

A UProperty is a member variable marked with the `UPROPERTY` decorator in a class that inherits from UObject.
These Properties are made available to Unreal Engine through the Unreal Header Tool.
They are included in the reflection and introspection system which provides serialization, garbage collection, clearing of pointers to destroyed objects, Details Panel editing and Blueprint Visual Script access.

[[2020-10-03_10:52:02]] [UObject](./UObject.md)  


UProperties can be configured to show up within Unreal Editor, both in the *Details Panel* when an instance of the class is selected and as get and set nodes in *Blueprint Visual Scripts*.
Property Specifiers are used control many aspects of this.

[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2020-03-11_21:08:39]] [Blueprints and UPROPERTY](./Blueprints%20and%20UPROPERTY.md)  


*Object pointer clearing* is only done for pointers to Actor and Actor Component, since they are the classes that has a well defined tear-down process.
This works for both pointers and Unreal Engine containers containing pointers, such as arrays.
It only works if the the pointer or container member variable has been marked with `UPROPERTY`.
The pointer clearing system ensures that you can't have dangling pointers, but it also means that a pointer that was valid a moment ago may become `nullptr` at almost any time.
A pointer will become `nullptr` when the pointed-to object is deleted, which can be either because that particular instance was destroyed, or because an asset was deleted from the Content Browser.
A UObject pointer can be checked with `IsValid`, which will test for both `nullptr` and `IsPendingKill`.

[[2020-08-06_18:43:26]] [IsValid](./IsValid.md)  


Unreal Engine uses a hierarchical *garbage collection* system, meaning that there is a set of root objects and all other objects are part of an outer-chain that ends at one of the root objects.
`UPROPERTY` UObject pointers also keep the pointed-to object alive, preventing garbage collection.
If you do not want a particular pointer to keep the pointed-to object alive then use `TWeakObjectPtr`.
It is unclear to me if the `TWeakObjectPtr` should be marked with `UPROPERTY` or not.

[[2020-08-31_10:01:57]] [Garbage collection](./Garbage%20collection.md)  

UObject Properties are *serialized*, meaning that they are written or read when the owning object as a whole is serialized.
UObject Properties that compare equal to the corresponding value in the Class Default Object are not serialized.
UObject Properties that are marked with the Transient Property Specifier are not serialized.

[[2020-08-18_13:44:36]] [Serialization](./Serialization.md)  
[[2021-06-18_08:51:45]] [Property specifiers](./Property%20specifiers.md)  


The default value of all UProperties are stored in the Class Default Object.
If the value of a UProperty is changed on the Class Default Object then all instances of that class that had the old default value are updated to use the new default value.
If the instance has another value on the UProperty then that value is considered to be overriding the default and won't be changed.

[[2021-06-22_12:28:21]] [Class Default Object](./Class%20Default%20Object.md)  


[[2020-03-09_21:43:36]] [UPROPERTY](./UPROPERTY.md)  
[[2020-10-03_10:52:02]] [UObject](./UObject.md)  
[[2020-03-11_21:08:39]] [Blueprints and UPROPERTY](./Blueprints%20and%20UPROPERTY.md)  
[[2020-08-06_18:43:26]] [IsValid](./IsValid.md)  
[[2021-06-22_08:54:20]] [Pointers](./Pointers.md)  
[[2020-08-18_13:44:36]] [Serialization](./Serialization.md)  
[[2020-08-31_10:01:57]] [Garbage collection](./Garbage%20collection.md)  
[[2021-06-22_12:28:21]] [Class Default Object](./Class%20Default%20Object.md)  


[Unreal Object Handling @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/ProgrammingWithCPP/UnrealArchitecture/Objects/Optimizations/)  
