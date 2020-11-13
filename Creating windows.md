2020-11-08_20:24:08

# Creating windows

A floating Details Panel can be created with:
```c++
void FMyEditorModule::ShowFloatingDetailsPanel()
{
    UMyType * Instance = NewObject<UMyType>(
        GetTransientPackage(), /*What here?*/);
    Instance->AddToRoot();

    FPropertyEditorModule& PropertyModule =
        FModuleManager::LoadModuleChecked<FPropertEditorModule>(
            /*What here?*/);

    TArray<UObject*> ObjectsToView;
    ObjectsToView.Add(Instance);
    TSharedRef<SWindow> Window = PropertyModule.CreateFloatingDetailsView(
        ObjectsToView, )

    Window->SetOnWindowClosed(FOnWindowClosed::CreateStatic(
        &FMyEditorModule::MyFloatingDetailsPanelClosed, Instance));
}

void FMyEditorModule::FloatingDetailsPanelClosed(
    const TSharedRef<SWindow>& Window, UMyType* Instance)
{
    Instance->RemoveFromRoot();
}

```


["C++ Extending the Editor" by Unreal Engine@youtube.com](https://youtu.be/zg_VstBxDi8?t=1012)