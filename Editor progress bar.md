2021-04-28_13:14:13

# Editor progress bar

```cpp
const int32 NumWorkItems = 5;
const float AmountOfWork = 100.0f; // Whatever you want. Using percent here.
const bool bAllowCancel = true;
FScopedSlowTask MyTask(AmountOfWork, LOCTEXT("DoingWork", "DoingWork"), true);
MyTask.MakeDialog(bAllowCancel);
const float WorkPerItem = 1.0f / static_cast<float>(NumWorkItems);
for (int32 I = 0; I < NumWorkItems; ++i)
{
    if (MyTask.ShouldCancel())
    {
        break;
    }
    MyTask.EnterProgressFrame(WorkPerItem); // Can be any fraction of AmountOfWork.
    // Do some work here.
}
```

[[2020-08-17_13:41:16]] [Backgrund tasks](./Backgrund%02tasks.md)  
