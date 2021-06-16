2020-11-09_16:56:34

# Detail Customization

The Details Panel is built with [[2020-11-04_18:53:51]] [Slate](./Slate.md).
The Details Panel contains a list of categories and two columns.
Categories are collapsible collections of rows.
Each row holds and Item.
Each item consists of a name column and a value column.
The name, value, or even the entire Item, can by any Slate widget.
The Category contains helper functions for adding common widgets.
Such as property editors.

There are two types of builders for the Details Panel: `IDetailCustomization`, and `IPropertyTypeCustomization`.
`IDetailCustomization`.
`IDetailCustomization` is used to build the Details Panel itself for one or more selected objects.
`IPropertyTypeCustomization` is used to build a part of a Details Panel that display a single Property.
See [[2021-06-16_10:48:57]] [Property Customization](./Property%20Customization.html).

There is also `IDetailCustomNodeBuilder`.
It creates a sub-tree of widgets.
It is added to a Category.

An instance of `IDetailLayoutBuilder` is used to build the Details Panel.
It builds and edits Categories, and creates Item rows.


## Module setup

All Detail Customizations should be added to an Editor Module within the project or plugin.
Example Module entry in the `Modules` array of a `.uproject` file:
```json 
 {
    "Name": "MyProjectEditor",
    "Type": "Editor",
    "LoadingPhase": "PostEngineInit",
    "AdditionalDependencies": []
}
```

In the `.Build.cs` file, add public or private dependencies to the following modules: `UnrealEd`, `DetailCustomizations`, `Slate`, `SlateCore`, `PropertyEditor`, and `EditorStyle`.
Not sure if all are really needed, and if the names are spelled correctly. Another source list only `Core`,  `CoreUObject`,  `Engine`,`PropertyEditor`,`Slate`, and `SlateCore`.
Also depend on the non-editor module for your project or plugin.

Create a new class that inherit from `IDetailCustomization`.
There should be one of these for each type you wish to customize the Details Panel for.
Some name this class with the `Customization` suffix, while others use `Details` instead.
These classes will be registered with the editor in the module's `StartupModule`.

`MyClassCustomization.h`:
```c++
#pragma once

#include "IDetailCustomization.h"

class FMyClassCustomization : public IDetailCustomization
{
public:
    static TSharedRef<IDetailCustomization> MakeInstance();

    // ~Begin IDetailCustomization interface.

    /** Called when a Details Panel for our associated type is to be built. */
    virtual void CustomizeDetails(IDetailLayoutBuilder& DetailBuilder) override;

    // ~End IDetailCustomization interface.

private:
    // Member functions for callbacks bound to widget events can be put here.
    // Member variables needed can be put here.
};
```

`MyClassCustomization.cpp`:
```c++
#include "MyClassCustomization.h"

#include "DetailCategoryBuilder.h"
#include "DetailLayoutBuilder.h"

#define LOCTEXT_NAMESPACE "MyEditorModule"

TSharedRef<IDetailCustomization> FMyClassCustomization::MakeInstance()
{
    return MakeShareable(new FMyClassCustomization);
}

void FMyClassCustomization::CustomizeDetails(
        IDetailLayoutBuilder& DetailBuilder)
{
    // This is where we create and/or configure the contents of the Details Panel.
    // Use DetailBuilder.GetObjectsBeingCustomized to get the selected objects.
    // Use DetailBuilder.EditCategory to get or create a category.
    // Use Category.AddCustomRow to add new rows to the category.
}
```

The `IDetailCustomization` subclass is associated with the class it is building the Detalis Panel for in the `StartupModule` member function for your Editor Module:

`MyEditorModule.cpp`:
```c++
#include "MyClassCustomization.h"

void FMyEditorModule::StartupModule()
{
    FPropertyEditorModule& PropertyModule = 
        FModuleManager::LoadModuleChecked<FPropertyEditorModule>(
            "PropertyEditor");

    PropertyModule.RegisterCustomClassLayout(
        UMyClass::StaticClass()->GetFName(),
        FOnGetDetailCustomizationInstance::CreateStatic(
            &FMyClassCustomization::MakeInstance));

    PropertyModule.NotifyCustomizationModuleChanged();
}

void FMyEditorModule::ShutdownModule()
{
    FPropertyEditorModule& PropertyModule = 
        FModuleManager::LoadModuleChecked<FPropertyEditorModule>(
            "PropertyEditor");

    PropertyModule.UnregisterCustomClassLayout(
        UMyClass::StaticClass()->GetFName());
}
```

## Example class

As an example, consider the following class for which we wish to create a custom Details Panel.
```c++
UCLASS()
class UMyClass : public UObject
{
    GENERATED_BODY()

public:
    UPROPERTY(EditAnywhere, Category = "Person")
    FString FavoriteFood;

    UPROPERTY(EditAnywhere, Category = "Person")
    int32 MaxServings;

    UPROPERTY(VisibleAnywhere, Category = "Pets")
    TArray<FString> PetNames;
};
```

## Creating a Details Panel

When a Details Panel for a type for which a `CustomClassLayout` has been registered is opened in Unreal Editor the editor will call the corresponding `CustomizeDetails` member function.
`CustomizeDetails` is only called once per selection change.
This means that any dynamic updates must be handled either with Properties, Attributes, or `DetailBuilder.ForceRefreshDetails()`.
More on these below.

## Categories

A category is a collapsible region of the Details Panel.
Each Slate widget in the Details Panel lives in a Category.
Slate widgets are created automatically from `UPROPERTY` member variables and added to the category specified in the `UPROPERTY`'s `Category` argument.

We get access to a particular category with `IDetailLayoutBuilder::EditCategory`, which can give us either an already existing category or a brand new one.
```c++
IDetailCategoryBuilder& PersonCategory =
    DetailBuilder.EditCategory(TEXT("Person"));
```

We hide categories with `DetailBuilder.HideCategory(TEXT("Person")`.

## Default widgets for properties

Subclasses of `IPropertyHandle` are used the build the bulk of most Details Panels.
They link a particular `UPROPERTY` to a particular row in the Details Panel.
We get property handles from the `IDetailLayoutBuilder` instance passed to `CustomizeDetails`.
```
TSharedRef<IPropertyHandle> FavoriteFoodProperty =
    DetailBuilder.GetProperty(GET_MEMBER_NAME_CHECKED(UMyClass, FavoriteFood));
```
Check that the property is valid with `IsValidHandle` before use.
We can get property handles to struct members from a struct property handle.

(
The struct part needs more text. I don't know what it means, or what to do with it.
)

Any `UPROPERTY` that we don't explicitly modify will get a default created row in the category set in the `UPEROPRTY` macro.
The row is added after the rows customized by `CustomizeDetails`.

We hide default-created properties with `DetailBuilder.HideProperty(Property);`.
We add a property widget to a category with `PersonCategory.AddProperty(FavoriteFoodProperty);`.

The following example demonstrates how to use `IPropertyHandle` to "move" a property from one category to another by hiding the entire original category and manually adding the property to another category. It also shows how to hide single properties.
```c++
void FMyClassCustomization::CustomizeDetails(
        IDetailLayoutBuilder& DetailBuilder)
{
    // Hide the entire Pet category. We will put the parts we're interested
    // in in the Person category instead.
    DetailBuilder.HideCategory(TEXT("Pets"));

    // Get a reference to the Person category so we can edit its contents.
    IDetailCategoryBuilder& PersonCategory =
        DetailBuilder.EditCategory(TEXT("Person"));

    // Get a handle to the FavoriteFood property and hide it.
    TSharedRef<IPropertyHandle> FavoriteFoodProperty =
        DetailBuilder.GetProperty(
            GET_MEMBER_NAME_CHECKED(UMyClass, FavoriteFood));
    check(FavoriteFoodProperty.IsValidHandle());
    PersonCategory.HideProperty(FavoriteFoodProperty);

    // Get a handle to the PetNamess property and add it to the Person category.
    TSharedRef<IPropertyHandle> PetProperty =
        DetailBuilder.GetProperty(
            GET_MEMBER_NAME_CHECKED(UMyClass, PetNames));
    check(PetProperty.IsValidHandle());
    PersonCategory.AddProperty(PetProperty);
}
```

`IDetailCategoryBuilder::AddProperty` returns a `IDetailPropertyRow` which can be used to customize the row.
`IDetailPropertyRow` contains a bunch of callbacks used by the editor to query the wanted state of the row.
For example, a `bool`-returning function can be passed to `IDetailPropertyRow::Visibility`.
The "function" isn't really a function but an "attribute" of some kind.
These functions are called frequently, much more than `CustomizeDetails`, so they should be fast.

This example demonstrates how to add the `PetNames` property to the `Person` category and also attach a visibility attribute to it. The actual logic for if the property should be visible is omitted but marked with a comment
```c++
void FMyClassCustomization::CustomizeDetails(
    IDetailLayoutBuilder& DetailBuilder)
{
    // Get a reference to the Person category.
    IDetailCategoryBuilder& PersonCategory =
        DetailBuilder.EditCategory(TEXT("Person"));

    // Get a handle to the PetNames property.
    TSharedRef<IPropertyHandle> PetNamesProperty =
        DetailBuilder.GetProperty(
            GET_MEMBER_NAME_CHECKED(UMyClass, PetNames));
    check(PetNamesProperty.IsValidHandle());

    // Lambda that determines if the PetNames property should
    // be visible or not.
    auto IsPetVisibleFun = []
    {
        return /*bool expression*/ ?
            EVisibility::Visible :
            EVisibility::Collapsed;
    };
    // Visibility attribute that uses the lambda defined above.
    auto IsPetVisibleAttr = TAttribute<EVisibility>::Create(
        TAttribute<EVisibility>::FGetter::CreateLambda(IsPetVisibleAttr));
    // Add the PetNames property to the Person cateogry and assign
    // the visibility attribute.
    PersonCategory.AddProperty(PetNamesProperty)
        .Visibility(IsPetVisibleAttr);
}
```

`IDetailPropertyRow` and has attributes for enabled and editable as well.

If the logic for determining visibility, i.e., the code that returns an `EVisibility`, is a member function then a shorter form can be used.
```cpp
PersonCategory.AddProperty(PetNamesProperty)
    .Visibility(TAttribute<EVisibility>(this, &FMyClassCustomization::PetNamesVisibility));
```

[EVisibility @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/API/Runtime/SlateCore/Layout/EVisibility/index.html)

## Selected objects

The objects being shown in the Details Panel can be accessed with
```c++
TArray<TWeakObjectPtr<UObject>> SelectedObjects;
DetailBuilder.GetObjectsBeingCustomized(SelectedObjects);
```
Keep in mind that there can be multiple objects.

If you want to store pointers to the objects in either a Lambda or a member variable for later use from a callback then store it in a `TWeakObjectPtr` and check `IsValid` before use.

If the customization doesn't make sense, or is difficult to support, for multiple objects then one can fall back to the default Details Panel when multiple objects are selected:
```c++
void FMyClassCustomization::CustomizeDetails(
        IDetailLayoutBuilder& DetailBuilder)
{
    TArray<TWeakObjectPtr<UOBject>> ObjectsToEdit;
    DetailBuilder.GetObjectsBeingCustomized(ObjectsToEdit);
    if (ObjectsToEdit.Num() != 1)
    {
        // Too many (or few?) selected objets. Do nothing, which will fall back
        // to the default Details Panel.
        return;
    }

    TWeakObjectPtr<UMyClass> MyObject = Cast<UMyClass>(Objects[0].Get());
    if (!MyObject.IsValid())
    {
        // The selected object isn't valid anymore. Fall back to the default
        // Details Panel.
        return;
    }
}
```

A registered Custom Class Layout doesn't replace the default Details Panel but customizes it, and if no customization is done then the default Details Panel is retained.

## Custom rows

A custom row is a row in a category that we can add arbitrary Slate widgets to.
The widget can either replace the entire row, or the name- and/or value columns separately.
These customization points are called slots.
A custom row has a set of filter keywords that are matched against when typing the the Details Panel's search box.
```c++
#include "MyClassCustomization.h"

#include "DetailCategoryBuilder.h"
#include "DetailLayoutBuilder.h"
#include "DetailWidgetRow.h"

void FMyClassCustomization::CustomizeDetails(
        IDetailLayoutBuilder& DetailBuilder)
{
    IDetailCategoryBuilder& PersonCategory =
        DetailBuilder.EditCategory(TEXT("Person"));

    PersonCategory.AddCustomRow(
        LOCTEXT("FilterKeywords", "Keywords used when filtering"));
}
```

`AddCustomRow` returns a reference to a `FDetailWidgetRow`.

We access the customization slots on the row using the member functions `WholeRowContent`, `NameContent`, and `ValueContent` where `WholeRowContent` is the whole row and `NameContent` and `ValueContent` are the two columns.
Do not customize both `WholeRowContent` and either of the two column slots on the same row, the are mutually exclusive.
The object returned from the slot accessor functions are Slate widgets so we configure it using the fluent Slate syntax.
```c++
PersonCategory.AddCustomRow(LOCTEXT("key", "value"))
    .WholeRowContent()
    [
        // Use SNew and all that here.
    ];
```
```c++
PersonCategory.AddCustomRow(LOCTEXT("key", "value"))
    .NameContent()
    [
        // Use SNew and all that here.
    ]
    .ValueContent()
    [
        // Use SNew and all that here.
    ];
```

A shorthand for `WholeRowContent` is to call `operator[]` on the row directly.

The Visibility attribute can be used on a custom row.
```c++
auto IsRowVisibleFun = []
{
    return /*bool expression*/ ?
        EVisibility::Visible :
        EVisibility::Collapsed;
};

auto IsRowVisibleAttr = TAttribute<EVisibility>::Create(
    TAttribute<EVisibility>::FGetter::CreateLambda(IsRowVisibleAttr));

PersonCategory.AddCustomRow(LOCTEXT("key", "value"))
   .Visibility(IsRowVisibleAttr)
   .WholeRowContent()
   [
       // Use SNew and all that here.
   ];
```

We can use the visibility attribute to generate a warning text in the Details Panel.
Here `IsBroken` is an example function, use whatever error detection logic you need instead.
```c++
auto IsErrorVisibleFun = [MyObject]
{
    return MyObject.IsValid() && MyObject->IsBroken() ?
        EVisibility::Visible :
        EVisibility::Collapsed;
};

auto IsErrorVisibleAttr = TAttribute<EVisibility>::Create(
    TAttribute<EVisibility>::FGetter::CreateLambda(IsErrorVisibleAttr));

PersonCategory.AddCustomRow(LOCTEXT("ErrorMessage", "Error message"))
    .Visibility(IsErrorVisibleAttr)
    .WholeRowContent()
    [
        SNew(STextBlock)
        .Text(LOCTEXT("ObjectIsBroken", "Object is broken."))
    ];
```

It is common (I think) to put widgets inside a `SHorizontalBox`.
Provides access to more configuration and layout capabilities.
Here we use `operator[]` on the `FDetailWidgetRow` directly, which is equivalent to `WholeRowContent`.
```c++
MyCategory.AddCustomRow(LOCTEXT("FilterKey", "FilterValue"))
[
    SNew(SHorizontalBox)
    + SHorizontalBox::Slot()
    .AutoWidth() // There are also VAlign, Padding, MaxWidth, and more.
    [
        SNew(STextBlock)
        .Text(LOCTEXT("ExampleText", "Example text."))
    ]
];
```

## Interactivity

Buttons and other input widgets can be added to custom rows.
Use lambdas or member function pointers to get callbacks when the user interacts with the input widget.

```c++
TArray<TWeakObjectPtr<UObject>> SelectedObjects;
Builder.GetSelectedObjects(SelectedObjects);
if (SelectedObjects.Num() != 1)
{
    return;
}
TWeakObjectPtr<UMyClass> MyObject = Cast<UMyClass>(SelectedObjects[0].Get());
PersonCategory.AddCustomRow(LOCTEXT("key", "value"))
    .NameContent()
    [
        SNew(STextBlock)
        .Text(LOCTEXT("MyButton", "My button"))
    ]
    .ValueContent()
    [
        SNew(SButton)
        .OnClicked_Lambda([MyObject]()
        {
            if (!MyObject.IsValid())
            {
                return FReply::Unhandled()
            }
            // Add button logic here.
        })
    ];
```

Combo boxes are added in a similar fashion.
This example creates a combo box that contains `FName`s.
```c++
PersonCategory.AddCustomRow(LOCTEXT("FilterKey", "FilterVaue"))
    .NameContent()
    [
        SNew(STextBlock)
        .Text(PropertyName) // PropertyName is a `FText`.
    ]
    .ValueContent()
    [
        // SComboBoxes always contain `TSharedPtr`s
        SNew(SComboBox<TSharedPtr<FName>>)
        // Options is a `TArray<TSharedPtr<FName>>` that must be valid for
        // the entire lifetime of the Details Panel. Often a member of the
        // IDetailCustomization subclass that we're executing inside.
        // Not sure how reactive this is to changes in Options, if we can
        // add and remove items and have that immediately reflected in the
        // combo box. Maybe after a open/close cycle.
        .OptionsSource(&Options)
        // Function that is called for every element in the OptionsSource.
        // Creates the SWidgets that is shown when the combo box is opened.
        .OnGenerateWidget_Lambda([](TSharedPtr<FName> Item))
        {
            return SNew(STextBlock)
                .Text(FText::FromName(*Item))
        })
        // Function that is called when the selected item in the combo box
        // changes. The registered function will receive the newly selected
        // item and a `ESelectionInfo::Type`. The ExtraParameter member is
        // passed on to the memberfunction but otherwise ignored by the
        // callback framework.
        // In this example MyCallback (not shown) assigns the selected FName
        // to a member variable named CurrentSelection.
        .OnSelectionChanged(
            this, &FMyClassCustomization::MyCallback, ExtraParameter)
        // The Content slot is the title of the combo box. This is always
        // visible, even when the combo box is closed. This is often used to
        // visualize the currently selected item.
        // In this example, `CurrentSelection` is a member variable of type
        // FName to which the currently selected combo box item is assigned in
        // MyCallback.
        .Content()
        [
            SNew(STextBlock)
            .Text_Lambda([this]()
            {
                return FText::FromName(CurrentSelection);
            })
        ]
    ];
```

To update the Details Panel after changing something that affects it, e.g., from a button callback, or when a change is detected by `OnEditChangePropeperty`, try calling `DetailBuilder::ForceRefreshDetails`.
This is a heavy operation, so use sparingly and with caution.
It if often possible to build the same functionality using Attributes. (I think.)

## Complete example

`MyClassCustomization.h`:
```c++
#pragma once
#include "CoreMinimal.h"
#include "Input/Reply.h"
#include "IDetailCustomization.h"

class FMyClassCustomization : public IDetailCustomization
{
public:
    static TSharedRef<IDetailCustomization> MakeInstance();

    // ~Begin IDetailCustomization interface.
    virtual void CustomizeDetails(IDetailLayoutBuilder& DetailBuilder) override;
    // ~End IDetailCustomization interface.

    FReply ButtonCallback();
};
```

`MyClassCustomization.cpp`:
```c++
#define LOCTEXT_NAMESPACE "MyEditorModule"

TSharedRef<IDetailCustomization> FMyClassCustomization::MakeInstance()
{
    return MakeShareable(new FMyClassCustomization);
}

void FMyClassCustomization::CustomizeDetails(
        IDetailLayoutBuilder& DetailBuilder)
{
    TArray<TWeakObjectPtr<UOBject>> ObjectsToEdit;
    DetailBuilder.GetObjectsBeingCustomized(ObjectsToEdit);

    IDetailCategoryBuilder& Category = 
        DetailBuilder.EditCategory("FirstCategory|SecondCategory");

    Category.AddCustomRow(LOCTEXT("MyRow", "MyRow"))
        .NameContent()
        [
            SNew(STextBlock)
            .Text(LOCTEXT("MyRowName", "MyRowName"))
            .Font(IdetailLayoutBuilder::GetDetailFontBold())
        ]
        .ValueContent()
        [
            SNew(SButton)
            .Text(LOCTEXT("ButtonLabel", "Button label"))
            .OnClicked_Raw(this, &FMyClassCustomization::ButtonCallback)
        ];
}

void FMyClassCustomization::ButtonCallback()
{
    // Implement button logic here.
    return FReply::Handled();
}
```


## FPropertyEditorModule

There is some helper functionality in the `FPropertyEditorModule`.

```cpp
auto& PropertyModule = FModuleManager::LoadModuleChecked<FPropertyEditorModule>(
    "PropertyEditor");
```

Also `PropertyCustomizationHelpers.h`.

[FPropertyEditorModule @ docs.unrealengine.com](https://docs.unrealengine.com/en-US/API/Editor/PropertyEditor/FPropertyEditorModule/index.html)


## FVector

An `FVector` can be displayed in a Detals Panel with the `SVectorInputBox`.

In this example, assume that `UMyComponent` contains an `UPROPERTY() FVector MyVector`.

`FMyClassCustomization.h`
```cpp
class MYEDITORMODULE_API FMyClassCustomization : public IDetailCustomization
{
public:
    void CustomizeDetails(IDetailLaoutBuilder& DetailBuilder);

    TOptional<float> GetVectorX() const { return X; }
    TOptional<float> GetVectorY() const { return Y; }
    TOptional<float> GetVectorZ() const { return Z; }

    void OnSetVector(float NewValue, ETextCommit::Type CommitInfo, int32 Axis);

private:
    TOptional<float> X;
    TOptional<float> Y;
    TOptoinal<float> Z;

    UMyComponent* MyComponent;
};
```
```cpp
void FMyClassCustomization::CustomizeDetails(
    IDetailLayoutBuilder& DetailBuilder)
{
    IDetailCategoryBuilder& MyCategory = DetailBuilder.EditCategory(TEXT("MyCategory"));
    MyCategory.AddCustomRow()
    .HeaderContent()
    [
        // Fill with whatever you want here, an STextBlock for example.
    ]
    .ValueContent()
    [
        SNew(SVectorInputBox)
        .X(this&, &FMyClassCustomization::GetVectorX)
        .Y(this&, &FMyClassCustomization::GetVectorY)
        .Z(this&, &FMyClassCustomization::GetVectorZ)
        .OnXCommitted(this, &FMyClassCustomization::OnSetVector, 0)
        .OnYCommitted(this, &FMyClassCustomization::OnSetVector, 1)
        .OnZCommitted(this, &FMyClassCustomization::OnSetVector, 2)
    ];
}

void FMyClassCustomization::OnSetVector(
    float NewValue, ETextCommitType::CommitInfo, int32 Axis)
{
    if (MyComponent == nullptr)
    {
        return;
    }

    const FScopedTransaction Transaction(LOCTEXT("Set vector"));
    MyComponent->Modify();
    MyComponent->MyVector.Component(Axis) = NewValue;
    FComponentVisualizer::NotifyPropertyModified(
        MyComponent,
        FindFProperty<FProperty>(
          UMyComponent::StaticClass(),
          GET_MEMBER_NAME_CHECKED(UMyComponent, MyVector)));
}
```

The three `GetVector*` member functions should return `TOptional<float>`

We can also call `AllowResponsiveLayout` and `AllowSpin` on the `SVectorInputBox`.
I don't know what that would do.

## IDetailCustomNodeBuilder

From the documentation:

> A custom node that can be given to a details panel category to customize widgets.

I don't know what that means.
I don't know what a "node" is.
Is it another word for a Row?
What can this do that can't be done with the regular Slate widgets?

Can have a pointer to the corresponding `FComponentVisualizer`.
We can find the `FComponentVisualizer` with
```cpp
TSharedPtr<FComponentVisualizer> Visualizer = 
    GUnrealEd->FindComponentVisualizer(UMyComponent::GetStaticClass());
FMyComponentVisualizer* MyComponentVisualizer = (FMyComponentVisualizer*)Visualizer.Get();
check(MyComponentVisualizer);
```
That C-cast doesn't look safe...

`IDetailCustomNodeBuilder` has a `GenerateChildContent` member function.
Is given a `IDetailChildrenBuilder` parameter.

From the documentation for `IDetailChildrenBuilder`:
> Builder for adding children to a detail customization.

Not that much wiser…

On a `IDetailChildrenBuilder` we can call `AddCustomRow` just as we can on a `IDetailCategoryBuilder`.
We get a `FDetailWidgetRow` back here as well.
So we can build our Node as-if it was a Category.

A `IDetailChildrenBuilder` can contain groups.
```cpp
class FMyNodeBuilder : public IDetailCustomNodeBuilder
{
    void GenerateChildContent(IDetailChildrenBuilder& ChildrenBuilder)
    {
        IDetailGroup& Group = ChildrenBuilder.AddGroup();
        // Add stuff to the Group.
    }
};
```

`IDetailCustomNodeBuilder` has a `Tick` function that is called if `RequiresTick` returns `true`.
Can be used to update the displayed values.

The Custom Node Builder is added to a Details Panel from a `IDetailLayoutBuilder`:
```cpp
class FMyClassCustomization : public IDetailCustomization
{
public:
    void CustomizeDetails(IDetailLayoutBuilder& DetailBuilder)
    {
        IDetailCategoryBuilder& Category = DetailBuilder.EditCategory("My Category");
        TSharedRef<FMyNodeBuilder> MyNodeBuilder = MakeShareable(new FMyNoeBuilder());
        Category.AddCustomBuilder(MyNodeBuilder);
    }
};
```

[[2020-11-04_18:53:51]] [Slate](./Slate.md)  
[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  


[Details Panel Customization @ docs.unrealengine.com](https://docs.unrealengine.com/4.26/en-US/ProgrammingAndScripting/Slate/DetailsCustomization/)  
["Unreal Engine 4 Customizing the Details Panel" by Markus Ort @ youtube.com](https://www.youtube.com/watch?v=x5_lILi6LpI)  
[Details Panel Customization @ kantandev.com](http://kantandev.com/articles/details-panel-customization)  