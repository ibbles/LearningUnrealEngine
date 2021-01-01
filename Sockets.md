2020-08-06_22:51:24

# Sockets

Sockets are named attachment points on meshes.
They specify a location and a rotation on the mesh.
When calling `USceneComponent::SetupAttachment` an optional socket name can be passed in.
To attach to that socket instead of at the parent's origin.

`TODO:` How are sockets created?

Sockets are added in the Static Mesh Editor, with Window > Socket Manager > Create Socket.
Sockets are added to an `UStaticMesh` with `UStaticMesh::AddSocket(UStaticMeshSocket*)`.

Sockets are added to a Skeletal Mesh in the Skeletal Mesh Editor by right-click a joint > Add Socket.
There doesn't appear to be an `USkeletalMesh::AddSocket(USkeletalMeshSocket*)`.

There are a bunch of socket-related member functions on `USceneComponent` as well.
Many of them are all `virtual` and the provided implementation mostly empty.
`USceneComponent` doesn't seem to hold any sockets itself.
`USpringArmComponent` does provide sockets, but also doesn't store them.
Instead the data about it's only socket is created on demand.
All the socket query functions take a socket name, but `USpringComponent` ignores that.
`UStaticMeshComponent` uses `UStaticMesh` for most of the socket related work, possibly with some processing.
`UStaticMesh` has an array of `UStaticMeshSocket`.
So in short, there is no canonical `[UF]Socket` type. (`FSocket` is a network socket, completely unrelated.)
Instead the socket API is on the socket owning type and identifies the socket by name.
The internal representation can be whatever the owning type needs the socket to be.
This means that sockets cannot be added on arbitrary `USceneComponents`.
Each subclass must implement its own socket API.


Example usage. `AMyAttachment` is an Actor that is meant to attach to another Actor.
Think a tool held in a hand or an ornament attached to a vehicle.
```c++
void AMyAttachment::AttachToOwner()
{
    // GetHolderActor is a project-specific function that returns
    // the Actor that this Actor is attached to.
    // GetAttachmentComponent is a project-specific function that
    // returns a USceneComponent whose purpose is to act as an
    // attachment point for various types of attachments.
    // AttachmentTypeName is a project-specific FString member variable
    // that holds an indetifier for the type of attachment that this
    // Actor is. The idea is that different types of attachments attach
    // to different Components and/or different sockets on that Component.
    AttachToComponent(
        GetAttachActor()->GetAttachmentComponent(AttachmentTypeName),
        FAttachmentTransformRules::SnapToTargetNotIncludingScale,
        AttachmentTypeName);
}

void AMyAttachment::DetachFromOwner()
{
    DetachFromActor(FDetachmentTransformRules::KeepWorldTransform);
}
```