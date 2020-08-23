2020-06-16_09:19:36

# Rename

An Unreal Engine `UObject` is renamed with the `Rename` member function.
```
MyObject->Rename(TEXT("NewName"));
```
The name must be unique within the `UObject`'s outer, e.g., the Actor owning a set of Components.
A rename can be tested by passing `REN_Test` as the third argument.
If successfull then an immediately following non-test `Rename` is guaranteed to work.
```
if (MyObject.Rename(TEXT("NewName"), nullptr, REN_TEST))
{
	MyObject.Rename(TEXT("NewName"));
}
else
{
	// The new name is not allowed, pick another name.
}
```
We can ask for a generated name that is guaranteed to work using `MakeUniqueObjectName`.
```
if (MyObject.Rename(TEXT("NewName"), nullptr, REN_TEST))
{
	MyObject.Rename(TEXT("NewName"));
}
else
{
	FName SafeName = MakeUniqueObjectName(MyObject.GetOwner(), MyObject.GetClass(), FName(TEXT("NewName")));
 MyObject.Rename(*SafeName.ToString());
}
```
Notice the akward type conversions resulting from the confusion on whether a sequence of characters is a `TCHAR*`, an `FString`, or an `FName`.

There is also `REN_DontCreateRedirectors`.

Actors also have a `SetActorLabel` member function. It is only available in Development builds.
Setting the actor label also changes the actor name.