# macos-up

Best developer tooling bootstrap for macOS: lists of what to install on a new Mac and how, one folder per install type. Coding agents answer setup questions from them.

## Add an entry

Append one line to the list for its type:

| Folder | List | Example line |
| --- | --- | --- |
| `native/` | `native.yaml` | `xcode-clt: xcode-select --install` |
| `homebrew/` | `Brewfile` | `brew "git"` or `cask "firefox"` |
| `download/` | `download.yaml` | `xcode: https://developer.apple.com/download/applications/` |
| `config/` | `config.yaml` | `git/gitconfig: ~/.gitconfig`, with the file saved as `config/git/gitconfig` |
| `node/` | `node.yaml` | `pnpm: pnpm`, or `codex: "@openai/codex"`, quoted since it starts with `@` |
| `python/` | `python.yaml` | `ruff: ruff`, installed with `uv tool install ruff` |
| `setup/` | `setup.yaml` | `gh: gh auth login`, to run after `gh` is installed |

- Notes go in `# comments`.
- A command that spans lines, starts with a quote, or contains `: ` or ` #` goes in a YAML `|` block:

  ```yaml
  name: |
    first command
    second command
  ```

- A config kept on GitHub needs no copy under `config/`. Put its GitHub URL in place of the path. A file (`/blob/`) is downloaded, a directory (`/tree/`) is copied, and a whole repo is cloned, so `git pull` updates it:

  ```yaml
  https://github.com/<owner>/dotfiles/blob/main/gitconfig: ~/.gitconfig
  https://github.com/<owner>/dotfiles/tree/main/nvim: ~/.config/nvim
  https://github.com/<owner>/tmux-config: ~/.config/tmux
  ```

- A new install type is a new folder with a `<type>.yaml` of `name: value` lines. Add it to the table in `AGENTS.md`.
- To fill the Brewfile from this Mac, run `brew bundle dump --file=-`. It prints everything you installed with Homebrew, with descriptions.

Or ask your agent, for example: "add jq to homebrew".

## Ask

Open a coding agent (Claude Code, Codex, ...) in this repo and ask things like "What should I install first?" or "What's the best way to install and manage Node?". It answers from the lists and tells you when something isn't covered.

## Use as a skill

To ask from any directory, link the repo into your agent's skills folder. For Claude Code, from the repo root:

```sh
ln -s "$PWD" ~/.claude/skills/macos-up
```

Other agents that read `SKILL.md` work the same way with their own skills folder.
