# Adding icon to Actor

Actors use an icon to be visible in the Editor Viewport even when they don't contain any visible Components.
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
#endif // WITH_EDITORONLY_DATA
}
```