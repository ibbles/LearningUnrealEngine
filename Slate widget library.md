2021-06-15_15:39:37

# Slate widget library

## Combo box

A combo box is a list of entries of which a single element is selected and shown at a time.
When activated, e.g., by a click, the complete list of entries is presented and the user can select one.
(
I guess one can do a multi-selection combo box, but the selection state and visualization will need to be handled separate from the combo box.
The combo box will only report the item that was selected, which the application can take to mean that the selection state of that object is toggled, instead of the normal make-the-selected-item-the-selected-item.
`SComboBox::GetSelectedItem` becomes a bit strange in this setup.
Also worried about the default orange background of the selected item.
Need a way to override that, and color all selected items with the selection highlight color.
)

The class that implements this functionality in Slate is called `SComboBox`.
To use it, first include `"Widgets/Input/SComboBox.h"`.

`SComboBox` is templated on the type that it should contain.
The type must be `ObjectBase*`, `TFieldPath`, `TSharedRef`, or `TSharedPtr`.
Pretty much any type can be wrapped in a `TSharedRef` or a `TSharedPtr`.
To create a new `SComboBox` holding the names of things, use
```cpp
SNew(SComboBox<TSharedRef<FName>>)
```

`SComboBox` uses a callback to generate a widget for each entry.
The callback has the signature `TSharedRef<SWidget>(T)` where `T` is the type of the entries.

`SComboBox` uses a callback to notify when a new entry has been selected.
This callback is also called when `SetSelectedItem` is called directly.
The callback has the signature `void (T, ESelectInfo::Type SelectInfo)`.
If `T` is a `TSharedRef` then a `TSharedPtr` is passed instead to allow deselecting the currently selected entry.
The `ESelectInfo` enum has the following literals:
```

/** User selected via a key press */
OnKeyPress,

/** User selected by navigating to the item */
OnNavigation,

/** User selected by clicking on the item */
OnMouseClick,

/** Selection was directly set in code */
Direct
```

```cpp
SNew(SComboBox<>)
```


## SNumericEntryBox

For numeric types, using`SNumericEntryBox`is recommended which allows you to optionally return no value in its value attribute. It will then display a label you provide instead. See`SNumericEntryBox.h`.