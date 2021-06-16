2021-06-15_14:54:53

# Creating a new Slate widget


To create new Slate widgets the module containing the widgets must include `Slate` and `SlateCore` in either `PublicDependencyModuleNames` or `PrivateDependencyModuleNames`.
In the header file for the widget include `SlateBasics.h` and `SlateExtras.h`.
The widget class does not need the `_API` class decorator because it won't be used outside of the module.
All classes that inherit from Slate classes should be prefixed with `S`.
If the widget will contain other Widgets then inherit from `SCompoundWidget`.
```c++
#include "SlateBasics.h"
#include "SlateExtras.h"

class SMyWidget : public SCompoundWidget
{
}
```
If your widget needs access to the `World` to do it's work then pass the owning `HUD` to it.
Slade classes use macros to delcare arguments:
- `SLATE_BEGIN_ARGS`.
- `SLATE_ARGUMENT(Type, Name)`.
- `SLATE_END_ARGS`.
Example:
```cpp
class SMyWidget : public SCompoundWidget
{
public:
    SLATE_BEGIN_ARGS(SMyWidget) {}
    SLATE_ARGUMENT(TWeakObjectPtr<class AMyHud>, OwningHud)
    SLATE_END_ARGS()

private:
    TWeakObjPtr<class AMyHud> OwningHud;
}
```
The type of a Slate argument cannot be a reference.

When created a Slate widget's `Construct` member function is called.
```cpp
void Construct(const FArguments& InArguments);
```

The `InArguments` parameter is a structure that contains the parameters declared with `SLATE_ARGUMENT` in the widget class declaration.
Each parameter's name is prefixed with `_` to avoid name collisions.
```cpp
void SMyWidget::Construct(const FArguments& InArguments)
{
    OwningHud = InArguments._OwningHud;
}
```

All the sub-widgets are created in `Construct`.
`SCompoundWidget` has a `ChildSlot` member of type `FSimpleSlot` to hold the sub-widgets.
We add sub-widgets to our `SCompundWidget` using `operator[]` on `ChildSlot`.
New widget instances are created with `SNew`, which can be used inside `operator[]`.
Properties new newly created widgets are set with `.PROPERTY()` notation.
Example:
```c++
void SMyWidget::Construct(const FArguments& InArguments)
{
    ChildSlot
    [
        SNew(SButton)
        .Text(LOCTEXT("My button", "My button"))
    ];
}
```
Building widgets in C++ is conceptually very similar to building widgets in the Widget Blueprint Editor.
Dragging something from the widget library into a widget container in the Layout view is the same as creating that widget with `SNew` inside `operator[]`.
`SOverlay` is an example of a widget container that we can create in C++ with `SNew`.
We add a widget to the new `SOverlay` by using `operator+` and `SOverlay::Slot` to add a slot to the overlay, then `operator[]` on the new slot to descent into it to create new widgets.
Example:
```c++
void SMyWidget::Construct(const FArguments& InArguments)
{
    ChildSlot
    [
        SNew(SOverlay)
        + SOverlay::Slot()
        .HAlign(HAlign_Fill)
        .VAlign(VAlign_Fill)
        [
            SNew(SImage)
            .ColorAndOpacity(FColor::Black)
        ]
    ]
}
```
In the above we set a black background color for `SMyWidget`.

We can add multiple slots to a `SOverlay` by chaining `operator+ SOverlay::Slot`.
We can also add slots inside a slot if the added sub-widget is itself a widget container.
Example:
```c++
void SMyWidget::Construct(const FArguments& InArguments)
{
    ChildSlot
    [
        SNew(SOverlay)
        + SOverlay::Slot()
        .HAlign(HAlign_Fill)
        .VAlign(VAlign_Fill)
        [
            SNew(SImage)
            .ColorAndOpacity(FColor::Black)
        ]
        + SOverlay::Slot()
        [
            SNew(STextBlock)
            .Text(LOCTEXT("ExText", "Example text"))
        ]
    ]
}
```


If your widget should be focusable for keyboard input then declare a member function named `SupportsKeyboardFocus` that returns `true` and set `bCanSupportFocus` to `true` in `Construct`.

Styling can be configured per widget.
A collection of styles is included with the engine in `FCoreStyle`.
A `Style` contains font information.
Example:
```c++
void MyWidget::Construct(const FArguments& InArguments)
{
    FSlateFontInfo ButtonStyle = FCoreStyle.Get().GetFontStyle("EmbossedText");
    ButtonStyle.Size = 40;

    ChildSlot
    [
        SNew(SButton)
        .Text(LOCTEXT("MyButton", "My Button"))
        .Style(ButtonStyle)
    ]
}
```




Creating a new type of Widget:
```
class STextButton : public SCompundWidget
{
public:
    // Declare the attributes and arguments that the widget provides.
    // Makes it possible to access Slate attributes such as .Font, .ToolTip,
    // and .Text in the implementation.
    // Makes it possible to chain the entire creation declaration in a
    // single statement.
    SLATE_BEGIN_ARGS(SMyButton)
    {}
        SLATE_ATTRIBUTE(FText, Text)
        SLATE_EVENT(FOnClicked, OnClicked)
    SLATE_END_ARGS()

    // The Construct function is called when the widget is created.
    void Construct(const FArguments& InArgs);
}


void STextButton::Construct(const FArguments& InArgs)
{
    ChildSlot
    [
        // New Widget instances are created with SNew.
        // SNew is a macro that creates a new instance of the given class.
        // Widgets are nested inside of other widgets using operator[].
        // This is what is meant by "declarative syntax".
        // This is also what we mean by "composition", we place the text
        // block inside the button.
        SNew(SButton)
        .OnClicked(InArgs._OnClicked)
        [
            SNew(STextBlock)
            .Font(FMySTyle::GetFontStyle("TextButtonFont"))
            .Text(InArgs._Text)
            .ToolTipText(LOCTEXT("TextButtonToolTip", "Click Me!"))
        ];
    ];
}
```

[[2020-11-04_18:53:51]] [Slate](./Slate.md)  