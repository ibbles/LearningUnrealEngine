2020-12-30_19:37:59

# Name

There is a difference between `GetName`/`GetObjectName` and `GetActorLabel`/`GetDisplayName`, but there is some kind of relationship between them.
In editor builds `GetActorLabel` returns the label of the actor in the World Outliner.
In non-editor builds `GetActorLabel` is forwarded to `GetName`.
The named returned by `GetActorLabel` is neither unique nor localized.
`GetActorLabel` should not be displayed to the end-user.
I assume end-user here means the player, and that showing the Actor Label to an Unreal Editor user is OK.

I don't know what the difference between Blueprint's `Get Display Name` and C++'s `GetActorLabel` is.