2021-05-06_21:33:14

# Adding icon/sprite to Actor

Some Actors use an icon to be visible in the Editor Viewport even when they don't contain any visible Components.
We can specify which icon to use in the Actor's constructor:

```cpp
AMyActor::AMyActor(const FObjectInitializer& ObjectInitializer)
	: Super(ObjectInitializer)
{
#if WITH_EDITORONLY_DATA
	if (!IsRunningCommandlet())
	{
		// Structure to hold one-time initialization
		struct FIconInfo
		{
			ConstructorHelpers::FObjectFinderOptional<UTexture2D> ViewportIconTextureObject;
			FName Id;
			FText Name;

			FIconInfo()
				: ViewportIconTextureObject(TEXT("/Engine/EditorResources/S_Note"))
				, Id(TEXT("MyActor"))
				, Name(LOCTEXT("MyActorIcon", "MyActorIcon"))
			{
			}
		};
		static FIconInfo IconInfo;

		if (auto Sprite = GetSpriteComponent())
		{
			Sprite->Sprite = IconInfo.ViewportIconTextureObject.Get();
			Sprite->SpriteInfo.Category = IconInfo.Id;
			Sprite->SpriteInfo.DisplayName = IconInfo.Name;
		}
	}
#endif
}
```

`GetSpriteComponent` is not provided by any of the regular classes, so not all Actors has one.
Examples of Actors that do are `AInfo` and `DecalActor`.


[[2021-04-03_18:13:02]] [Adding icon-sprite to Component](./Adding%20icon-sprite%20to%20Component.md)  
