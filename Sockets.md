2020-08-06_22:51:24

# Sockets

Sockets are named attachment points on meshes. (I think)

Example usage:
```c++
void AKaosWeapon::AttachToOwner()
{
    AttachToComponent(
        GetKaosPawn()->GetMesh(),
        FAttachmentTransformRules::SnapToTargetNotIncludingScale,
        GetWeaponDefinition()->AttachmentSocket);
    SetEquipped(true);
    KAOS_ALOG(
        this, LogKaosWeapon, Verbose,
        "Attached to owner: %s",
        *GetNameSafe(GetKaosPawn()))
    }
void AKaosWeapon::DetachFromOwner()
{
    DetachFromActor(FDetachmentTransformRules::KeepWorldTransform);
    SetEquipped(false);
    KAOS\_ALOG(
        this, LogKaosWeapon, Verbose,
        "Detached from owner: %s",
        *GetNameSafe(GetKaosPawn()))
}
```