# AGENTS.md

This repo is an index, not an installer. It lists how to set up a new Mac for development, and scripts to run on it, with one folder per install type:

| Folder | List | One line per entry |
| --- | --- | --- |
| `native/` | `native.yaml` | `name: command` to run in bash |
| `homebrew/` | `Brewfile` | `brew "name"` for a formula, `cask "name"` for an app |
| `download/` | `download.yaml` | `name: URL` to download from and install by hand |
| `config/` | `config.yaml` | `file: destination`, where `file` is a file directly in `config/` or a GitHub URL |
| `node/` | `node.yaml` | `name: package` to install with `npm install -g` |
| `python/` | `python.yaml` | `name: package` to install with `uv tool install` |
| `setup/` | `setup.yaml` | `name: command` to run in bash after installing, named after what it sets up |
| `scripts/` | `scripts.yaml` | `name: command` to run inside `scripts/`, for a script saved directly in it, in any language |

A `# comment` on or above an entry is its note. The comment at the top of each list explains the format and isn't an entry.

## Answering questions

Treat every question about setting up a Mac, or doing a task on it, as a lookup in these lists, even a generic one: what to install first, how to install or manage a tool, what to run after installing it, where a config goes, which script does a task.

1. Read every list in full. They're short.
2. Match the question against names, values and comments. A question about a language can match its version manager.
3. Answer with what's recorded, quote commands verbatim, and name the list each answer came from:
   - **What first, or in what order**: `native` first (it bootstraps the rest), then `homebrew`, `download`, `config`, `node` and `python` (npm and uv come from `homebrew` and read settings that `config` copies), and `setup` last (its commands expect the rest in place). Within a list, top to bottom. Leave out `scripts`: each runs when it's needed, not as a setup step.
   - **How to install X**: the `native` command, the `homebrew` line as `brew install name` or `brew install --cask name`, the `download` URL, the `node` line as `npm install -g package`, or the `python` line as `uv tool install package`. Add any `config` file and its destination, then any `setup` command for X.
   - **A `config` file that is a GitHub URL**: for a file (`.../blob/<ref>/<path>`), download `https://raw.githubusercontent.com/<owner>/<repo>/<ref>/<path>` to the destination. For a directory (`.../tree/<ref>/<path>`), shallow-clone the repo at `<ref>` into a temporary folder and copy `<path>` to the destination. For a whole repo (`https://github.com/<owner>/<repo>`), `git clone` it to the destination, so `git pull` updates it. For a private repo, copy a file out of a clone too, since the raw download needs a token.
   - **A script for a task, or how to run one**: the matching `scripts` entry's command, and what its note says it's for. The command runs inside `scripts/`, so `cd` into it first.
4. The index is opinionated, and its choice is the answer. Don't swap in another tool or method from general knowledge.
5. When nothing matches, say the index doesn't cover it. You can then give general advice labeled as not from the index, and offer to add an entry.

Run commands or copy files only when the user asks. Back up an existing destination file or directory before you overwrite it. `brew bundle --file=homebrew/Brewfile` installs the whole Brewfile.

## Adding entries

- Append one line to the right list. Put a note in a trailing `# comment`.
- For a config, save the file directly in `config/`, with no subfolder (for example `config/gitconfig`), then append `gitconfig: ~/.gitconfig` to `config/config.yaml`. If the file's name is generic, such as `config.toml`, name it after its tool instead: `codex.toml: ~/.codex/config.toml`.
- For a config kept on GitHub, save no copy. Append its GitHub URL in place of the path, for example `https://github.com/<owner>/dotfiles/tree/main/nvim: ~/.config/nvim`. A file's URL has `/blob/<ref>/<path>`, a directory's has `/tree/<ref>/<path>`, and a whole repo's is `https://github.com/<owner>/<repo>`.
- For a script in any language, save it directly in `scripts/`, with no subfolder (for example `scripts/flush-dns.sh`), then append `flush-dns: bash flush-dns.sh # Clears the DNS cache` to `scripts/scripts.yaml`, with what it's for in the comment. The command runs inside `scripts/`, so it names the script by its file name, the way `config.yaml` names a file in `config/`. Start it with the interpreter, such as `bash`, `uv run` or `osascript`, so the script needs no execute bit, and write an argument to fill in as `<arg>`.
- A Python script starts with an inline `# /// script` block, so `uv run` gives it an environment of its own. Inside `scripts/`, `uv init --script <file>.py` starts a script with the block, and `uv add --script <file>.py <package>` adds a package it needs. Never install packages with pip.
- In YAML, a value that spans lines, starts with a quote, or contains `: ` or ` #` goes in a `|` block. A value that starts with `@`, such as a scoped npm package, goes in double quotes.
- For a new install type, create `<type>/<type>.yaml` with `name: value` lines and add a row to the table above.
- Keep secrets out: no tokens, keys or `.env` files. Use a placeholder such as `<your-email>` and note it.
- Check the lists the way CI does (`.github/workflows/check.yml`). It lints every `.yaml` and `.yml` file, including configs saved under `config/`, with the rules in `.yamllint.yml`:
  `pipx run --spec yamllint==1.38.0 yamllint --strict . && ruby -c homebrew/Brewfile`
