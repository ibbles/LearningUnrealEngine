2020-04-10_21:42:47

# Project steps

- Import assets.
- Setup input event bindings.
- Create `TwinStickMode`.
    - Add function `void RespawnPlayer()`.
        - Destroy all enemies.
        - Call SpawnActor HeroCharacter.
        - Call GetPlayerController::Possess(HeroCharacter).
    - Add function `void IncrementScore(Float DeltaScore)`.
    - In BeginPlay, start the Enemy Spawner timer.
    - Set DefaultPawnClass to HeroCharacter.
- Set TwinStickMode in Project Settings → Project → Maps & Modes → Default Modes → Default GameMode.
- Create `BaseCharacter` C++ class.
    - `void CalculateHealth()` that sets `bIsDead`.
- Create `iDamageable` Blueprint Interface.
    - Add function `void AffectHealth(Float Delta)`.
- Create `HeroCharacter` Blueprint based on `BaseCharacter`.
    - Spawn and attach `Weapon` Actor on BeginPlay.
    - Record spawn transform in `TwinStickMode` on BeginPlay.
    - Create HUD. (Why is this done in the HeroCharacter?)
    - Bind InputAxis events to `Add Movement Input`.
    - Bind InputAxis events to `Set Control Rotation` and `Pull/Release Trigger`.
    - In `AffectHealth`:
        - Call `CalculateHealth`.
        - Test `IsDead`.
        - Disable input.
        - Delay.
        - Call `TwinStickMode::RespawnPlayer`.
        - Destroy both the `HeroCharacter` and its `Weapon`.
- Create `EnemyCharacter`.
    - Create DamageVolume.
    - Add ActorBeginOverlap Event. Start DamageTheHero timer.
    - Add DamageTheHero Event. Call AffectHealth on the hero.
    - Add ActorEndOverlap Event. Disable the DamageTheHero timer.
    - Add AffectHealth Event. Call `CalculateHealth`, check `IsDead`, call `TwinStickMode::IncrementScore`, set WorldDynamic and Pawn collision channels to Ignore, detach from controller pending destroy, delay, destroy actor.
- Create Weapon Actor.
- 

[[2020-04-10_21:40:28]] [col] TwinStickShooter


