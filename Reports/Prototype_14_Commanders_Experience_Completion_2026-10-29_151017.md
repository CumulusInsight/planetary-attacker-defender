# Prototype 14 - The First Watch: implementation and verification

Completed 2026-10-29T15:10:17-07:00. Ready for owner visual/gameplay review. No commit, tag, push, merge, reset, stash, discard or branch switch was performed. The default startup was not changed.

## What is playable

A standalone command watch at Orbital Data Center 01, operated by the fictional new company Meridian Orbital. The lieutenant meets three crew members, commissions one security improvement, handles a developing vendor-access incident through operational controls, restores service and files a performance report. There are no mandatory multiple-choice questions, answer rounds or quiz-based promotions.

Implemented:
- A layered native 2.5D station, clickable operations/identity/network modules, lit upgrade instrumentation, service craft, subtle station movement and a procedural blue Earth limb with atmosphere/cloud detail.
- The original `images/space.jpg` remains unchanged as a subdued deep-space background. No flattened dashboard is used.
- Mara Voss (operations), Imani Rao (security) and Eli Chen (junior watch officer), with differing priorities, short follow-up conversations and a private crew briefing decision.
- One upgrade allocation: Identity Security or Network Monitoring. Both are viable; the selected module lights up after commissioning.
- Delegate commissioning to Mara or handle the baseline personally. Delegation develops crew responsibility; personal commissioning is faster but requires inspecting both relevant modules.
- A leave-related social contact on Lumen raises uncertainty about unusual interest in watch coverage. It does not establish hostile intent. No entertainment-world location or relationship simulator was built.
- A staged security situation with actual local scenario state: suspicious attempts, possible unauthorized vendor login, credential replacement, independent session revocation, route isolation/restoration and service verification.
- A chronological P14 watch journal, five event-derived performance measures and a comparison against fourteen clearly labeled simulated competitor profiles.
- A gated, optional Martian War Room adversary debrief after the watch; its objective is to learn maintenance coverage and probe a perceived legacy-access opportunity. The lieutenant does not see that plan before deciding.
- P14-only pause/resume, Escape dismissal and explicit watch restart. Closing the introduction cannot strand the player; the left control becomes Take command until the watch begins.

The other fourteen installations are standings fixtures, not fully simulated stations. Lieutenant means command of one installation; Commander and Fleet Commander describe future oversight of five and fifteen. Senior posts remain unfilled; no promotion engine is implemented.

## Exact launch instructions

1. Open the existing project in Godot 4.7.2 Mono.
2. Open `res://scene/prototype14_commanders_experience.tscn` and press **F6** (Run Current Scene).
3. Click **Take command**. Click crew cards and station modules; the lower-left objective supplies the next operational goal.

Or run from the repository in PowerShell:
```powershell
& 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe' --path . res://scene/prototype14_commanders_experience.tscn
```

**F5 still launches Prototype 13**, `res://scene/prototype13_command.tscn`. Stop the separate watch with F8 before running that default. Accepted Prototype 12 remains independently runnable at `res://scene/learning_retrofit_command.tscn`. No old toolbar, console or accepted gameplay screen was redesigned.

Suggested first watch:
1. Meet Mara, Imani and Eli; use Hear more and decide whether to retain the messages/brief the watch.
2. Commission an upgrade and choose Delegate or Handle personally. During the job, inspect station modules and run the power/cooling baseline if desired.
3. When unusual activity appears, inspect the indicated module. Identity Security reveals the account sooner; Network Monitoring reveals the service path sooner.
4. Audit the vendor account if necessary and retire its factory credential. If an unauthorized session was already accepted, revoke it separately.
5. Network isolation can buy time, but delays vendor maintenance and does not repair identity policy. Restore the route once ready.
6. In Operations, verify service restoration, then file the watch report. Compare standings and optionally inspect the adversary debrief.

## Architecture and isolation

`command_experience.gd` owns only the new presentation and input routing. `command_session.gd` is an independent RefCounted scenario state machine/event list, with no inheritance from the accepted command evaluators. `station_view.gd` and `earth_limb.gdshader` are presentation only. Crew/operations/debrief widgets are combined in the small scene controller rather than introducing a separate framework for each panel.

P14 does not instantiate a hidden P12/P13 simulation, call their grading/launch routines, write their registry, clear persistent arrivals, modify their mission scores or change their clocks. Native module interactions operate on the new local vendor-account and maintenance-route state. Its performance is a separate demonstration rating.

The new scenario JSON contains the three fictional crew members, one canonical attack reference and fourteen fixed competitor profiles. It does not add canonical data centers, questions or attack-defense mappings.

## Security evidence and educational content

Canonical attack ID 53 is read from the existing ID-safe rich layer. The full existing Report display label is **Default credential exploitation**, and that exact full label is used in incident views and its optional lesson. The short authoritative catalog label DEF PASS was not copied into the incident UI or changed in the source catalog.

Every evidence panel is labeled **SIMULATED EXERCISE EVIDENCE**. The account and service-path observations are authored P14 exercise facts, not fabricated live telemetry or imported P12 arrival data. Physical arrival is not treated as a successful login. A simulated accepted login sets `unauthorized`; data compromise is never inferred from that fact, and `compromise_confirmed` remains false in this exercise.

Optional definitions/examples come from the existing rich attack record. No expanded learning text, source database, catalog ID, original mapping or editorial approval flag was edited or promoted.

Operational consequences:
- Retiring the factory credential stops subsequent default-credential sign-ins, but does not revoke an existing session.
- Isolating the maintenance route prevents new access through that path, while delaying vendor work. Customer service stays available in this small scenario.
- Reopening an unrepaired route can admit an unauthorized session; the situation remains recoverable through rotation, revocation and verification.
- Verification is blocked until the route is available and any established unauthorized session is revoked.
- No real network configuration, SIEM, AWS environment, exploit execution, data exfiltration, damage model or new physical combat engine was implemented.

## Timing and measured play sequence

The new local watch clock advances by Godot delta while running. Explicit P14 Pause holds jobs and environment animation; it does not change accepted Learning/Active Challenge semantics. UI navigation does not reset the watch or its jobs.

Jobs: delegated commissioning 50 seconds; personal commissioning 35 seconds plus module inspections; power/cooling baseline 18 seconds; account audit 22 seconds; path trace 16 seconds; credential replacement 18 seconds; service verification 25 seconds.

The single developing incident begins after an upgrade is operational, at least two crew contacts and 90 watch seconds. In the authored exercise, Identity Security supplies earlier account visibility and slows acceptance of the default credential (100 seconds after suspicion instead of 65); Network Monitoring supplies the service path immediately. These are explicit demonstration timing rules, not claims about real-world attack probabilities or universal defense effectiveness.

Normal-clock scripted UI walkthrough:
- 42 checks passed in **297.614 wall seconds** (4 minutes 57.614 seconds).
- Watch elapsed at handover: **293.224 seconds** (about 4 minutes 53 seconds).
- Used actual timers, native viewport input, crew/standings/journal inspection pauses and the operational response. No direct model-clock advancement was used in that run.
- Recorded command rating: **78/100**. No unauthorized sign-in was accepted before the credential repair.

This supports an approximately five-minute paced first watch. It is not a forced minimum: fast readers can finish sooner, while exploration can take longer. Enjoyment and pacing still need owner assessment. The accelerated regression harness advances the local model clock to cover both branches quickly; its simulated elapsed values are not presented as measured human play time.

The run was scripted through a rendered Godot viewport. No manual native-desktop playthrough is claimed.

## Performance model

Each metric is clamped to 0-100. The command rating is the rounded arithmetic mean of five metrics; competitors use fixed disclosed fixture ratings, with center ID as a deterministic tie-breaker.

| Metric | Initial | Main event changes |
| --- | ---: | --- |
| Operational readiness | 76 | Commission +6; baseline +6; first verification +4; unauthorized login -3 |
| Security effectiveness | 50 | Credential retirement +22; session revocation +10; first verification +8; unauthorized login -12 |
| Infrastructure development | 20 | Commissioned upgrade +45 |
| Resource stewardship | 80 | Upgrade allocation -4; each maintenance isolation -3 |
| Leadership & personnel | 50 | First conversation +2 per crew; follow-up +1 per crew; private briefing +7; delegation +10 or personal commissioning +5 |

Repeated conversations, duplicate commissioning, repeated revocation and repeated service verification cannot farm positive performance. No quiz-answer count is used. The successful normal-clock result was readiness 92, security 80, infrastructure 65, stewardship 76 and leadership 76. Delayed recovery is also playable and records its own service/security tradeoffs, rather than ending the game immediately.

## Exact added files

No pre-existing source/configuration file was modified by Prototype 14. These 14 implementation/test files were added:

- `scene/prototype14_commanders_experience.tscn`
- `data/p14/first_watch.json`
- `script/p14/command_experience.gd`
- `script/p14/command_experience.gd.uid`
- `script/p14/command_session.gd`
- `script/p14/command_session.gd.uid`
- `script/p14/earth_limb.gdshader`
- `script/p14/earth_limb.gdshader.uid`
- `script/p14/station_view.gd`
- `script/p14/station_view.gd.uid`
- `tests/prototype14_command_session_test.gd`
- `tests/prototype14_command_session_test.gd.uid`
- `tests/prototype14_command_ui_test.gd`
- `tests/prototype14_command_ui_test.gd.uid`

Documentation additions: the prior approved Phase A plan and this completion report. Godot-generated UID sidecars are included in the above inventory. No external executables, dependencies or paid artwork were added.

## Verification results

Final results: **51/51 unique verification jobs have passing results**. New focused suites: **30 session assertions**, **69 rendered UI assertions**, plus the separate **42-check normal-clock run**. Editor/import, default P13 startup and standalone P14 startup passed.

**Exception retained:** the first default-window Prototype 10 Stage 1 attempt failed three legacy hover/click assertions. The unchanged 71-assertion suite passed when rerun with `--position 0,500`. Remaining rendered jobs used that window placement to avoid desktop-pointer interference. No legacy gameplay code or test assertion was altered. This is a test-environment sensitivity, not a hidden test omission; the initial failure and successful retry are both retained. Its precise native-input cause was not established or repaired in this assignment.

Evidence root: `C:\Users\azwam\Projects\Backups\P14_Phase_A_2026-10-29_120305`.
- Full per-job commands/results: `regression_checks/results.json`.
- Initial stopped run: `regression_checks/results_initial.json`.
- Failure/retry: `prototype10_stage1.log` and `prototype10_stage1_retry.log` in that checks folder.
- Original/resumed sequential runners: `run_regressions.py`, `resume_regressions.py`.
- Normal-clock result: `implementation_checks/p14_realtime.log`.
- Actual watch event transcripts: `evidence/realtime/watch.json` and `evidence/final/p14_success_watch.json`, `p14_recovery_watch.json`.

| Verification job | Final result |
| --- | --- |
| catalog | PASS |
| editorial_validation | PASS |
| prototype3 | PASS |
| prototype4 | PASS |
| prototype5 | PASS |
| prototype6 | PASS |
| prototype7 | PASS |
| prototype8 | PASS |
| prototype9 | PASS |
| prototype9_corrections | PASS |
| prototype9_cyber | PASS |
| prototype9_decision | PASS |
| prototype10_stage1 | PASS after unchanged 71-assertion window-placement retry |
| prototype10_stage2 | PASS |
| prototype10_stage3 | PASS |
| prototype10_stage4 | PASS |
| prototype11 | PASS |
| prototype11_refinements | PASS |
| prototype11_multicenter | PASS |
| prototype11_continuity | PASS |
| prototype11_manual_sort | PASS |
| prototype11_ar_effects | PASS |
| prototype12 | PASS |
| prototype12_persistence | PASS |
| prototype12_six_centers | PASS |
| prototype12_correct_only | PASS |
| prototype12_live_status | PASS |
| learning_core | PASS |
| learning_ui | PASS |
| learning_partial | PASS |
| final_core | PASS |
| final_ui | PASS |
| import | PASS |
| main_startup | PASS |
| prototype12_six_legacy_startup | PASS |
| prototype12_legacy_startup | PASS |
| prototype11_startup | PASS |
| prototype10_startup | PASS |
| standalone_startup | PASS |
| prototype12_checkpoint_startup | PASS |
| ui_refinements | PASS |
| mode_transfer | PASS |
| final_refinements | PASS |
| internal_arrival | PASS |
| unopposed_arrival | PASS |
| unopposed_arrival_ui | PASS |
| prototype13_console | PASS |
| prototype14_session | PASS |
| prototype14_ui | PASS |
| prototype14_startup | PASS |
| diff_check | PASS |

Reproduce focused tests:
```powershell
& 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe' --headless --path . --script res://tests/prototype14_command_session_test.gd
& 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe' --path . --position 0,500 --script res://tests/prototype14_command_ui_test.gd
```
For the separate paced walkthrough, append `-- --p14-real-time` to the rendered UI test command. The fast test covers successful identity/delegation and delayed network/personal recovery, keyboard Space/Escape, pause, resizing, restart and no early adversary-plan disclosure.

## Screenshots and visual inspection

Final gallery: `C:\Users\azwam\Projects\Backups\P14_Phase_A_2026-10-29_120305\evidence\final` (17 PNGs). Normal-clock captures/transcript are preserved separately under `evidence/realtime`.

Representative files:
- `arrival.png`, `crew.png`: first command and the leave-related interaction.
- `identity_upgrade.png`, `network_upgrade.png`: both useful improvements visibly online.
- `identity_incident.png`, `network_evidence.png`, `unauthorized_session.png`: full attack name, actual exercise state and operational controls.
- `debrief.png`, `recovered_debrief.png`, `company.png`, `adversary_debrief.png`: outcomes, competition and gated Martian perspective.
- `station_1280x720.png`, `station_1600x900.png`, `station_1920x1080.png`.
- `debrief_1280x720.png`, `debrief_1600x900.png`, `debrief_1920x1080.png`.

Screenshots at all three resolutions were visually inspected for clipping, contrast, overlap and readability. The new scene uniformly scales its 1600 x 900 composition with letterboxing when necessary; module hit regions move with the station illustration. Long optional lessons/journal/results use the contextual scroll area, not smaller text or a horizontal scrollbar. A new panel opens at its title instead of inheriting another panel's scroll position.

The station is stylized native geometry, not sophisticated 3D artwork or a photorealistic asset. Earth is a procedural illustration, not a geographically accurate texture. This is not claimed to be cinematic. Original artwork and the P13 station schematic remain unchanged.

## Backup and preservation audit

Pre-edit ZIP: `C:\Users\azwam\Projects\Backups\P14_Phase_A_2026-10-29_120305\Orbital_Defense_Command_Pre_Prototype14.zip`.
- 347 files; 5,944,111 bytes.
- SHA-256: `fef11699f0c764073e4376f79fe7e82f35f198e357e862fa92a528bfbbf50408`.
- CRC/inventory and individual archived/source SHA-256 comparisons passed before editing. Archive checksum was rechecked after implementation.
- Manifest: `C:\Users\azwam\Projects\Backups\P14_Phase_A_2026-10-29_120305\backup_manifest.json`.
- All **347 pre-existing intended project files remain byte-identical** to that pre-edit snapshot, including project.godot and the uncommitted P13 console implementation/report.
- Git metadata, reproducible Godot/Python caches, temporary logs and the unrelated generated executable were excluded from the ZIP and left on disk. Earlier backups were not overwritten.

## Known limitations and approval boundary

- One authored watch, one incident and one installation. Fourteen competitor profiles are not autonomous installations; there is no fleet command, promotion system, save-game campaign or relationship engine.
- The new operational state is a small isolated exercise, not a connection to live P12 arrivals or a production intrusion-response system. Accepted P13 defense controls remain unchanged.
- Human pacing/fun and the stylized presentation require owner visual/gameplay review. The paced automated run is evidence of continuity and timing, not proof that every player will enjoy it or spend five to ten minutes.
- Legacy hover-test native-input sensitivity remains documented; no unrelated fix was attempted.
- Default startup changes and any Git checkpoint/publication require separate explicit owner authorization.

Final branch: `feature/prototype13-datacenter-defense`. HEAD: `c6646b008657f98b500e019a71b6521f58a76509`. All Prototype 14 additions are unstaged/uncommitted. The pre-existing P13 project.godot modification and untracked source/report/artwork remain intact, as do the unrelated executable and Python-cache directories. No main/collaborator branch or accepted tag was altered. Stop for owner review; no subsequent stage has begun.
