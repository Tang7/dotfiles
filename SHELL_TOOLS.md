# Shell Tools Reference

Tools identified from `.zshrc` and `README.md`.

---

## oh-my-zsh

Framework managing zsh plugins, themes, and completions. Currently using `gozilla` theme with the `git` plugin.

**What the `git` plugin gives you (most useful):**

| Alias | Command |
|-------|---------|
| `gst` | `git status` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gd` | `git diff` |
| `gaa` | `git add --all` |
| `gcmsg` | `git commit -m` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `glog` | `git log --oneline --decorate --graph` |
| `glola` | one-line log with all branches |

**Active plugins:**
```zsh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fzf)
```

| Plugin | What it does |
|--------|-------------|
| `git` | Git aliases (`gst`, `gco`, `glog`, etc.) |
| `zsh-autosuggestions` | Ghost-text completions from history — press `→` to accept |
| `zsh-syntax-highlighting` | Colors commands green/red as you type (valid/invalid) |
| `fzf` | Wires up `Ctrl+r`, `Ctrl+t`, `Alt+c` shell key bindings |

---

## zoxide

Smart `cd` replacement that learns your most-visited directories and lets you jump with partial names.

**Initialized in your `.zshrc`:**
```zsh
eval "$(zoxide init zsh)"
```

**Core usage:**

| Command | Behavior |
|---------|----------|
| `z foo` | Jump to the highest-ranked dir matching `foo` |
| `z foo bar` | Match both tokens (e.g. `z ag dot` → `~/Agaetis/dotfiles`) |
| `z -` | Jump to previous directory |
| `zi` | Interactive fuzzy picker (requires fzf) |

**Suggestions:**
- Use `zi` constantly — it drops you into an fzf list of your frecency-ranked dirs so you never have to remember exact paths.
- You have both `autojump` and `zoxide` configured — they do the same thing. `zoxide` is faster and more actively maintained. Remove the autojump source line and fully commit to zoxide.

---


## fzf

General-purpose fuzzy finder. The engine behind your `vf` function and the `zi` picker in zoxide.

**Standalone usage:**

| Command | Behavior |
|---------|----------|
| `fzf` | Fuzzy pick from stdin |
| `fzf --preview 'cat {}'` | Pick with file preview |
| `vim $(fzf)` | Open fuzzy-picked file in vim |
| `kill -9 $(ps aux \| fzf \| awk '{print $2}')` | Fuzzy kill a process |

**Shell key bindings (add `fzf` to oh-my-zsh plugins or source manually):**

| Key | Action |
|-----|--------|
| `Ctrl+r` | Fuzzy search shell history |
| `Ctrl+t` | Fuzzy insert file path at cursor |
| `Alt+c` | Fuzzy `cd` into a directory |

**Useful flags:**
- `--multi` (`-m`): select multiple items with Tab
- `--preview`: show a preview pane
- `--height 40%`: use partial screen instead of fullscreen

**Active configuration:**
```zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
```

`FZF_DEFAULT_COMMAND` uses `rg --files` so all file listing respects `.gitignore` and includes hidden files. `FZF_DEFAULT_OPTS` makes fzf always open in a compact reverse-layout popup.

**Active shell key bindings (from `fzf` oh-my-zsh plugin):**

| Key | Action |
|-----|--------|
| `Ctrl+r` | Fuzzy search shell history |
| `Ctrl+t` | Fuzzy insert a file path at cursor (uses rg) |
| `Alt+c` | Fuzzy `cd` into a subdirectory |

For content search, use `vf` or `rgf` — see "Tools Working Together".

---

## ripgrep (`rg`)

Fast regex search across files. Respects `.gitignore`, skips binary files, and searches hidden files when told to.

**Core usage:**

| Command | Behavior |
|---------|----------|
| `rg pattern` | Search current dir recursively |
| `rg pattern src/` | Limit to a directory |
| `rg -t go pattern` | Only `.go` files |
| `rg -l pattern` | List matching files only |
| `rg -n pattern` | Show line numbers |
| `rg -i pattern` | Case-insensitive |
| `rg -w pattern` | Whole word match |
| `rg --hidden pattern` | Include hidden files |
| `rg -A 3 -B 3 pattern` | 3 lines context around each match |
| `rg -g '*.go' pattern` | Glob file filter |

**You use it in `vf()`:**
```zsh
vf() {
  local file
  file=$(rg --line-number --no-heading --color=always "$1" | fzf --ansi | cut -d: -f1,2)
  if [ -n "$file" ]; then
    vim +"${file#*:}" "${file%%:*}"
  fi
}
```
This is a great pattern: search → pick → open at exact line.

**Active configuration:**
```zsh
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
```

`~/.ripgreprc` is set as the default config file. Create it if it doesn't exist yet:
```
# ~/.ripgreprc
--smart-case
--hidden
--glob=!.git
```
Any flags in this file apply to every `rg` invocation automatically.

---

## fd

Modern `find` replacement. Faster, friendlier syntax, respects `.gitignore`.

**Core usage:**

| Command | Behavior |
|---------|----------|
| `fd pattern` | Find files matching pattern |
| `fd -e go` | Find by extension |
| `fd -t d name` | Find directories only |
| `fd -H pattern` | Include hidden files |
| `fd --exec cmd` | Run command on each result |
| `fd -x rg pattern` | Search inside all found files |

**Suggestions:**
- Keep `fd` for standalone file name searches only — do not wire it into fzf. Since your fzf workflow is content-based (via rg), `fd` and fzf serve separate purposes and should not overlap:
  ```zsh
  fd -e go          # find all Go files by name
  fd Makefile       # locate a specific file by name
  fd -t d src       # find directories named "src"
  ```
- Use `fd --exec` to act on results in bulk, e.g. format all Go files:
  ```zsh
  fd -e go --exec gofmt -w {}
  ```

---

## eza

Modern `ls` replacement with color, icons, Git status, and tree view.

**Core usage:**

| Command | Behavior |
|---------|----------|
| `eza` | Basic listing (colorized) |
| `eza -l` | Long format |
| `eza -la` | Long format including hidden |
| `eza --git` | Show Git status per file |
| `eza -T` | Tree view |
| `eza -T -L 2` | Tree, max 2 levels deep |
| `eza --sort=modified` | Sort by modification time |

**Active aliases:**

| Alias | Command | Behavior |
|-------|---------|----------|
| `ls` | `eza` | Colorized listing |
| `ll` | `eza -lah --git` | Long format, hidden files, Git status per file |
| `lt` | `eza -T -L 2` | Tree view, 2 levels deep |

---

## bat

`cat` with syntax highlighting, line numbers, Git diff markers, and pager integration.

**Core usage:**

| Command | Behavior |
|---------|----------|
| `bat file.go` | View with syntax highlighting |
| `bat -n file` | Show line numbers only (no other decoration) |
| `bat -A file` | Show non-printable characters |
| `bat --diff file` | Show only changed lines (Git diff style) |
| `bat -r 10:30 file` | Show lines 10–30 |

**Active configuration:**
```zsh
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_THEME="OneHalfDark"
```

`man` pages now render with syntax highlighting via bat. `BAT_THEME` matches the One Dark editor theme used in Cursor.

---

## tldr

Simplified man pages with practical examples. Much faster than reading full man pages.

**Core usage:**

| Command | Behavior |
|---------|----------|
| `tldr rg` | Quick reference for ripgrep |
| `tldr fd` | Quick reference for fd |
| `tldr git` | Common git usage examples |
| `tldr --update` | Update the local cache |

**Suggestions:**
- When you forget a flag for any tool in this list, reach for `tldr <tool>` before searching the web. It covers all the tools here.

---

## tmux

Terminal multiplexer — multiple windows/panes in one terminal session, sessions survive disconnects.

**Core concepts:**

| Command | Behavior |
|---------|----------|
| `tmux` | Start new session |
| `tmux new -s name` | Named session |
| `tmux ls` | List sessions |
| `tmux attach -t name` | Reattach to session |
| `Prefix + c` | New window (default prefix: `Ctrl+b`) |
| `Prefix + %` | Vertical split |
| `Prefix + "` | Horizontal split |
| `Prefix + hjkl` | Navigate panes (with vim keys plugin) |
| `Prefix + d` | Detach (session keeps running) |
| `Prefix + [` | Scroll mode (then `Ctrl+u`/`Ctrl+d`) |

**Note:** You already have Kitty's native splits (`cmd+w/e/a/d`) for quick splits within a single machine session. tmux is most valuable for remote SSH sessions and persistent long-running work sessions.

**Suggestions:**
- Create `~/.tmux.conf` with vim-style navigation and 256 color:
  ```
  set -g default-terminal "xterm-256color"
  setw -g mode-keys vi
  bind h select-pane -L
  bind j select-pane -D
  bind k select-pane -U
  bind l select-pane -R
  ```

---

## Tools Working Together

### fzf + ripgrep — Fuzzy content search (`vf`)

You already have this wired up:
```zsh
vf() {
  file=$(rg --line-number --no-heading --color=always "$1" | fzf --ansi | cut -d: -f1,2)
  [ -n "$file" ] && vim +"${file#*:}" "${file%%:*}"
}
```
Usage: `vf "func main"` — search all files for the pattern, pick result interactively, open vim at that exact line.

### fzf + bat — File preview (`fp`)

**Active alias:**
```zsh
alias fp='fzf --preview "bat --color=always --style=numbers {}"'
```
`fp` — fuzzy-pick any file with a live bat syntax-highlighted preview pane. Combine with vim: `vim $(fp)`.

### fzf + rg — Content search (`vf` and `rgf`)

Both functions search file contents with rg, then let you fuzzy-pick a result and open vim at the exact line.

**`vf` (active):**
```zsh
vf() {
  local file
  file=$(rg --line-number --no-heading --color=always "$1" | fzf --ansi | cut -d: -f1,2)
  if [ -n "$file" ]; then
    vim +"${file#*:}" "${file%%:*}"
  fi
}
```
Usage: `vf "func main"` — search → pick → open at line.

**`rgf` (active):**
```zsh
rgf() {
  rg --line-number --no-heading --color=always "${1:-.}" \
    | fzf --ansi \
          --delimiter : \
          --preview 'bat --color=always --highlight-line {2} {1}' \
          --preview-window 'right:60%:+{2}-5'
}
```
Usage: `rgf "error"` — same as `vf` but with a bat syntax-highlighted preview pane centered on the matched line. Stronger than `vf` for exploration.

### zoxide + eza — Navigate and immediately see contents

**Active:**
```zsh
zl() { z "$@" && eza -lah --git; }
```
`zl dotfiles` → jump to the dotfiles dir and immediately show a rich listing with Git status.

### rg + fzf + bat — Full interactive code search with preview

```zsh
rgf() {
  rg --line-number --no-heading --color=always "${1:-.}" \
    | fzf --ansi \
          --delimiter : \
          --preview 'bat --color=always --highlight-line {2} {1}' \
          --preview-window 'right:60%:+{2}-5'
}
```
`rgf "error"` → fuzzy-pick any match with a syntax-highlighted preview centered on the matching line. This is a more powerful version of your existing `vf`.

### bat + man — Readable man pages

```zsh
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```
`man rg` now renders with syntax highlighting instead of the default monochrome pager.
