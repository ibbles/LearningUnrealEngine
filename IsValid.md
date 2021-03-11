2020-08-06_18:43:26

# IsValid

`IsValid` is a function that takes a pointer and returns true if it points to a valid object.
`Valid`, in this case, means not `nullptr` and not `IsPendingKill`.
Use this to ensure that the objects being checked is still alive.
It cannot be used to test if a pointer points to a valid C++ object.
A `delete`ed object is not a valid C++ objects.
Using `IsValid` on a `delete`ed object is undefined behavior.
Use `IsValid` over `!= nullptr` when the object may have been destroyed through gameplay logic.

Order or events:
- Live object, `UPROPERTY` members point to the object.
- Destroyed, `UPROPERTY` members still point to the object but `IsValid()` is `false`.
- Garbage collected, `UPROPERTY` members set to `nullptr`.