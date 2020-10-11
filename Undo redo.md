2020-09-30_13:19:47

# Undo redo

Undo-redo pairs are created from C++ by creating an `FScopedTransaction` on the stack:

```
FScopedTransaction transaction(); // will open up a slot in for data in GEditor
Modify(); // On what should this be called? The FScopedTransaction? Or is `Modify` a stand-in name for any modification on any object?
// Do you modifications.

//~FScopedTransaction() will finish the transaction, called when `transaction` goes out of scope.
```