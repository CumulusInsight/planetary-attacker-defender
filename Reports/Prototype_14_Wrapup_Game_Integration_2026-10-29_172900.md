# Prototype 14 - Wrap-up and game integration

Status: implementation complete; ready for owner visual and gameplay review. Phase B follows the owner's approval of the Phase A plan. No commit or publication performed.

## Implemented

The new native Command Desk is the approved default entry. It offers The First Watch and the existing six-center Orbital Command. The First Watch remains an isolated simulated command exercise; its evidence and score are not P12 live incidents.

The collapsible Watch Officer's Checklist displays eight actual procedures with Pending, In Progress, Verified or Blocked states. Its procedure buttons navigate to existing operational controls and never mark work complete. Completed procedures fit together in the contextual panel; blockers and optional leadership detail remain scrollable. Hovering a procedure supplies its specific prerequisite/detail.

A common handover-blocker function drives report availability, the checklist's handover row, and the next required procedure. The watch report can now be opened before completion to inspect unmet requirements. Recovery explicitly shows PENDING, IN PROGRESS or VERIFIED. Credential rotation does not revoke an existing unauthorized session.

Approved P14-only prerequisite changes: handover now requires core inspection, the actual completed 18-second power/cooling check, and review of available incident evidence. An upgrade detecting activity does not by itself constitute evidence review. Starting a health or verification job does not complete it. Existing job durations and score deltas/formulas remain unchanged, including the health check's existing readiness award. Optional follow-up conversations and private crew briefing remain optional leadership actions.

Personnel now consistently use full rank and full name; duties are displayed separately:

- Chief Petty Officer Mara Voss - Operations.
- Lieutenant Junior Grade Imani Rao - Security.
- Ensign Eli Chen - Junior Watch Officer.

These assignments fit the existing characterization and the player's Lieutenant command role. Crew cards, dialogue, task/journal messages and handover remarks use the approved identities. Existing full attack names, the Lumen uncertainty, fifteen-center company standings and gated adversary debrief are preserved.

## Navigation and launch instructions

1. Double-click `Launch_Orbital_Defense_Command.bat` in the repository root.
2. Choose **The First Watch** and **Take command**. Open the checklist whenever guidance is needed.
3. Meet the three crew, inspect operations/run the check, allocate either useful upgrade and commission it. Delegation or personal commissioning remains playable; personal sign-off requires the existing Identity and Network inspections.
4. Investigate the developing simulated incident. Complete the appropriate account/route work; revoke an established unauthorized session separately. Restore the maintenance route and complete recovery verification.
5. Open Watch report and file the watch. Optional adversary perspective remains locked until completion.
6. **Return to Command Desk** preserves the hosted First Watch instance and temporarily holds only its own clock/animation. Resume restores its prior pause state, selections, jobs, journal and performance.
7. **Orbital Command** opens the untouched P13 scene and its live six-center scenario with a fresh session. Leaving an unfinished watch for that scenario requires confirmation. DC-01's existing Security Console continues to read the P12 internal-arrival registry.

The existing direct `Launch_Prototype_14.bat` remains unchanged for standalone testing. A direct-launch unfinished watch warns before leaving for Command Desk; unlike the hosted route, it cannot be resumed after that exit. Use the new general launcher for resumable entry navigation.

The new batch resolves project files relative to itself, uses the installed Godot 4.7.2 Mono executable and reports missing engine, configuration or entry scene clearly. It was actually launched from Windows' Temp directory: one responsive game window opened with `res://scene/odc_entry.tscn`, and closed normally. The resulting engine log contains no script errors. Separate missing-Godot/project/scene error-path tests all passed.

## Exact changed files

Modified existing working-tree files:

- `project.godot` - startup path to Command Desk only.
- `data/p14/first_watch.json` - structured ranks/duties and consistent crew references.
- `script/p14/command_session.gd` - personnel formatter, evidence-review state, shared handover/recovery blockers and approved prerequisites.
- `script/p14/command_experience.gd` - compact checklist, rank presentation, blocked/verification feedback and return navigation.
- `tests/prototype14_command_session_test.gd` - complete existing scenarios with approved new prerequisites.
- `tests/prototype14_command_ui_test.gd` - complete both existing upgrade routes with readiness check.

Added in Phase B:

- `scene/odc_entry.tscn`.
- `script/odc_entry.gd` and `script/odc_entry.gd.uid`.
- `script/p14/watch_checklist.gd` and `script/p14/watch_checklist.gd.uid`.
- `tests/prototype14_wrapup_test.gd` and `tests/prototype14_wrapup_test.gd.uid`.
- `Launch_Orbital_Defense_Command.bat`.
- This completion report.

The preceding Phase A plan is preserved in `Reports/Prototype_14_Wrapup_Phase_A_2026-10-29.md`.

## Verification

All 52 sequential regression/validation/startup jobs reached passing final results. Logs and exact commands are in the external evidence directory below. Coverage includes catalog/editorial validation, Prototype 3?12 suites, learning-retrofit core/UI/partial submission, firing-mode transfer, internal arrivals from evasion and incorrect answers, P13 Security Console, Godot editor/import, old playable scene startups and the new default startup.

P14-specific final results:

| Suite | Result |
|---|---|
| Command session | 30 checks, zero failures |
| Rendered command UI | 70 checks, zero failures; both upgrade routes through report filing |
| Wrap-up/navigation | 38 checks, zero failures |
| Launcher error paths | 3 passed |
| Actual batch launch from a different folder | Responsive window; normal close |
| Git whitespace check | Passed |

Final affected P14 UI/navigation suites were rerun after compacting the checklist; their final logs are clean. The navigation test covers read-only checklist access, unmet handover requirements, rotation versus revocation, actual job completion, full personnel ranks, suspended/resumed watch identity and pause state, unfinished-exit confirmation, and the real scene transition to P13.

Testing notes: the initial unchanged legacy P3 rendered run failed four orbital-motion assertions. It passed on rerun with the window moved away from the desktop pointer, without modifying legacy code/tests. This is a window-position-sensitive test result, consistent with hover interference. The initial new navigation fixture also logged a Godot subwindow focus error while presenting a confirmation dialog in its off-screen viewport. The fixture now tests the native confirmation under the root Window, and its final run has no engine errors. No gameplay workaround was introduced.

Rendered screenshots were inspected at 1280x720, 1600x900 and 1920x1080. Checklist statuses, rank/name cards and close/return controls are readable; the station remains visible. Longer explanations and optional material use vertical scrolling. UI workflow verification used scripted native control input with accelerated simulation steps; this report does not claim a manual real-time desktop playthrough.

## Backup and preservation

- ZIP: `C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115/Orbital_Defense_Command_Pre_Wrapup.zip`.
- Archived files: 365; bytes: 5984743.
- SHA-256: `12456ee33ddd18f43cc738ba4f40dfa23851405e655389af3451ff009afe0de3`.
- CRC and every archived/source individual SHA-256 verified before editing. Archive checksum reverified after testing.
- Of the 365 original archived files, only the six explicitly listed working-tree files changed; the other 359 remain byte-identical and none are missing. Catalog/editorial files, P12/P13 sources/scenes, assets, previous reports and direct launcher remain unchanged.
- Git metadata, reproducible caches, temporary logs, unrelated generated executables and external archives were excluded from the ZIP. Existing `new_projectV2/` executable artifacts and `tools/__pycache__/` were left intact, not cleaned or incorporated into the implementation.

## Evidence

External evidence directory: `C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115`.

- `backup.json`, `manifest.json`, `preservation.json`, `wrapup_source_freeze.json`.
- `checks/results.json` contains all 52 final job results; `checks/initial_results.json` retains the initial legacy-test failure status.
- `checks/final_prototype14_wrapup.log`, `checks/final_prototype14_command_ui.log`, `checks/final_p14_results.json` contain final affected-suite reruns.
- `launcher_checks/actual_launch.json`, `actual_game.log`, `results.json`.
- `evidence/` preserves 26 rendered screenshots, including the new Command Desk, full ranks, blocked/ready/verified checklist, filed report, both upgrade branches, and three desktop resolutions.

Representative images:

- [Command Desk](C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115/evidence/prototype4_p14_wrapup_desk.png)
- [Blocked checklist](C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115/evidence/prototype4_p14_wrapup_blocked.png)
- [Verified checklist, 1600x900](C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115/evidence/prototype4_p14_wrapup_checklist_1600x900.png)
- [Full rank and duty](C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115/evidence/prototype4_p14_wrapup_rank.png)
- [1280x720](C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115/evidence/prototype4_p14_wrapup_checklist_1280x720.png)
- [1920x1080](C:/Users/azwam/Projects/Backups/P14_Wrapup_2026-10-29_171115/evidence/prototype4_p14_wrapup_checklist_1920x1080.png)

## Limitations and next-prototype recommendations

Integration is navigation only. P14 does not read/write P12 internal-threat records, official mission scores or P13 incident state. No fake incident conversion is implemented. Entering Orbital Command starts a fresh live scenario; an in-session trip back into P14 is intentionally not added. First Watch resume is in-memory within Command Desk, not a disk-save system.

A future separately approved task should first define live-session timing and return/save lifecycle, then design an explicit incident adapter that keeps exercise evidence distinct from authoritative arrivals. No such implementation was started. Owner review should assess the checklist's clarity and whether the readiness/evidence prerequisites feel natural.

## Final Git state

Branch remains `feature/prototype13-datacenter-defense`; HEAD remains `c6646b008657f98b500e019a71b6521f58a76509`. `project.godot` is modified; P13/P14 files and reports remain untracked as before, alongside the new wrap-up additions. Nothing is staged. All prior work is preserved. Main, checkpoint tags and collaborator work were not altered. No commits, tags, pushes, merges, resets, stashes or discards were performed.

Full final status is recorded externally in `final_git_status.txt`.
