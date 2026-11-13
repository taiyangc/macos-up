# AGENTS.md

This repo is an index, not an installer. It lists how to set up a new Mac for development, with one folder per install type:

| Folder | List | One line per entry |
| --- | --- | --- |
| `native/` | `native.yaml` | `name: command` to run in bash |
| `homebrew/` | `Brewfile` | `brew "name"` for a formula, `cask "name"` for an app |
| `download/` | `download.yaml` | `name: URL` to download from and install by hand |
| `config/` | `config.yaml` | `file: destination`, where `file` is a path under `config/` |

A `# comment` on or above an entry is its note. The comment at the top of each list explains the format and isn't an entry.

## Answering questions

Treat every question about setting up a Mac as a lookup in these lists, even a generic one: what to install first, how to install or manage a tool, where a config goes.

1. Read every list in full. They're short.
2. Match the question against names, values and comments. A question about a language can match its version manager.
3. Answer with what's recorded, quote commands verbatim, and name the list each answer came from:
   - **What first, or in what order**: `native` first (it bootstraps the rest), then `homebrew`, `download`, `config`. Within a list, top to bottom.
   - **How to install X**: the `native` command, the `homebrew` line as `brew install name` or `brew install --cask name`, or the `download` URL. Add any `config` file and its destination.
4. The index is opinionated, and its choice is the answer. Don't swap in another tool or method from general knowledge.
5. When nothing matches, say the index doesn't cover it. You can then give general advice labeled as not from the index, and offer to add an entry.

Run commands or copy files only when the user asks. Back up an existing destination file before you overwrite it. `brew bundle --file=homebrew/Brewfile` installs the whole Brewfile.

## Adding entries

- Append one line to the right list. Put a note in a trailing `# comment`.
- For a config, save the file under `config/` (for example `config/git/gitconfig`), then append `git/gitconfig: ~/.gitconfig` to `config/config.yaml`.
- In YAML, a value that spans lines, starts with a quote, or contains `: ` or ` #` goes in a `|` block.
- For a new install type, create `<type>/<type>.yaml` with `name: value` lines and add a row to the table above.
- Keep secrets out: no tokens, keys or `.env` files. Use a placeholder such as `<your-email>` and note it.
- Check that the lists still parse:
  `ruby -ryaml -e 'ARGV.each { |f| YAML.load_file(f); puts "ok #{f}" }' */*.yaml && ruby -c homebrew/Brewfile`
