2020-08-31_16:29:29

# Render commands

Render commands are code that is run on the render thread.

An example:
```c++
ENQUEUE_RENDER_COMMAND(UpdateLUT)(
    [Data=RenderData, InBytes=ImageBytes,
     LUT=ImpactLUT->Resource->TextureRHI](
        FRHICommandListImmediate& RHICommandList)
    {
        uint32 DestStride = 0;
        FFloat16Color* DestBuffer = static_cast<FFloat16Color*>(
            RHILockTexture2D(
                LUT->GetTexture2D(), 0, RLM_WriteOnly,
                DestStride, false, false));
        FMemory::Memcpy(
            DestBuffer, Data.GetData(), InBytes);
        RHIUnlockTexture2D(LUT->GetTexture2D(), 0, false, false);
    }
);
```

Another example:
```c++
ENQUEUE_RENDER_COMMAND(MyCommandName)(
    [RHITexture=MapTextureRT->Resource->TextureRHI,
     PixelData, SizeX, SizeY](
        FRHICommandListImmediate& RHICmdList)
    {
        // Render thread code goes here.
    }
);
```

Fences can be used to communicate between the render thread and the game thread (I think).
Used to prevent garbage collection of stuff still used by the render thread but released by the game thread.
Often faster than a pipeline flush.
```c++
void MyClass::BeginDestroy()
{
    Super::BeginDestroy();
    // Use a fence to keep track of when the rendering thread executes
    // this scene detachment.
    // See UPrimitiveComponent.
    RenderingFence.BeginFence(); // Not sure what type RenderingFence is.
    AActor* Owner = GetOwner();
    if (Owner)
    {
        Owner->DetachFence.BeginFence();
    } 
}

bool MyClass::IsReadyForFinishDestroy()
{
    return Super::IsReadyForFinishDestroy() &&
        RenderingFence.IsFenceComplete();
}
```

[ThreadedRendering@docs.unrealengine.com](https://docs.unrealengine.com/en-US/Programming/Rendering/ThreadedRendering/index.html)