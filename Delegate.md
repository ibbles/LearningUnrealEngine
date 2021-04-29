2021-03-10_10:42:34

# Delegate

A Deletage is a type of callback, or rather a system for declaring and specifying callbacks.
A sender has the Delegate and a receiver binds a function to that Delegate.
When the sender triggers the Delegate the function in the receiver is invoked.

Each Delegate need both a type declaration and an instance declaration.
The type is declared with the `DECLARE_DELEGATE` macro, passing the the name of the type.
The instance is declared just as any other member variable.

In this example we create a Delegate that is triggered whenever a specific Property is changed in the Editor.

`MySender.h`:
```cpp
#include "CoreMinimal.h"

// This declares the Delegate type.
DECLARE_DELEGATE(FMyDelegate);

// An example UObject with a Delegate and a member function
// that triggers it.
UCLASS()
class MYMODULE_API UMySender : public UObject
{
    GENERATED_BODY();

public:
    UPROPERTY(EditAnywhere, Category = "My Category")
    float MyProperty;
    
    // ~Begin UObject interface.
#if WITH_EDITOR
    virtual void PostEditChangeProperty(FPropertyChangedEvent& Event) override;
#endif
    // ~End UObject interface.
public:
    FMyDelegate MyDelegate;
};
```

`MySender.cpp`:
```cpp
void UMySender::PostEditChangeProperty(FPropertyChangedEvent& Event)
{
    Super::PostEditChangeProperty(Event);
    if (Event.MemberProperty == GET_MEMBER_NAME_CHECKED(UMySender, MyProperty))
    {
        MyDelegate.ExecuteIfBound();
    }
}
```

On the receiver we need access to the Delegate object and a function to bind to it.

`MyReceiver.h`:
```cpp
UCLASS()
class MYMODULE_API UMyReceiver : public UObject
{
    GENERATED_BODY()
    
public:
    UMyReceiver();
    
    UPROPERTY(VisibleAnywhere, Category = "My Category")
    UMySender* MySender;
    
    void SetMySender(UMySender* InMySender);
    
    void MyPropertyChanged();
};
```

`MyReceiver.cpp`:
```cpp
void UMyReceiver::SetMySender(UMySender* InMySender)
{
    InMySender->MyDelegate.BindUObject(this, &UMyReceiver::MyPropertyChanged);
}

void UMyReceiver::MyPropertyChanged()
{
    // Put your logic here.
}
```

There are variants of the `DECLARE_DELEGATE` macro that designate Delegates that expect functions with a return value or parameters.
- `DECLARE_DELEGATE_RetVal`
- `DECLARE_DELEGATE_OneParam`
- `DECLARE_DELEGATE_TwoParams`
- `DECLARE_DELEGATE_RetVal_TwoParams`


Some functions take a Delegate as a parameter.
We use the a family of `static` Create functions on each Delegate type to create such instances.

```cpp
void FunctionWithDelegate(FMyDelegate);

void TheCallback()
{
    // Put your logic here.
}

void CallFunctionWithDelegate()
{
    FunctionWithDelegate(FMyDelegate::CreateStatic(&TheCallback));
    FunctionWithDelegate(FMyDelegate::CreateLambda([] { /* Put your logic here. */ }));
}
```

There is also
- `CreateSP(object, member-function)`: Used for `F`-types, uses a shared pointer to hold on to the object.
- `CreateUObject(object, member-function)`:  Used for `U`-types.
- `CreateRaw`: Don't know.

[[2021-03-10_10:35:35]] [Timer](./Timer.md)  
[[2020-09-30_13:13:51]] [Callbacks](./Callbacks.md)  
[[2020-06-29_13:29:35]] [Events](./Events.md)  