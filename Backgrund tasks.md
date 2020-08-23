2020-08-17_13:41:16

# Background tasks

Look at `ObjectTools::DeleteObjects`.
Uses `FAssetDeleteModel`, `DeleteModel->Tick`, `DeleteModel->GetState`, `DeleteModel::GetProgress`, and `GWawn->StatusUpdate`.

Somewhat reduced:
```c++
TSharedRef<FAssetDeleteModel> DeleteModel = MakeShareable(
    new FAssetDeleteModel(ObjectsToDelete));
bool bUserCanceled = false;
GWarn->BeginSlowTask(
    NSLOCTEXT("UnrealEd", "VerifyingDelete", "Verifying Delete"),
    true, true);
while (!bUserCanceled && 
       DeleteModel->GetState() != FAssetDeleteModel::Finished)
{
	DeleteModel->Tick(0);
	GWarn->StatusUpdate(
        (int32)(DeleteModel->GetProgress() * 100),
        100, DeleteModel->GetProgressText());
	bUserCanceled = GWarn->ReceivedUserCancel();
}
GWarn->EndSlowTask();
```

