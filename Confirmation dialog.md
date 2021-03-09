2021-03-09_20:03:05

# Confirmation dialog

A confirmation dialog is created with `FSuppressableWarningDialog`.
The `Suppressable` part means that the dialog will have a checkbox that when checked will suppress that dialog in the future.
The suppression is saved in one of the `.ini` files, `GEditorPerProjectIni` by default.

The following example shows how the ask the user if The Thing should be done.
```cpp
bool ShouldTheThingBeDone(const FText& Title, const FText& Message, const FString& InitSetting)
{
    FSuppressableWarningDialog::FSetupInfo Info(Message, Title, IniSetting);
    Info.ConfirmText = LOCTEXT("DoTheThingYes", "Do The Thing!");
    Info.CancelText = LOCTEXT("DoTheThingNo", "Don't do the thing");
    Info.CheckBoxText = FText::GetEmpty();	// By setting this to Empty we prevent suppressing.

    FSuppressableWarningDialog ReparentBlueprintDlg(Info);
    return ReparentBlueprintDlg.ShowModal() != FSuppressableWarningDialog::Cancel;
    
    // ShowModal return either Suppressed, Cancel, eller Confirm.
    // It's unclear to me how Suppressed is supposed to be handled.
    // This example takes Suppressed to mean Confirm, following a comment in the Engine source:
    // > User previously suppressed dialog, in most cases this should be treated as confirm.
    
}
```

Example usage:
```cpp
const FText Title = LOCTEXT(
    "DoThingTitle",
    "Do the thing?");
const FText Message = LOCTEXT(
    "DoThingMessage",
    "Should the thing be done?");
const FString InitSetting = TEXT(
    "ShouldDoTheThing");

if (ShouldTheThingBeDone(Title, Message, IniSetting))
{
    DoTheThing();
}
```

This is editor-only.