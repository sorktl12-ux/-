# Agent instructions (모든 에이전트)

Before any non-trivial task in this workspace:

1. Read `shared/HANDOFF_MAC.md` (Mac twin), `shared/README.md`, `shared/PROFILE.md`, `shared/MEMORY.md`, `shared/CAPABILITIES.md`, `shared/MY_MACHINES.md`.
2. **Runtime preference**: prefer MacBook My Machines (not Cloud virtual desktop). If this session is Cloud VM, point user to `shared/HANDOFF_MAC.md` — do not claim to control Mac Chrome.
3. Check `linked/README.md` / `linked/registry.json` for other Cursor repos.
4. Reuse tools under `google-calendar-sync/`, `iphone-data-organizer/`, `shared/morning-briefing/`, and `linked/*`.
5. After completing user-visible work, append a dated note to `shared/MEMORY.md` (no secrets).
6. Calendar events: current year only unless user says otherwise; use `[학사]` / `[목]` prefixes.
7. Run `./shared/bin/link-repos.sh` if `linked/*` clones are missing (needs `GITHUB_TOKEN` for private repos).
8. Sidebar aliases: english-call, beat-drop, profile-maintain(긱스/루이), beatlink, 아침브리핑(메일).
