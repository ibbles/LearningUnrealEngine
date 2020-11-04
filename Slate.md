2020-11-04_18:53:51

# Slate

Slate is used to implement both editor and game UIs.
Is a collection of widgets.
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

Handles input from keyboard, mouse, joysticks, touch.
Key binding support.

Customizable styling for the visual appearance.
Handles images, fonts, animations, 
Contains a layout system with support for user-driven layouts.

## Slots

I've seen these mentioned a few times. What are they?

## Programming in Slate

User interfaces are created in C++.
Not based on inheritance, there is no base `Widget` type.
Favors composition over inheritance.
Makes it possible to combine widgets in many ways.
Using a declarative syntax.
Entire subcomponents of a user interface declared in a single expression.


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

With experience it becomes possible to visualize what a user interface is going to look like just from reading the code.
And possible to predict what the code for a user interface must be.


## Some widgets

### Buttons

Buttons are empty, they do not contain a text filed or an image as other UI library might.
Instead something to render must be added using composition.
It could be a text block, an image, or a 3D rendering, or a combination of multiple widgets.

### SOverlay



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