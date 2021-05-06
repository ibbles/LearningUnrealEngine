2020-11-08_15:42:25

# HUD

The HUD class acts as a manager for widgets.
Subclass it to create your specifi HUD.
The HUD base class inherits from `AActor`, so class names should be prefixed with `A`.
The `AHUD` subclass typically contains member variables for the various root widgets it contains.
By "root widgets" I mean widgets that may contain other widgest and that are added directly to the HUD.
Widgets can be (are? how does UMG fit into this?) Slate classes which don't participate in garbage collection.
We therefore use `TSharedPtr` instead of raw pointers.

[[2020-11-04_18:53:51]] [Slate](./Slate.md)  

```
UCLASS()
class MYMODULE_API AMyHud : public AHUD
{
    GENERATED_BODY()
public:
    TSharedPtr<class SMyWidget> MyWidget;
    TSharedPtr<class SWidget> WidgetContainer;
}
```
`MyWidgetContainer` is used to show and hide the HUD.
If you have multiple parts of the HUD you wish to show and hide separately, a menu for example, then have multiple `Widget`/`WidgetContainer` pairs, but with their own names of course.

The widgets are created and added to the screen in `BeginPlay`.
One need access to the viewport to add widgets, which can be found through the global `GEndine` object.
Example that uses the the `SMyWidget` created in [[2020-11-04_18:53:51]] [Slate](./Slate.md):
```c++
void AMyHud::BeginPlay()
{
    Super::BeginPlay();
    if (GEngine == nullptr || GEngine->GameViewport == nullptr)
    {
        error
    }

    MyWidget = SNew(SMyWidget).OwningHud(this);
    GEngine->GameViewport->AddViewportWidgetContent(
        SAssignNew(WidgetContainer, SWeakWidget)
        .PossiblyNullContent(MyWidget.ToSharedRef()));
}
```
`SAssignNew` lets us both create a new Widget in an expression and also assign it to a variable.
`PossiblyNullContent` is the way we pass a widget into a container.


We can show and hide individual widgets.
Here we recreate the entire widget on show and destroy it on hide.
```c++
void AMyHud::ShowWidget()
{
    if (GEngine == nullptr || GEngine->GameViewport == nullptr)
    {
        error
    }

    MyWidget = SNew(SmyWidget).OwningHud(this);
    GEngine->GameViewport->AddViewportWidgetContent(
        SAssignNew(WidgetContainer, SWeakWidget)
        .PossiblyNullContent(MyWidget.ToSharedRef()));
    if (PlayerOwner)
    {
        PlayerOwner->bShowMouseCursor(true);
        PlayerOwner->SetInputMode(FInputModeUIOnly);
    }
}

void AMyHud::HideWidget()
{
    if (GEngine == nullptr || GEngine->GameViewport == nullptr || !WidgetContainer.IsValid())
    {
        error
    }

    GEngine->GameViewport->RemoveViewportWidgetContent(
        WidgetContainer.ToSharedRef());
    if (PlayerOwner)
    {
        PlayerOwner->bShowMouseCursor(false);
        PlayerOwner->SetInputMode(FInputModeGameOnly());
    }
}
```

The mouse cursor can also be hidden directly from Slate code:
```c++
FSlateApplication::Get().GetPlatformApplication().Get()->Cursor->Show(false);
```
Not sure how this interacts with `bShowMouseCursor`.

[[2020-11-04_18:53:51]] [Slate](./Slate.md)  
