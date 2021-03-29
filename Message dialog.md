2021-03-25_09:06:36

# Message dialog

This example shows how to open a basic message dialog with an OK button:
```cpp
const FText Text = LOCTEXT("MyText", "The text to show in the dialog box.");
const FText Title = LOCTEXT("MyTitle", "A Title");
    FMessageDialog::Open(EAppMsgType::Ok, Text, &Title);
}
```

There are a few different `EAppMsgType` values that can be sent:
```cpp
Ok,
YesNo,
OkCancel,
YesNoCancel,
CancelRetryContinue,
YesNoYesAllNoAll,
YesNoYesAllNoAllCancel,
YesNoYesAll,
```

The possible return values from the function depend on the message type passed.
It will be one of:
```cpp
enum Type
{
    No,
    Yes,
    YesAll,
    NoAll,
    Cancel,
    Ok,
    Retry,
    Continue,
};
```

So a basic confirmation dialog can be made with:
```cpp
void OptionallyDoTheThing()
{
    const FText Text = LOCTEXT("DoTheThingText", "Should the thing be done?");
    const FText Title = LOCTEXT("DoTheThingTitle", "Do the thing?");
    if (FMessageDialog::Open(EAppMsgType::OkCancel, Text, &Title) == FMessageDialog::Ok)
    {
        DoTheThing();
    }
}
```
There is also a dedicated class for these kinds of dialogs, called `FSuppressableWarningDialog`.


[[2021-03-09_20:03:05]] [Confirmation dialog](./Confirmation%20dialog.md)  