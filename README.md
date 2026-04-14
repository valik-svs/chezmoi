# svs CLI setup

Managed by [chezmoi](https://www.chezmoi.io/).

## Current files

- `~/.zshenv`
- `~/.zshrc`
- `~/.zsh_plugins.txt`
- `~/.wezterm.lua`
- `~/.config/atuin/config.toml`
- `~/.config/starship.toml`
- `~/.config/starship-dark.toml`
- `~/.config/starship-light.toml`

## Shell Helpers

### Aliases

| Command | Description |
| --- | --- |
| `ls` | Uses `eza --group-directories-first` when `eza` is installed. |
| `ll` | Long `eza` listing with hidden files, git status, and directories first. |
| `tree` | Directory tree via `eza --tree --group-directories-first`. |
| `cat` | Uses `bat --paging=never` when `bat` is installed. |

### Fuzzy Helpers

| Command | Description |
| --- | --- |
| `fcd [root]` | Fuzzy-find a directory with `fd` + `fzf`, preview it with `eza`, then `cd` into it. Defaults to the current directory. |
| `fopen [root]` | Fuzzy-find a file with `fd` + `fzf`, preview it with `bat`, then open it in `$EDITOR`. Defaults to the current directory. |
| `fkill` | Fuzzy-select a process from `ps` and send it `kill`. |
| `fhist` | Fuzzy-search shell history and put the selected command back on the prompt for editing. |

### Completions

`antidote` loads `~/.zsh_plugins.txt`, which includes `zsh-users/zsh-completions`
for additional command completions. `compinit` is initialized after plugins are
loaded so the extra completion functions are available in new shells.

`zsh-users/zsh-autosuggestions` is also loaded for inline history-based
suggestions while typing. Press the right arrow key to accept the suggestion.

### Directory Jumping

`zoxide` is initialized as `z` when installed:

| Command | Description |
| --- | --- |
| `z <query>` | Jump to a frequently used directory matching the query. |
| `zi` | Interactive fuzzy directory jump. |

`zoxide` learns from normal `cd` usage, so it becomes useful after visiting projects a few times.

### Shell History

`atuin` is initialized when installed and replaces the default reverse history
search with a searchable, syncable command history.

| Command | Description |
| --- | --- |
| `atuin import auto` | Import existing shell history into Atuin. |
| `atuin register` | Create a sync account. |
| `atuin login` | Log into an existing sync account. |
| `atuin sync` | Sync history with the configured Atuin server. |

## Daily workflow

Edit a managed file:

```sh
chezmoi edit ~/.zshrc
chezmoi diff
chezmoi apply
```

Import current changes from `$HOME` into chezmoi:

```sh
chezmoi add ~/.zshrc
chezmoi add ~/.zsh_plugins.txt
chezmoi add ~/.wezterm.lua
chezmoi add ~/.config/atuin/config.toml
chezmoi add ~/.config/starship-dark.toml
chezmoi add ~/.config/starship-light.toml
```

Commit source state:

```sh
chezmoi cd
git status
git add .
git commit -m "Update shell setup"
```

## New machine

After pushing this repository to a remote:

```sh
brew install chezmoi
chezmoi init <repo-url>
chezmoi diff
chezmoi apply
```
