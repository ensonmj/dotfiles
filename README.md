# Dotfiles

Linux configuration is managed by GNU Stow. The same checkout supports native
Linux, WSL, and Windows VS Code.

The top-level `vscode/` directory contains configuration shared by VS Code
clients. Windows-only installers and WSL host configuration live under
`windows/`.

## Recommended layout

On native Linux, clone the repository anywhere in the Linux filesystem. On WSL,
clone it into the WSL filesystem, normally at `~/.dotfiles`:

```text
WSL:     /home/<user>/.dotfiles       (Git checkout and source of truth)
Windows: %APPDATA%\Code\User\*.json   (symbolic links into the WSL checkout)
```

Do not keep the checkout under `/mnt/c` and link it into WSL. DrvFS is slower
for Linux tools and has different permission, case-sensitivity, executable-bit,
and symlink semantics. Windows can access the WSL checkout through
`\\wsl.localhost\<distro>\home\<user>\.dotfiles` while the distribution is
running.

Two files are exceptions: `%USERPROFILE%\.wslconfig` and
`%USERPROFILE%\ssh.bat`. Windows needs them before (or in order to) start WSL,
so linking them back into WSL creates a bootstrapping dependency. The WSL
installer keeps managed copies and backs up a differing destination before an
update.

## Install

On Linux or WSL:

```bash
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

For a native Linux VS Code client, link the shared User configuration with:

```bash
./vscode/install.sh
```

On WSL, also install the Windows integration:

```bash
./windows/install.sh
```

This synchronizes the two bootstrap files, links Windows VS Code
`settings.json` and `keybindings.json` to this checkout, and installs the listed
extensions. Creating Windows symbolic links requires either Developer Mode or
an elevated terminal when the repository is in WSL. For a repository on the
same Windows volume, the installer can fall back to hardlinks. Run
`wsl --shutdown` after changing `.wslconfig`.

On native Windows without WSL integration, run
`windows\vscode\install.bat`; its source files must remain in a
Windows-accessible location.

### VS Code configuration scopes

`vscode/settings.json` and `vscode/keybindings.json` are valid User-level files
on both Windows and native Linux, and both installers link to these same source
files. The current settings include a few Windows/WSL-specific values such as
`remote.SSH.path`, `remote.SSH.configFile`, and `vscode-neovim.useWSL`; VS Code
can load the file on Linux, but those features need Linux-specific values if
they are used there.

A Remote WSL window still uses the Windows User settings for UI behavior and
keybindings. Remote machine settings and remote extensions belong to the WSL
server separately; do not link the complete User settings file to
`~/.vscode-server/data/Machine/settings.json`.

## Migrating an existing Windows-hosted checkout

Commit or otherwise save local changes first. Record the remote URL, remove only
the WSL-side link, then clone into WSL:

```bash
repo_url=$(git -C ~/.dotfiles remote get-url origin)
rm ~/.dotfiles
git clone "$repo_url" ~/.dotfiles
cd ~/.dotfiles
./install.sh
./windows/install.sh
```

The old Windows checkout can be removed after comparing it with the new clone.
