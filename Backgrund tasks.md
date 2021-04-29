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

## FRunnable

Example of how to setup a background task using `FRunnable`.
This example may be incomplete, more reading necessary.
It seems to create a new thread for each execution. How do I use a thread pool instead?
```cpp
class AMyActor : public AActor
{
public:
    void BeginPlay();
private:
    void CheckIsWorkerDone();
private:
    // What should the pointer type be? Should it be marked UPROPERTY?
    FMyWorker* MyWorker;
    
    FTimerHandle WorkerTimerHandle;
}

void AMyActor::BeginPlay()
{
    MyWorker = FMyWorker::Launch();
    if (!GetWorldTimerManager().IsTimerActive(WorkerTimerHandle))
    {
        GetWorldTimerManager().SetTimer(
            WorkerTimerHandle, this, &AMyActor::CheckIsWorkerDone, 0.5f, true);
    }
}


FMyWorker* FMyWorker::Launch()
{
    if (!FPlatformProcess::SupportsMultithreading())
    {
        return nullptr;
    }
    if (Runnable != nullptr)
    {
        return Runnable;
    }
    Runnable = new FMyWorker(); 
    return Runnable;
}

class FMyWorker : public FRunnable /* I think, or a  subclass of FRunnable. */
{
public:
    static FMyWorker* Launch();
    virtual uint32 Run() override; /* The API reference says that Run isn't virtual. Odd. */
    virtual void Stop() override;
private:
    static FMyWorker* Runnable;
    
    // What should the pointer type be? Should it be marked UPROPERTY?
    FRunnableThread* Thread;
}

FMyWorker::FMyWorker()
{ 
    Thread = FRunnableThread::Create(this, TEXT("FMyWorker"), 0, TPri_BelowNormal);
}

uint32 FMyWorker::Run()
{
    /* Put your background code here. */
}
```


## Async

```cpp
TFuture<void> future = Async(EAsyncExecution::ThreadPool, [/*captures*/]() {
    // Do the background work here.
    // Not safe to do GameThread-only stuff here, such as SetActorLocation.

    // Schedule an "apply" task to apply the result of the background work onto any U-objects.
    AsyncTask(ENamedThreads::GameThread, [/*captures*/]() {
        // This is run on the game thread, so safe to do SetActorLocation and such.
    });
});
```


[[2021-04-28_13:14:13]] [Editor progress bar](./Editor%20progress%20bar.md)  


[Unreal 4 Threading - Running a Task on a Worker Thread @ YouTube](https://www.youtube.com/watch?v=1lBadANnJaw)  

