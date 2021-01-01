2021-01-01_16:41:46

# C++ Pawn

A basic C++ Pawn.
This implementation is based on, and uses features and configuration described in [[2020-04-11_09:21:04]] [Pawn](./Pawn.md), [[2020-04-10_21:46:17]] [Inputs](./Inputs.md), and [[2020-12-31_17:03:18]] [C++ inputs](./C++%20inputs.md). 

Header:
```cpp
#pragma once

#include "GameFramework/Pawn.h"

#include "MyPawn.generated.h"

class UCameraComponent;
class UInputComponent;
class UStaticMeshComponent;
class USpringArmComponent;

UCLASS()
class AMyPawn : public APawn
{
	GENERATED_BODY()

    // VisibleAnywhere means shown in the Details Panel both in the Blueprint Editor and when
    // a particular instance is selected in the Level Editor.
    // BlueprintReadOnly means that Get nodes are available in the Blueprint class' Visual
    // Scripts, but Set nodes are not.
    // AllowPrivateAccess means that the Get nodes are only available in the class' own Visual
    // Scripts, not in scripts that has a reference to an instance of this type.
	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, meta = (AllowPrivateAccess = "true"))
	UStaticMeshComponent* Mesh;

	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, meta = (AllowPrivateAccess = "true"))
	USpringArmComponent* Arm;

	UPROPERTY(VisibleAnywhere, BlueprintReadOnly, meta = (AllowPrivateAccess = "true"))
	UCameraComponent* Camera;

public:

	AMyPawn();

	void OnInteractStart();
	void OnInteractEnd();
	void OnForward(float Value);
    void OnRight(float Value);

	virtual void SetupPlayerInputComponent(UInputComponent* PlayerInputComponent) override;
};
```

Implementation:
```cpp
#include "MyPawn.h"

#include "Camera/CameraComponent.h"
#include "Components/InputComponent.h"
#include "Components/StaticMeshComponent.h"
#include "GameFramework/SpringArmComponent.h"

AMyPawn::AMyPawn()
{
	Mesh = CreateDefaultSubobject<UStaticMeshComponent>(TEXT("Mesh"));
	SetRootComponent(Mesh);

	Arm = CreateDefaultSubobject<USpringArmComponent>(TEXT("Arm"));
	Arm->SetupAttachment(Mesh);

	Camera = CreateDefaultSubobject<UCameraComponent>(TEXT("Camera"));
	FollowCamera->SetupAttachment(CameraBoom, USpringArmComponent::SocketName);
}

void AMyPawn::OnInteractStart()
{
	// Called when the user starts pressing the Interact button.
}

void AMyPawn::OnInteractEnd()
{
	// Called when the user reelases the Interact button.
}

void AMyPawn::OnForward(float Value)
{
	// Called every frame, where Value is the amount the thumb stick has been moved, 0 to 1.
}

void AMyPawn::OnRight(float Value)
{
    // Called every frame, where Value is the amount the thumb stick has been moved, 0 to 1.
}

void AMyPawn::SetupPlayerInputComponent(UInputComponent* Input)
{
	Super::SetupPlayerInputComponent(Input);

	Input->BindAction("Interact", IE_Pressed, this, &AMyPawn::OnInteractStart);
	Input->BindAction("Interact", IE_Released, this, &AMyPawn::OnInteractEnd);

	Input->BindAxis("Forward", this, &AMyPawn::OnForward);
	Input->BindAxis("Right", this, &AMyPawn::OnRight);
}

```

[[2020-04-11_09:21:04]] [Pawn](./Pawn.md)  
[[2020-04-10_21:46:17]] [Inputs](./Inputs.md)  
[[2020-12-31_17:03:18]] [C++ inputs](./C++%20inputs.md)  