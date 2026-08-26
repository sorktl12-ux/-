# Agent instructions (모든 에이전트)

Before any non-trivial task in this workspace:

1. Read `shared/README.md`, `shared/PROFILE.md`, `shared/MEMORY.md`, `shared/CAPABILITIES.md`.
2. Check `linked/README.md` / `linked/registry.json` for other Cursor repos.
3. Reuse tools under `google-calendar-sync/`, `iphone-data-organizer/`, `shared/morning-briefing/`, and `linked/*`.
4. After completing user-visible work, append a dated note to `shared/MEMORY.md` (no secrets).
5. Calendar events: current year only unless user says otherwise; use `[학사]` / `[목]` prefixes.
6. Run `./shared/bin/link-repos.sh` if linked clones are missing (`GITHUB_TOKEN` needed for private `beat-drop`).
