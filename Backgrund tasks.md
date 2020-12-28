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