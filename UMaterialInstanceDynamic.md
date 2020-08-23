2020-08-11_13:53:57

# UMaterialInstanceDynamic

[https://answers.unrealengine.com/questions/560119/setting-material-and-material-instance-in-c-withou.html](https://answers.unrealengine.com/questions/560119/setting-material-and-material-instance-in-c-withou.html)

```c++
// MyActor.h:
#include  "GameFramework/Actor.h"
#include  "MyActor.generated.h"

UCLASS()
class  MATTEST_API AMyActor : public  AActor
{
	GENERATED_BODY()
public:
	AMyActor();
public:
	UStaticMeshComponent* MeshComp;
	UMaterial* StoredMaterial;
	UMaterialInstanceDynamic* DynamicMaterialInst;
};

// MyActor.cpp:
#include  "MatTest.h"
#include  "MyActor.h"

AMyActor::AMyActor()
{
	PrimaryActorTick.bCanEverTick = true;
	MeshComp = CreateDefaultSubobject<UStaticMeshComponent>(
        TEXT("Mesh"));
	
    static  ConstructorHelpers::FObjectFinder<UStaticMesh> FoundMesh(
        TEXT("/Engine/EditorMeshes/EditorSphere.EditorSphere"));
	if (FoundMesh.Succeeded())
	{
		MeshComp->SetStaticMesh(FoundMesh.Object);
	}

	static  ConstructorHelpers::FObjectFinder<UMaterial> FoundMaterial(
		TEXT("/Engine/EditorMaterials/BasicMeshes/M_Floor.M_Floor"));
	if (FoundMaterial.Succeeded())
	{
		StoredMaterial = FoundMaterial.Object;
	}

	DynamicMaterialInst = UMaterialInstanceDynamic::Create(
        StoredMaterial, MeshComp);
	MeshComp->SetMaterial(0, DynamicMaterialInst);
}
```

A Dynamic Material is created from a parent Material already set on a StaticMesh with

```c++
DynamicMaterial = GetMesh()->CreateDynamicMaterialInstance(0);
if (DynamicMaterial)
{
    DynamicMaterial->SetScalarParameterValue(TEXT("base opacity"), 1);
}
```

At least I think the type of `DynamicMaterial` here is `UMaterialInstanceDynamic`.