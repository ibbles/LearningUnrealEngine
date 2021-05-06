2020-11-08_20:55:51

# Custom console commands

```c++
void FMyModule::StartupModule()
{
    if (IsRunningCommandlet())
    {
        return;
    }

    IConsoleManager::Get().RegisterConsoleCommand(
        TEXT("MyCommand")
        TEXT("Description for MyCommand."),
        FConsoleCommandDelegate::CreateStatic(MyConsoleCommand),
        ECVF_Default);
}

void FMyModule::MyConsoleCommand()
{

}

```

[[2020-11-21_15:49:09]] [Console](./Console.md)  

["C++ Extending the Editor" By Unreal Engine @ youtube.com](https://youtu.be/zg_VstBxDi8?t=1639)  