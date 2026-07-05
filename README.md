# ai-setup

Personal, reusable AI configuration — a source of truth for the `CLAUDE.md` template and
Claude Code skills I drop into my projects.

## Contents

```
ai-setup/
├── CLAUDE.md          # reusable CLAUDE.md template for new projects
├── skills/            # reusable Claude Code skills
│   ├── README.md      # how skills are structured + authoring guide
│   └── _template/     # starter skill — copy and rename
└── README.md
```

## Using this in a project

**CLAUDE.md** — copy `CLAUDE.md` into the project root and fill in the `<!-- FILL -->`
sections:

```bash
cp ~/projects/personal/ai-setup/CLAUDE.md ~/projects/<project>/CLAUDE.md
```

**Skills** — copy or symlink a skill folder into the project's `.claude/skills/`:

```bash
mkdir -p ~/projects/<project>/.claude/skills
ln -s ~/projects/personal/ai-setup/skills/<skill> \
      ~/projects/<project>/.claude/skills/<skill>
```

Symlinking keeps this repo as the single source of truth — edit once, every linked
project picks it up. Copy instead when a project needs to diverge.

Alternatively, add this repo as a git submodule to version-pin what a project uses:

```bash
git submodule add <this-repo-url> .ai-setup
```

## Adding a new skill

Copy `skills/_template/` to `skills/<your-skill>/`, rename it, and edit `SKILL.md`.
See `skills/README.md` for authoring guidelines.
