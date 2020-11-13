2020-11-09_16:56:34

# Detail Customization

The Details Panel contains a list of categories and two columns.
Categories are collapsable collections of rows.
Each row holds and Item.
Each item consists of a name column and a value column.
The name, value, or even the entire Item, can by any Slate widget.
The Category contains helper functions for adding commong widgets.
Such as property editors.

An instance of `IDetailLayoutBuilder` is used to build the Details Panel.
It builds and edits Categories, and creates item rows.

## Module setup

All Detail Customizations should be added to an Editor Module within the project or plugin.
Example Module entry in `.uproject`:
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
```c++
#pragma once
#include "CoreMinimal.h"
#include "Input/Reply.h"
#include "IDetailCustomization.h"

class FMyClassCustomization : public IDetailCustomization
{
public:
    static TSharedRef<IDetailCustomization> MakeInstance();
    
    virtual void CustomizeDetails(IDetailLayoutBuilder& DetailBuilder) override;
    
    // Member functions for callbacks bound to widget events can be put here.
    // Member variables needed can be put here.
};
```

Implement as follows:
```c++
#define LOCTEXT_NAMESPACE "MyEditorModule"

TSharedRef<IDetailCustomization> FMyClassCustomization::MakeInstance()
{
    return MakeShareable(new FMyClassCustomization);
}

void FMyClassCustomization::CustomizeDetails(
        IDetailLayoutBuilder& DetailBuilder)
{
    // This is where we create the contents of the Details Panel.
    // Use DetailBuilder.GetObjectsBeingCustomized to get the selected objects.
    // Use DetailBuilder.EditCategory to get or create a category.
    // Use Category.AddCustomRow to add new rows to the category.
}
```

In the `StartupModule` member function for your new Editor Module:
```c++
void FMyEditorModule::StartupModule()
{
    FPropertyEditorModule& PropertyModule = 
        FModuleManager::LoadModuleChecked<FPropertyEditorModule>(
            "PropertyEditor");
    
    PropertyModule.RegisterCustomClassLayout(
        UMyClass:StaticClass()->GetFName(),
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
        UMyClass:StaticClass()->GetFName());
}
```

## Example class

As an example, consider the following class for which we wish to create a custom Details Panel.
```c++
UCLASS()
class UMyClass: public UObject
{
    GENERATED_BODY()
    
public:
    UPROPERTY(EditAnywhere, Category = "Person")
    FString FavoriteFood;

    UPROPERTY(EditAnywhere, Category = "Person")
    int32 MaxServings;
    
    UPROPERTY(VisibleAnywhere, Category = "Pet")
    TArray<FString> PetNames;
};
```

## Creating a Details Panel

When a Details Panel for a type for which a `CustomClassLayout` has been registered is opened in Unreal Editor the editor will call the corresponding `CustomizeDetails` member function.
`CustomizeDetails` is only called once per selection change.
This means that any dynamic updates must be handled either with Properties or Attributes.
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
We get property handles from the `IDEtailLayoutBuilder` instance passed to `CustomizeDetails`.
```
TSharedRef<IPropertyHandle> FavoriteFoodProperty =
    DetailBuilder.GetProperty(GET_MEMBER_NAME_CHECKED(UMyClass, FavoriteFood));
```
Check that the property is valid with `IsValidHandle` before use.
We can get property handles to struct members from a struct property handle.

Any `UPROPERTY` that we don't explicitly modify will get a default created row in the category set in the `UPEROPRTY` macro.
The row is added after the rows customized by `CustomizeDetails`.

We hide default-created properties with `DetailBuilder.HideProperty(Property);`.
We add a property widget to a category with `PersonCategory.AddProperty(FavoriteFoodProperty);`.

```c++
void FMyClassCustomization::CustomizeDetails(
        IDetailLayoutBuilder& DetailBuilder)
{
    DetailBuilder.HideCategory(TEXT("Pet"));
    
    IDetailCategoryBuilder& PersonCategory =
        DetailBuilder.EditCategory(TEXT("Person"));
    
    TSharedRef<IPropertyHandle> FavoriteFoodProperty =
        DetailBuilder.GetProperty(
            GET_MEMBER_NAME_CHECKED(UMyClass, FavoriteFood));
    check(FavoriteFoodProperty.IsValidHandle());
    PersonCategory.HideProperty(FavoriteFoodProperty);
    
    TSharedRef<IPropertyHandle> PetProperty =
        DetailBuilder.GetProperty(
            GET_MEMBER_NAME_CHECKED(UMyClass, Pet));
    check(PetProperty.IsValidHandle());
    PersonCategory.AddProperty(PetProperty);
}
```

`IDetailCategoryBuilder::AddProperty` returns a `IDetailPropertyRow` which can be used to customize the row.
`IDetailPropertyRow` contains a bunch of callbacks used by the editor to query the wanted state of the row.
For example, a `bool`-returning function can be passed to `IDetailPropertyRow::Visibility`.
The "function" isn't really a function but an "attribute" of some kind.
These functions are called frequently, much more than `CustomizeDetails`, so they should be fast.
```c++
void FMyClassCustomization::CustomizeDetails(
    IDetailLayoutBuilder& DetailBuilder)
{
    IDetailCategoryBuilder& PersonCategory =
        DetailBuilder.EditCategory(TEXT("Person"));
    
    TSharedRef<IPropertyHandle> PetProperty =
        DetailBuilder.GetProperty(
            GET_MEMBER_NAME_CHECKED(UMyClass, FavoriteFood));
    check(FavoriteFoodProperty.IsValidHandle());
    
    auto IsPetVisibleFun = []
    {
        return /*bool expression*/ ?
            EVisibility::Visible :
            EVisibility::Collapsed;
        };
    auto IsPetVisibleAttr = TAttribute<EVisibility>::Create(
        TAttribute<EVisibility>::FGetter::CreateLambda(IsPetVisibleAttr));
    Person.AddProperty(PetProperty)
       .Visibility(IsPetVisibleAttr);
}
```

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
        return;
    }
    
    TWeakObjectPtr<UMyClass> MyObject = Cast<UMyClass>(Objects[0].Get());
```
A registered Custom Class Layout doesn't replace the default Details Panel but customizes it, and if no customization is done then the default Details Panel is retained.

## Custom rows

A custom row is a row in a category that we can add arbitrary Slate widgets to.
The widget can either replace the entire row, or the name- and/or value columns separately.
These customization points are called slots.
A custom row has a set of filter keywords that are matched against when typing the the Details Panel's search box.
```c++
PersonCategory.AddCustomRow(
    LOCTEXT("FilterKeywords", "Keywords used when filtering"))
```
We access the customization slots using the member functions `WholeRowContent`, `NameContent`, and `ValueContent` where `WholeRowContent` is the whole row and `NameContent` and `ValueContent` are the two columns.
Do not customize both `WholeRowContent` and either of the two column slots on the same row.
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

The Visibility attribute can be used on a custom row.
```
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
```c++
auto IsErrorVisibleFun = [MyObject]
{
    return MyObject.IsValud() && MyObject->IsBroken() ?
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
```c++
AgxCategory.AddCustomRow(LOCTEXT("FilterKey", "FilterValue"))
[
    SNew(SHorizontalBox)
    + SHorizontalBox::Slot()
    .AutoWidth() // There are also VAlign, Padding, MaxWidth, and more.
    [
        SNew(STextBlock)
        .Text(LOCTEXT("Example text", "Example text."))
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
        // combo box. May after a open/close cycle.
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
        // item and a `ESelectionInfo::Type` The ExtraParameter member is
        // passed on to the memberfunction but otherwise ignored by the
        // callback framework.
        // In this example MyCallback assigns the selected FName to a member
        // variable named `CurrentSelection`.
        .OnSelectionChanged(
            this, &FMyClassCustomization::MyCallback, ExtraParameter)
        // The Content slot is the title of the combo box. This is always
        // visible, even when the combo box is closed. This is often used to
        // visualize the currently selected item.
        // In this example, `CurrentSelection` is a member variable of type
        // FName to which the currently selected combo box item 
        // assigned.
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

To update the Details Panel after changing something that affects it, e.g., from a button callback, or when a change is detected by `OnEditChangePropeperty`, try calling `DetailBuilder.ForceRefreshDetails();`.
This is a heavy operation, so use sparingly and with caution.

## Complete example

```c++
#pragma once
#include "CoreMinimal.h"
#include "Input/Reply.h"
#include "IDetailCustomization.h"

class FMyClassCustomization : public IDetailCustomization
{
public:
    static TSharedRef<IDetailCustomization> MakeInstance();
    
    virtual void CustomizeDetails(IDetailLayoutBuilder& DetailBuilder) override;
    
    FReply ButtonCallback();
};
```

Implement as follows:
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
            .Font(IdetailLayoutBuilder::GetDetailFont())
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


[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  



["Unreal Engine 4 Customizing the Details Panel" by Markus Ort @ youtube.com](https://www.youtube.com/watch?v=x5_lILi6LpI)  
[Details Panel Customization @ kantandev.com](http://kantandev.com/articles/details-panel-customization)  