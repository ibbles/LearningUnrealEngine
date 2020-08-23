2020-08-06_13:52:59

# Creating HUD in C++

```c++
AMainHUD::AMainHUD() { static ConstructorHelpers::FClassFinder<UUserWidget> Widget_BP(TEXT("/CivilFXCore/UI_BPs/BP_MainHUDWidget")); MainHUDWidgetClass = Widget_BP.Class; }
```

```c++
void AMainHUD::BeginPlay() { Super::BeginPlay(); check(MainHUDWidgetClass); UUserWidget* MainHUDWidget = CreateWidget(GetWorld(), MainHUDWidgetClass); check(MainHUDWidget); MainHUDWidget->AddToViewport(); }
```



`UUserWidget` is child of `UWidget`.

