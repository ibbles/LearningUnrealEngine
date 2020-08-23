2020-08-06_18:43:26

# IsValid

`IsValid` is a function that takes a pointer and returns true if it points to a valid object.
`Valid`, in this case, means not `nullptr` and not `IsPendingKill`.
Use this to ensure that the objects being checked is still alive.
