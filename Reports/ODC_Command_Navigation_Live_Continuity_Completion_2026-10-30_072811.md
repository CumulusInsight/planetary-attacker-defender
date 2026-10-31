# Orbital Defense Command - navigation and live incident continuity

Status: approved Phase B complete; ready for owner gameplay review. No Git publication performed.

## Changes and navigation

Command Desk is now a persistent application host. Starting/resuming Orbital Command retains the same P13 scene and P12 session rather than replacing the desk. First Watch has an independently retained scene and is explicitly labeled TRAINING. Opening or returning from command views does not initialize another mission.

The visible navigation dropdown occupies the previous role-control location:

- Orbital Command: return to the orbital view for the selected center; the existing 6 CENTERS control remains available for the overview.
- DC-01 Tactical Command: the player's assigned center, current authoritative internal arrivals, incident detail and Security Console access.
- DC-02 through DC-06 Tactical Status: observer-only center-specific incident views. Their Tactical Officer tools button is disabled; no career command authority is granted.
- Fleet Command - monitoring: the existing Operations Commander contacts/operations interface, explicitly without fleet appointment or promotion.
- The First Watch - TRAINING: the original DC-01 exercise, subject to the live-mission safety gate.
- Command Desk: return without destroying the active mission.

DC-01's Tactical Officer tools button accesses the existing DC-01 operational intelligence and confirmed command path. Those older operational scenarios remain distinct from learning arrivals; the UI says so rather than claiming that an old command evaluates a current DNS arrival. Original Threat, Evidence, History, Mission, War Room and learning controls remain available. Legacy controllers still have their original two-entry role adapter internally; their hardcoded 0/1 assumptions were not changed. The canonical three-center selector and six-center learning selector update the new center context correctly. DC-04 through DC-06 are not incorrectly passed to the three-center canonical actor model. No DC-07 through DC-15 operations were created.

## Live incident data and lifecycle

`live_incident_projection.gd` queries the SAME `session.internal_for_center(center)` registry used by the persistent warnings. It owns no incident store. It joins a source row to `all_results[learning_id]` only when physical, learning and center identities match. Reused contact slots cannot supply a newer question's grade to an older arrival.

The projection presents the full educational attack name, canonical ID/original name, stable physical identity, target center, learning identity, mission epoch, recorded answer outcome, physical outcome, cause, simulation time, source and compromise-confirmation flag. Definitions are separated from recorded evidence. No fabricated telemetry, real arrival dates, unauthorized sessions or compromise claims were added. Catalog IDs, mappings and editorial approval status remain unchanged.

Session-only navigation metadata adds a run/mission/generation namespace without drawing from the question or evasion RNG. Ordinary navigation preserves the exact live instance, clocks, queues, physical targets and records. Round progression retains arrivals. They remain unresolved because no resolution capability exists.

- HIT creates no arrival. A prior unrelated arrival is not silently cleared by another successful engagement.
- EVADED creates the existing EVADED_INTERCEPTION first-arrival record.
- Incorrect combat evaluation creates the existing UNOPPOSED_ARRIVAL without a missile.
- Unanswered, pending/authorized, airborne and noncombat review states create no arrival.
- Learning restart keeps its original semantics: clears learning arrivals and increments generation; the projection epoch changes. The older official mission ledger retains its existing behavior.
- NEW MISSION at Command Desk requires confirmation if a live mission exists, replaces that live instance, creates a new mission sequence and clears old incident selection. It preserves separate First Watch progress.
- Closing the application still discards session state. No disk persistence or previous-mission archive was introduced.

## DNS reproduction and actual callback

The recorded seed **2949072717** reproduces first-round DC-01 question `R01/RETROFIT-V12-033`, contact 2, canonical ID **33**: full display name **DNS cache poisoning**, original catalog name **DNS POISON**. ID 82 remains the separate DNS infrastructure abuse entry.

The rendered test selected the actual valid defense, submitted through the existing Report button, created a real claimed projectile, and pressed the existing Martian EVADE ALL control. It used a controlled test-only evasion stream seed with a successful Bernoulli roll **0.20227184891701**; the unchanged success threshold is 0.50. This is a deterministic reproduction of the mechanism, not recovery of the owner's unsaved historical roll.

Before 36 seconds of flight, the arrival registry remained empty. At the real pursuit passage callback, the original evaluator recorded:

- Physical identity: `DC-01/C-002/P01`.
- Answer: correct.
- Projectile outcome: `EVADED`.
- Arrival cause: `EVADED_INTERCEPTION`.
- Internal state: `ARRIVED_INTERNAL`.
- Compromise: not confirmed.

Both Tactical Command and Security Console displayed that same identity and full attack name. Revisiting DC-01 retained it; the other five centers did not display it. A separate actual HIT callback created no arrival. The original reported encounter cannot be reconstructed from question-generation metadata alone, and no claim is made that it was recovered.

## Training gate and continuity

During an initialized live mission, training requires Learning Mode, explicitly selected strategic pause, and no queued missiles, airborne flights or remaining effects. Blocked entry explains the reason. If already paused with unfinished effects, the message tells the player to resume until they finish and then pause again. Active Challenge cannot enter training mid-mission. No live pause is toggled automatically.

The host masks live CanvasLayers/input while training is shown; it does not disable authoritative live processors. The live clock remains held by its existing explicit strategic pause. P14 retains its own watch/pause state. Returning leaves the live strategic pause selected until the player resumes it. Command Desk itself does not pause a running mission and visibly identifies it as RUNNING or PAUSED.

First Watch still uses its credential exercise, three ranked crew, upgrades, state-driven checklist, report filing, Lumen narrative and standings. It does not receive fake DNS credential evidence or claim to verify live incidents.

## Exact files changed

Modified existing working-tree files:

1. `script/odc_entry.gd` - persistent host, new/resume mission, safe training gate and view/input masking.
2. `script/prototype13_command.gd` - navigation integration, center context, legacy tool routes and external-view firing guard.
3. `script/orbital_security_console.gd` - parameterized center, identity-safe projection, full attack name/outcome/mission details, preserved default return behavior.
4. `script/p14/command_experience.gd` - explicit training title/subtitle only.
5. `tests/prototype13_security_console_test.gd` - additional configurable-center checks, preserving prior coverage.
6. `tests/prototype14_wrapup_test.gd` - persistent-instance navigation expectation replacing obsolete destructive scene-change expectation.

Added, each with its Godot `.gd.uid` sidecar:

- `script/command_navigation.gd`.
- `script/orbital_command_context.gd`.
- `script/live_incident_projection.gd`.
- `script/orbital_tactical_console.gd`.
- `tests/live_incident_projection_test.gd`.
- `tests/command_navigation_continuity_test.gd`.

Also added this completion report. No changes to `project.godot`, launchers, scenes, original evaluators, missile/evasion scripts, catalogs/editorial files, P14 scenario/session/checklist or artwork.

## Verification results

All **54 sequential validation/regression/import/startup jobs** reached final passing results. This includes catalog/editorial validation; Prototype 3-12 suites; retrofit core/UI/partial submission; mode transfer; internal arrivals from evasion and incorrect answers; P13/P14; and older playable-scene startups. Exact commands/results/logs are preserved in `C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/checks/`.

| Focused suite | Final result |
|---|---|
| Existing P13 Security Console, expanded | 32 checks, zero failures |
| P14 session | 30 checks, zero failures |
| P14 rendered gameplay, both upgrade routes | 70 checks, zero failures |
| P14 wrap-up/checklist/navigation | 38 checks, zero failures |
| Read-only live projection | 19 checks, zero failures |
| Rendered command/incident continuity | 51 checks, zero failures |
| Windows launcher from another working folder | Responsive visible game; normal close |
| Godot import, startup and Git whitespace | Passed |

The continuity suite tests real scene instantiation and native control navigation, submission/projectile callbacks, all six centers, matching names/identities, observer status, legacy tools, center selectors, pause/training/return, masked input, correct HIT exclusion, learning restart and confirmed New Mission. Original scoring and canonical operational events remain unchanged.

An initial unchanged Prototype 10 Stage 1 run failed two hover assertions at window position 1900,900. It passed all 71 checks at 0,500 with no changes to the old code/test. Initial and retry logs are both retained. During implementation, a reserved helper name and a new detail-format placeholder error were corrected within the approved new/wrapper files; final verification logs contain no such errors. No protected gameplay fixes or weakened tests were used.

Screenshots of the new incident views were inspected at 1280x720, 1600x900 and 1920x1080. Titles, target identity and response/return controls fit; longer detail uses a vertical scrollbar. The original orbital interface retains its established 1600x900 reference layout; this task does not redesign its narrower-window toolbar. Testing used automated rendered input and controlled simulation stepping, not a claimed manual real-time playthrough.

## Backup and preservation

ZIP: `C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/ODC_Pre_Live_Continuity.zip`

- Files: 376. Bytes: 6009982.
- SHA-256: `c5a0628752d167b759efcdb6a77a065669b40be447377457c11016de94569f37`.
- CRC and every individual archived/source SHA-256 verified before editing; ZIP SHA-256 reverified after testing.
- Exactly the six approved baseline files changed. All other 370 archived source/assets/data/documents remain byte-identical; none were removed.
- Existing unrelated `new_projectV2/` executable artifacts, Python caches and the owner's untracked report copy remain untouched. Reproducible caches, logs, Git metadata and unrelated generated executables were excluded from the ZIP.

Evidence root: `C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017`

- `backup.json`, `manifest.json`, `source_freeze.json`, `preservation.json`.
- `checks/results.json`, `checks/initial_results.json`, complete logs and retry evidence.
- `launcher_test.json`, `launcher_game.log`.
- `evidence/`: 16 preserved screenshots.

Representative screenshots:

- [DC-01 DNS Tactical Command](C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/evidence/prototype4_continuity_dns_tactical.png)
- [Same DNS incident in Security Console](C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/evidence/prototype4_continuity_dns_security.png)
- [1280x720](C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/evidence/prototype4_continuity_tactical_1280x720.png)
- [1920x1080](C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/evidence/prototype4_continuity_tactical_1920x1080.png)
- [Separate training](C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/evidence/prototype4_continuity_training_badge.png)
- [Fresh mission with no stale arrivals](C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/evidence/prototype4_continuity_new_mission_zero.png)

## Owner launch/review

Double-click `C:/Users/azwam/Projects/planetary-attacker-defender/Launch_Orbital_Defense_Command.bat`. Choose Open / Resume Orbital Command. Use A/R and the existing submission flow. After an authoritative arrival, choose DC-01 Tactical Command in the command dropdown, then OPEN SECURITY CONSOLE. Check the full name, physical identity, outcome and uncertainty. Other centers are observer views.

For training, wait for launches/effects to finish, select Learning Mode and explicitly PAUSE the live mission. Choose The First Watch - TRAINING. Return to Command Desk and resume Orbital Command to continue the same live session; resume its clock explicitly. Use NEW MISSION only when deliberately starting over.

Reproducible rendered DNS test:

```powershell
& 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe' --path 'C:/Users/azwam/Projects/planetary-attacker-defender' --script res://tests/command_navigation_continuity_test.gd -- --odc-learning-seed=2949072717
```

## Limitations and final Git state

Live command/security incident views are read-only. No SIEM, intrusion, remediation, resolution, promotion or disk-save system was added. Legacy operational encounters and learning arrivals remain distinct authoritative models; matching contact slot numbers do not make their evidence interchangeable. Previously running older processes cannot be upgraded/imported in place by this change. Existing processes were not closed; the launcher test closed only its own new instance.

Branch remains `feature/prototype13-datacenter-defense`; HEAD remains `c6646b008657f98b500e019a71b6521f58a76509`. All Git refs match the pre-edit snapshot. Nothing staged; existing uncommitted work remains. No commits, tags, pushes, merges, resets, stashes or cleanup performed. Full final working-tree status is in `C:/Users/azwam/Projects/Backups/ODC_Continuity_2026-10-29_233017/final_git_status.txt`.

Stop here for owner gameplay review. No subsequent prototype begun.
