# Skills

Reusable [Claude Code skills](https://docs.claude.com/en/docs/claude-code/skills). Each
skill is a folder containing a `SKILL.md` with YAML frontmatter. Claude auto-discovers a
skill from its `description` and loads the body only when relevant.

## Layout

```
skills/
  <skill-name>/
    SKILL.md            # required — frontmatter + instructions
    scripts/            # optional — helper scripts the skill calls
    references/         # optional — extra docs loaded on demand
```

## SKILL.md frontmatter

```yaml
---
name: my-skill              # kebab-case, matches the folder name
description: >-             # one line. WHAT it does + WHEN to trigger. This is all
  Does X. Use when the user asks to Y or mentions Z.   # Claude sees during discovery.
---
```

Guidelines that keep skills reliable:

- **Description is a trigger, not a summary.** Lead with what it does, then the concrete
  situations that should invoke it ("Use when…"). Claude only sees the description until
  the skill fires — make it earn the load.
- **Keep the body tight.** Imperative steps, not prose. Put long reference material in
  `references/` and point to it so it loads only when needed.
- **Prefer scripts for determinism.** If a step is mechanical, ship a script in `scripts/`
  and have the skill call it rather than re-deriving it each time.
- **One skill, one job.** Split broad capabilities into focused skills.

## Reusing a skill in a project

Copy the skill folder into the target project's `.claude/skills/`, or symlink it:

```bash
ln -s ~/projects/personal/ai-setup/skills/my-skill \
      ~/projects/<project>/.claude/skills/my-skill
```

See `_template/` for a starting point — copy it and rename.
