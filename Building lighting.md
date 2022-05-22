2022-03-15_16:22:35

# Building lighting

Lighting can be built from the command line with
```
UE_ROOT/Engine/Binaries/Linux/UE4Editor 
    PROJECT_NAME.uproject
    -run=resavepackages
    -buildlighting
    -quality=Medium
    -allowcommandletrendering
    -projectonly
```
I'm not sure the `-run=resavepackages` part is necessary.


## Timed out waiting for the recipient

Building lighting from the command line causes
```
LogInit: Error: Timed out waiting for the recipient (TimeWaitingSec = 60.010765)
```
on my machine.

I have seen a few posts about opening ports in the firewall and enabling the loopback device.
Did not fix it for me.

https://forums.unrealengine.com/t/linux/132091
```
sudo ufw disable
```

https://forums.unrealengine.com/t/after-every-success-build-i-get-lighting-needs-to-rebuild-on-linux/400252
```
I solved the problem by making sure that the firewall is not blocking port 6666 and/or 230.0.0.1 network
sudo iptables -A INPUT -p UDP -d 230.0.0.1 --destination-port 6666 -j ACCEPT
and for ubuntu
sudo ufw allow to 230.0.0.1 port 6666 proto udp
```

https://forums.unrealengine.com/t/lightmass-static-lightning-timed-out-asserts-mismatch-in-task-counting/457350/4
suggests that it is a bug in the Local Swarm implementation, in `HandlePongMessage`.
```cpp
void FSwarmInterfaceLocalImpl::HandlePongMessage( const FSwarmPongMessage& Message, const TSharedRef<IMessageContext, ESPMode::ThreadSafe>& Context )
{
	if (!Recepient.IsValid() && Message.bIsEditor != bIsEditor && Message.ComputerName == FPlatformProcess::ComputerName())
	{
		Recepient = Context->GetSender();
	}
}
```

This is the code that determines if a connected client is the one we're waiting for.
The poster on forums.unrealengine.com says that the `Message.bIsEditor != bIsEditor` part always fails.
The poster suggests changing this to `Message.bIsEditor == bIsEditor`.
For my experiment I changed it to
```cpp
void FSwarmInterfaceLocalImpl::HandlePongMessage( const FSwarmPongMessage& Message, const TSharedRef<IMessageContext, ESPMode::ThreadSafe>& Context )
{
	const bool Original = Message.bIsEditor != bIsEditor;
	const bool MyEdit = true;
	if (!Recepient.IsValid() && MyEdit && Message.ComputerName == FPlatformProcess::ComputerName())
	{
		Recepient = Context->GetSender();
	}
}
```

This made the lighting building process start, but get another error
```
LightingResults: Error: Import Volumetric Lightmap failed: Expected 128 tasks, only 0 were reported as completed from Swarm
```
multiple times with various values for the number of tasks.

Testing with `const bool MyEdit = Message.bIsEditor == bIsEditor;` as well.
Same error.
This was done with 4.25, testing with 4.27.
On 4.27 it seems that `-buildlighting` does nothing.