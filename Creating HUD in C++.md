2020-08-06_13:52:59

# Creating HUD in C++

```c++
AMyHUD::AMyHUD()
{
    static ConstructorHelpers::FClassFinder<UUserWidget> Widget_BP(
        TEXT("/MyHUD/BP_MyHUDWidget"));
    MyHUDWidgetClass = Widget_BP.Class;
}
```

```c++
void AMyHUD::BeginPlay()
{
    Super::BeginPlay();
    check(MyHUDWidgetClass);
    UUserWidget* MyHUDWidget = CreateWidget(GetWorld(), MyHUDWidgetClass);
    check(MyHUDWidget);
    MyHUDWidget->AddToViewport();
}
```



`UUserWidget` is child of `UWidget`.

