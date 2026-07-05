# ai-setup

My personal, reusable AI configuration — a single source of truth for the coding-standards
`CLAUDE.md` and the Claude Code skills I want available in every project.

## Contents

```
ai-setup/
├── CLAUDE.md          # my personal coding standards (merged into ~/.claude/CLAUDE.md)
├── install.sh         # installs CLAUDE.md + skills globally into ~/.claude
├── skills/            # reusable Claude Code skills
│   ├── README.md      # how skills are structured + authoring guide
│   ├── _template/     # starter skill — copy and rename (not installed)
│   └── pr-review/     # review a coworker's PR the way I do
└── README.md
```

## Install (global)

Run the installer once. It wires this repo into your global Claude config so the setup is
active in **every** project:

```bash
./install.sh
```

What it does:

1. **Merges `CLAUDE.md` into `~/.claude/CLAUDE.md`** inside a managed block:

   ```
   <!-- BEGIN ai-setup ... -->
   ...contents of this repo's CLAUDE.md...
   <!-- END ai-setup -->
   ```

   Your existing global content (gstack, RTK, etc.) is left untouched — only the block
   between the markers is refreshed.

2. **Symlinks each skill** in `skills/` into `~/.claude/skills/`, so they're available to
   every project. `_template/` is skipped. A real (non-symlink) directory already present
   in `~/.claude/skills/` is left alone and reported.

The script is **idempotent** — re-run it after editing `CLAUDE.md` or adding a skill and it
updates the managed block and re-links skills without touching anything else. Because
skills are symlinked, edits in this repo take effect immediately with no re-run needed.

Install to a different location with `CLAUDE_HOME=/path ./install.sh`.

## Keeping it up to date

```bash
git pull
./install.sh   # only needed if CLAUDE.md changed or you added a new skill
```

## Adding a new skill

Copy `skills/_template/` to `skills/<your-skill>/`, rename it, and edit `SKILL.md`, then
re-run `./install.sh` to link it. See `skills/README.md` for authoring guidelines.

## Per-project use (optional)

The installer sets everything up globally. If a single project needs one of these files
committed to it (e.g. to share with teammates), copy or symlink it in directly:

```bash
cp   ~/projects/personal/ai-setup/CLAUDE.md          ~/projects/<project>/CLAUDE.md
ln -s ~/projects/personal/ai-setup/skills/<skill>    ~/projects/<project>/.claude/skills/<skill>
```
