2021-01-03_17:40:41

# C++ Character

Works much like a C++ Pawn.
Has access to a Character Movement Component.
Used through the Pawn input functions, such as `AddMovementInput`.

It is common to create a Blueprint subclass of the C++ Character subclass.
`ACharacter` > `AMyCharacter` > `BP_MyCharacter`.
For the newly created Character to be the default player model, set is as the Default Pawn Class in the Game Mode.
Also set that Game Mode as the default in Project Settings > Project > Maps & Models > Default Game Mode.
An alternative is to drag an instance of the character into the level and set it's Details Panel > Pawn > Auto Possess Player to a player.


`MyCharacter.h`:
```cpp
#pragma once

#include "GameFramework/Character.h"

#include "MainCharacter.generated.h"

class UInputComponent;

UCLASS()
class MyModule_API AMyCharacter : public ACharacter
{
    GENERATED_BODY()

public:
    void OnInteractStart();
    void OnInteractEnd();

    void MoveForward(float AxisValue);
    void MoveRight(float AxisValue);

    virtual void SetupPlayerInputComponent(UInputComponent* Input) override;
};
```

`MyCharacter.cpp`:
```cpp
#include "MyCharacter.h"

#include "Components/InputComponent.h"

void AMyCharacter::MoveForward(float AxisValue)
{
    const FVector Forward = GetActorForwardVector();
    AddMovementInput(Forward, AxisValue);
}

void AMyCharacter::MoveRight(float AxisValue)
{
    const FVector Right = GetActorRightVector();
    AddMovementInput(Right, AxisValue);
}

void AMainCharacter::OnInteractStart()
{
}

void AMainCharacter::OnInteractEnd()
{
}
void AMyCharacter::SetupPlayerInputComponent(UInputComponent* Input)
{
    Super::SetupPlayerInputComponent(Input);
    
    Input->BindAction("Interact", IE_Pressed, this, &AMainCharacter::OnInteractStart);
    Input->BindAction("Interact", IE_Released, this, &AMainCharacter::OnInteractEnd);

    Input->BindAxis(TEXT("MoveForward"), this, &AMyCharacter::MoveForward);
    Input->BindAxis(TEXT("MoveRight"), this, &AMyCharacter::MoveRight);
}
```

There are multiple ways to handle movement input.
Here is one where Forward is in the direction which the Character is facing:
```cpp
AMyCharacter::AMyCharacter()
{
    bUseControllerRotationPitch = true;
    bUseControllerRotationYaw = true;
    bUseControllerRotationRoll = true;
    GetCharacterMovement()->bOrientRotationToMovement = false;
}

void AMyCharacter::MoveForward(float AxisValue)
{
    const FVector Forward = GetActorForwardVector();
    AddMovementInput(Forward, AxisValue);
}

void AMyCharacter::MoveRight(float AxisValue)
{
    const FVector Right = GetActorRightVector();
    AddMovementInput(Right, AxisValue);
}
```

Here is one where Forward is in the direction which the Controller is facing:
```cpp
AMyCharacter::AMyCharacter()
{
    bUseControllerRotationPitch = false;
    bUseControllerRotationYaw = false;
    bUseControllerRotationRoll = false;
    GetCharacterMovement()->bOrientRotationToMovement = true;
    GetCharacterMovement()->RotationRate = FRotator(0.0f, 540.0f, 0.0f);
}

void AMyCharacter::MoveForward(float AxisValue)
{
    const FVector Forward = GetActorForwardVector();
    AddMovementInput(Forward, AxisValue);
}

void AMyCharacter::MoveRight(float AxisValue)
{
    const FVector Right = GetActorRightVector();
    AddMovementInput(Right, AxisValue);
}
```
They assume Character setup with the Camera on a Spring Arm configured as follows:
```cpp
SpringArm = CreateDefaultSubobject<USpringArmComponent>(TEXT("SpringArm"));
SpringArm->SetupAttachment(RootComponent);
SpringArm->bUsePawnControlRotation = true;

Camera = CreateDefaultSubobject<UCameraComponent>(TEXT("Camera"));
Camera->SetupAttachment(SpringArm, USpringArmComponent::SocketName);
Camera->bUsePawnControlRotation = false;
```