2020-11-26_12:52:48

# Git

## LFS for binary files

LFS stands for Large File Storage.
Stores binary file data outside of the repository.
The repository holds links into the binary storage.
LFS enabled clients follows those links and replaces them with the actual data.
Not always supported by server and client.
Must be enabled.
Must be configured to track specific files or file types.
Track `.uasset`, `.umap`, and any other large binaries you have stored in the repository, such as images, audio, model sources, etc.

LFS Migrate is used to purge binary files from the revision history and replace them with LFS links.

LFS supports locking, on some hosts/versions.
When enabled, binary files in the working copy start off marked read-only.
Lock the file with LFS to mark it writable and send a lock event to the server.
The lock will fail if another client has already locked the file.

## Editor integration
Unreal Editor has a plugin for working with git repositories.
It can flag assets in the Content Browser as untracked and changed.
It has a built-in diff viewer for some types of assets, such as Blueprints.
Falls back to a text diff for most other assets.
Sort of does nothing for the rest, such as level assets.
Which diff tool to use it set in Top Menu > Edit > Editor Preferences > General > Loading & Saving > Source Control > Tool for diffing text.