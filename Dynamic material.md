2020-07-02_15:31:14

# Dynamic material

A Material that can be changed during runtime.
Could also be one that is created at runtime.
(
I think one of the above implies the other. Only materials created at runtime can be changed at runtime.
And only Material Instances can be turned into a Dynamic Material Instance.
Or rather, a Dynamic Material Instance is created from a Material Instance.
)
Is created for a `StaticMesh` by calling `Create Dynamic Material Instance`.
A Dynamic Material is created from a Material Instance.
The Material Instance should have at least one parameter 
The parameter is set on the Dynamic Material using `Set Vector Parameter Value`.
The name of the parameter must be known/hard-coded. Case sensitive.

Example function that creates and returns a `UMaterialInstanceDynamics`:
```cpp
// Load the parent material. This material must have parameters matching
// the parameters we set later.
static FSoftObjectPath MyMaterialPath(
    TEXT("/Game/Materials/M_MyMaterial"));
UMaterial* MyMaterial = Cast<UMaterial>(MyMaterialPath.TryLoad());
if (MyMaterial == nullptr)
{
    return nullptr;
}

// Create the dynamic material instance.
UObject* Outer = this;
UMaterialInstanceDynamic* MyDynamic = UMaterialInstanceDynamic::Create(MyMaterial, Outer);
if (MyDynamic == nullptr)
{
    return nullptr;
}

// Set the parameters on the dynamic material instance. This can be done
// multiple times throughout the game session.
FName ParameterName = TEXT("MyParameter");
float ParameterValue = 0.0f;
MyDynamic->SetScalarParameterValue(ParameterName, ParameterValue);

// Apply/assign the dynamic material instance to one of the material slots
// on a Static Mesh.
int32 MaterialIndex = 0;
MyStaticMesh->SetMaterial(MaterialIndex, MyDynamic);

return MyDynamics;
```