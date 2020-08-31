2020-08-31_16:15:47

# Error reporting

Errors can be reported with the following:
- `check` macro. Kills the editor/game.
- `UE_LOG` macro. Prints a message to the log.
- `Print String` Blueprint node to log to screen.
- Show a modal dialog box. Not sure how.
- Show a notification dialog, like the "compiling shaders" message. Not sure how.


Errors can be reported from the following locations:
- `BeginPlay`.
- `PostEditChangeProperty`.