2020-11-04_18:53:51

# Slate

Slate is used to implement both editor and game UIs.
For game UIs consider using UMG, which is built on top of Slate.

Slate is a collection of widgets.
Some examples:
- Buttons.
- List boxes.
- Tree views.
- Layout primitives.
- Text boxes.
- Images.
- Menus.
- Dialogs.
- Message boxes.
- Navigation. (what is this?)
- Notifications.
- Dock tabs.
- List views.
- Sliders.
- Spinners.
- and so on…
- 
Pretty much everything visible in Unreal Editor is a Slate widget.
Slate is used to implement custom asset editor for new asset types.
Is used for [[2020-11-09_16:56:34]] [Details Customization](./Details%20Customization.md).

There is a Slate Test Suite that demonstrates a bunch of Slate features.
Open it with Unreal Editor > Top Menu > Window > Developer Tools > Debug Tools > Test Suite.

## Slate features and attributes

Entirely C++.
Part of the engine.
Two modules: SlateCore and Slate.
Stored in the `Runtime` direcotry of the engine.
SlateCore very basic core functionality.
Slate includes all the widgets.
Platform agnostic, run everywhere Unreal Engine is supported.
Does not require Engine or Editor modules.
Can be used for stand-alone applications.
Also render agnostic, does not depend on the RHI built into the engine.

Since stand-alone from the engine, Slate does not use the `UObject` framework and therefore don't get access to the reflection and garbage collection system.
Use `TSharedPtr`, `TSharedRef`, and `TWeakPtr` explicitly instead of `UPROPERTY` raw pointers.

Handles input from keyboard, mouse, joysticks, touch.
Key binding support.

Customizable styling for the visual appearance.
Handles images, fonts, animations, 
Contains a layout system with support for user-driven layouts.

## Slots

I've seen these mentioned a few times. What are they?
A place in a widget where other widgets can be placed.

## Programming in Slate

User interfaces are created in C++.
Not based on inheritance, there is no base `Widget` type.
Favors composition over inheritance.
Makes it possible to combine widgets in many ways.
Using a declarative syntax.
Entire subcomponents of a user interface declared in a single expression.
With experience it becomes possible to visualize what a user interface is going to look like just from reading the code.
And possible to predict what the code for a user interface must be.

[[2021-06-15_14:54:53]] [Creating a new Slate widget](./Creating%20a%20new%20Slate%20widget.md)  

## Some widgets

### Buttons

Buttons are empty, they do not contain a text filed or an image as other UI library might.
Instead something to render must be added using composition.
It could be a text block, an image, or a 3D rendering, or a combination of multiple widgets.
To make a button do stuff, bind the `OnClicked` event.
```c++
void SMyWidget::Construct(const FArguments& InArguments)
{
    ChildSlot
    [
        SNew(SButton)
        .OnClicked(this, &SMyWidget::OnButtonClicked)
        [
            SNew(STextBlock)
            .Text(LOCTEXT("MyButton", "My Button"))
        ]
    ]
}

FReply SMyWidget::OnButtonClicked() const
{
    // Code here is executed when button is clicked.
    return FReply::Handled();
}
```

### SOverlay

Lets you overlay things on top of each other.


## Widget reflector

Just to inspect a Slate user interface, to discover how it has been created.
Unreal Editor > Top Menu Bar > Window > Developer Tools > Widget Reflector.
I a separate window.
Click the `Live Widget` button.
Hover over any user interface element in the editor.
Press Esc to stop live tracking.
Lots of information about the hovered widget is shown in the Widget Reflector window.
Shows the widget hierarchy tree, i.e., the Widget composition ancestry that lead to the hovered widget.
For each Widget in the tree there is a link to the source code for that Widget.
Where the Widget was created in a `Construct` function, not the declaration of the Widget class.
Be inspired of how things are done in Unreal Editor for you own interfaces.



[Slate UI Framework & Widget Reflector@learn.unrealengine.com](https://learn.unrealengine.com/course/2436528/module/5372750?moduletoken=UHxxnDLPW8ROFOnyLDf7jjbvPXNNq87ggNL8wMEpkQQHzQdQWvEjA6Oj8XBxlAHD)  

[[2020-11-09_16:56:34]] [Details Customization](./Details%20Customization.md)  