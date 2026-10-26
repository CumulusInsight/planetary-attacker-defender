# Prototype 11 — Targeted gameplay refinements

Created: 2026-10-25T16:49:47-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_11_Targeted_Refinements_2026-10-25_164947_01.md`.
Status: implemented and locally verified; awaiting owner review. No checkpoint or publication performed.

## Baseline and exact scope

Branch `feature/prototype11-simplified-cyber-game`; HEAD and accepted P10 tag target remain `ee96eebb88d942d9302a9aa740e1414fb931eba1`. Existing P11 implementation remains uncommitted. Both pre-existing reports are unchanged byte-for-byte:

- `Reports/Prototype_10_Final_Git_Checkpoint_2026-10-25_145510_01.md`
- `Reports/Prototype_11_Simplified_Cyber_Game_2026-10-25_154821_01.md`

A preservation snapshot of the starting uncommitted files was stored outside the repository at `C:\Users\azwam\AppData\Local\Temp\odc_p11_refinement_backup_20261025_163723`. Hash comparison confirms only the four files listed below changed among pre-existing files. The existing main-scene setting, questions/answer keys, loader, wrapper scene and UID files remain unchanged. All P10 scripts/scenes, catalog, public intelligence, hidden truth, command execution, scoring and deadline rules remain unchanged. No taskbar icon or Analyze control was removed, renamed or reordered.

Modified for this assignment:

- `script/learning_session.gd`: per-contact flights, volley snapshot, evaluated-result metrics and simulation elapsed-time origin.
- `script/learning_game.gd`: eight-column Report, stable hover explanation, authentic deadline projection, compact metrics, batch launch, persistent multi-result feedback and off-center learning markers.
- `script/learning_projectile.gd`: independently labeled, visually separated volley trails; existing deterministic hit/miss rule and duration retained.
- `tests/prototype11_test.gd`: only two expectation updates required by the requested behavior: seven columns becomes eight; pending selections may change while the accepted answer snapshot remains immutable. All prior tests otherwise retained.

Added:

- `tests/prototype11_refinements_test.gd` and its Godot `.uid`.
- This new timestamped report. No historical report overwritten.

## 1. Learning metrics

The compact two-line summary appears in the unused upper-left area below the taskbar while the learning workflow is active. It shows Correct Answers, Incorrect Answers, Percentage Correct and explicitly labeled Elapsed Time without covering the central orbit area. No original panels were moved.

`correct = count(results where hit)`; `incorrect = results.size - correct`; `percentage = 0` before any evaluated answers, otherwise `100.0 * correct / results.size`. Display rounds the percentage to whole percent while the model retains the actual calculation. Selections, queued shots and projectiles still in flight contribute nothing. The contact-keyed result dictionary plus generation validation makes repeated impacts/refreshes idempotent.

Elapsed time begins on the first successful Analyze YES: `max(0, operations.session.now - learning_started_at)`. Re-analyzing does not restart the clock. It continues when a learning window closes, uses no wall timer, and freezes with the existing strategic simulation pause. Learning restart clears answers/results/pending volley/flights and resets the elapsed-time origin to the current authoritative clock. It does not reset any P10 clock, record or score.

## 2. Report hover explanations

Each choice uses the existing validated catalog defense name and definition. Up to 23 definition words are shown in a stable footer beneath the table. Hovering another choice updates it; mouse exit or closing/changing the learning window clears it. No hover selection or answer-key test occurs. Missing/blank definitions display `Description unavailable.` The post-impact feedback and Why control remain available unchanged.

The table itself remains intact; the existing footer status is temporarily replaced only while explaining a hovered choice. No tooltip popups or source records are created.

## 3. Report Time column

Column order is Data Center, Contact, Suspected Attack, Time, Option 1–4. The 1600 x 900 Report retains its existing position, Close and Restart controls; widths are 92/82/140/110/250/250/250/250 pixels plus normal gaps. All eight columns fit without horizontal scrolling and choices retain readable 18-pixel defense names.

Time reads existing owners only. Original active contacts use their authoritative movement-derived deadline/expiry model. Operational contacts use the existing operations public view's remaining time; an actual resolved expiry is recognized from its canonical `resolved` event's `details.action == expire`. Positive values display ceiling-rounded `MM:SS`, expired windows show `EXPIRED`, and absent applicable deadlines show `NO DEADLINE`. Opening Report neither initializes nor extends any deadline. Pause behavior remains inherited from those owners.

All five production learning contacts C-010 through C-014 currently have no configured active operational deadline. Their honest display is therefore `NO DEADLINE`. A test-only optional 165-second operational fixture was explicitly escalated through the existing owner and verified at `02:45`, `02:44` and `EXPIRED`. That fixture does not change production data or introduce deadlines.

## 4. Multi-target volleys

A firing choice applies to every selected, unfinished, non-flight learning contact in configured question order. It captures independent contact/defense/generation snapshots and one common `due_at = authoritative_now + delay`. Delays remain exactly 0, 60, 300 and 600 simulation seconds. No real-time shortening, operational command or evaluator change is involved.

One pending volley is allowed at a time; all its projectiles may be in flight together. Fire is disabled/rejected while a volley is pending/in flight. Completed contacts remain ineligible until restart, including contacts answered incorrectly. Report choices can be revised while waiting, but accepted snapshots remain unchanged. Cancel removes the entire pending volley before launch. A stale generation or duplicate impact cannot produce another result.

The existing compact Decide window and four firing choices remain in place. Multiple selections show `Fire on 5 selected targets?`; one target keeps its identity/single-target behavior. The existing cancel control cancels the whole pending volley. Its countdown remains accessible in the temporary corner status display with the window closed.

At firing, all shots are instantiated in the same update with their actual associated data-center origin and their own moving actor reference. Each independently evaluates the original designated learning answer and reaches its own deterministic hit or miss. Short, labeled fan-out trails distinguish simultaneous shots whose cross-center tactical paths otherwise overlap; this is only presentation, not a physics or outcome change. Flight duration remains 1.2 simulation seconds. Contacts from non-displayed centers use noninteractive learning-only diamond/ID markers following their actual rendered positions. No tactical center is forced visible, contact geometry changed, hidden affiliation exposed, or original record removed. Markers disappear on a correct learning hit and restore with original P10 navigation/reset, alongside the existing learning visual restoration.

The right-side feedback area keeps all five results together, with center/contact and `Correct: defense` or `Incorrect; correct: defense`. Its height adapts within the empty right margin rather than overwriting the previous contact's result. A rendered mixed volley produced 3 correct, 2 incorrect and 60%. Results remain accessible through subsequent refreshes until restart. Original per-selected-contact post-firing feedback and Why remain intact.

Existing P10 deadlines may expire while educational shots wait. The learning result still cannot undo an operational expiry, produce official points, change cyber containment or append canonical operational events. Original P10 controls remain independently usable.

## Verification

Godot 4.7.2 stable Mono, rendered Vulkan/NVIDIA RTX 2070, reference viewport 1600 x 900. Full existing suites were run through one sequential runner, followed by the new focused suite, editor import and startup checks. P3 uses the previously documented off-desktop window position to avoid desktop hover interference with its root-viewport mouse test; later suites use isolated rendered test viewports.

| Check | Actual final result |
|---|---|
| catalog | CYBER CATALOG: PASS; reproducible exact export, declared schema, manual mappings and unchanged source hash verified |
| prototype3 | PROTOTYPE 3 TEST: PASS (0 failures) |
| prototype4 | PROTOTYPE 4 TEST: PASS (0 failures; 13048 checks) |
| prototype5 | PROTOTYPE 5 TEST: PASS (0 failures; 992 checks) |
| prototype6 | PROTOTYPE 6 TEST: PASS (0 failures; 229 checks) |
| prototype7 | PROTOTYPE 7 TEST: PASS (0 failures; 241 checks) |
| prototype8 | PROTOTYPE 8 TEST: PASS (0 failures; 1748 checks) |
| prototype9 | PROTOTYPE 9 TEST: PASS (0 failures; 311 checks) |
| prototype9_corrections | PROTOTYPE 9 CORRECTIONS: PASS (0 failures; 266 checks) |
| prototype9_cyber | PROTOTYPE 9 CYBER: PASS (0 failures; 361 checks) |
| prototype9_decision | PROTOTYPE 9 DECISION: PASS (0 failures; 233 checks) |
| prototype10_stage1 | PROTOTYPE 10 STAGE 1: PASS (0 failures; 71 checks) |
| prototype10_stage2 | PROTOTYPE 10 STAGE 2: PASS (0 failures; 121 checks) |
| prototype10_stage3 | PROTOTYPE 10 STAGE 3: PASS (0 failures; 234 checks) |
| prototype10_stage4 | PROTOTYPE 10 STAGE 4: PASS (0 failures; 84 checks) |
| prototype11 | PROTOTYPE 11: PASS (0 failures; 145 checks) |
| prototype11_refinements | PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| import | PASS; exit 0, no script/parse errors |
| main_startup | PASS; exit 0, no script/parse errors |
| prototype10_startup | PASS; exit 0, no script/parse errors |
| standalone_startup | PASS; exit 0, no script/parse errors |
| diff_check | PASS; exit 0, no script/parse errors |

Exact commands:

```text
python tests/cyber_catalog_test.py
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --position 3000,2000 --script res://tests/prototype3_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype4_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype5_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype6_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype7_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype8_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_corrections_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_cyber_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_decision_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage1_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage2_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage3_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage4_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_refinements_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --headless --editor --path . --import
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/direct_command.tscn --quit-after 120
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/game.tscn --quit-after 120
git diff --check
```

Focused checks cover scoring before/after impact, zero denominator, repeat impact idempotency/reset, actual catalog hover/clear/missing description, no answer disclosure, column placement, live/absent/expired deadlines, every firing delay, immutable pending answers, cancellation, strategic pause, five simultaneous moving-target flights, own-center origins, mixed results, persistent per-contact feedback, visual restoration and unchanged P10 official scoring/operational ledger/containment state.

During development, the initial focused run exposed a fixture missing required public escalation evidence and a new display lookup reading the expiry action from the wrong event nesting. The fixture and new learning projection were corrected without changing operational rules. A diagnostic assertion then used the wrong center-position property; that new test reference was corrected. These diagnostic runs were not counted as passes. No accepted P3–10 test assertions or application logic were changed to obtain passing results. Long wait boundaries were tested using deterministic simulation advancement, not a claimed ten-minute manual play session.

## Screenshots and rendered inspection

Review directory: `C:\Users\azwam\AppData\Local\Temp\odc_p11_refined_review_2026-10-25_164947`. Complete final verification logs are in its `verification_logs` subdirectory.

- `C:\Users\azwam\AppData\Local\Temp\odc_p11_refined_review_2026-10-25_164947\report.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_refined_review_2026-10-25_164947\hover.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_refined_review_2026-10-25_164947\countdown.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_refined_review_2026-10-25_164947\scheduled.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_refined_review_2026-10-25_164947\volley.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_refined_review_2026-10-25_164947\mixed.png`

These are actual rendered viewport-input tests and captures, not a manual native-desktop playthrough. Inspect Report/hover for eight-column readability, authentic deadline fixture/countdown, five independently visible trails/target IDs, and persistent mixed-result scoring. No generated screenshots or logs are inside the repository.

## Limitations

- Five existing questions and answer keys remain unchanged; no new curriculum, operational scoring or combat evaluator.
- Only one pending/in-flight volley at a time, but it includes all eligible selected contacts; completed questions cannot be retried without restarting the learning session.
- Cross-center learning targets share the same orbital presentation coordinates as their original tactical views and may overlap; labeled trails and center/contact markers distinguish them. This is a learning projection, not a new multi-center physical simulation.
- Current production learning contacts have no deadline; tests demonstrate the column with a supported isolated fixture rather than inventing production countdowns.
- Elapsed Time measures shared simulation time since Analyze/reset, not wall-clock reading time. Explicit strategic pause pauses it and all learning shots.
- Results remain in-session only. No extra scoring points, operational events or persistence were introduced.
- Layout was verified at 1600 x 900; owner visual acceptance remains pending.

## Git status and preservation

Branch `feature/prototype11-simplified-cyber-game`; HEAD `ee96eebb88d942d9302a9aa740e1414fb931eba1`. Index empty. Both prior reports and all pre-existing files except the four explicitly modified files match the start-of-task SHA-256 snapshot. The main-scene change shown below belongs to the already-existing uncommitted P11 implementation and was not changed by this refinement.

```text
M project.godot
?? Reports/Prototype_10_Final_Git_Checkpoint_2026-10-25_145510_01.md
?? Reports/Prototype_11_Simplified_Cyber_Game_2026-10-25_154821_01.md
?? data/learning_questions.json
?? scene/learning_command.tscn
?? script/learning_game.gd
?? script/learning_game.gd.uid
?? script/learning_projectile.gd
?? script/learning_projectile.gd.uid
?? script/learning_question_loader.gd
?? script/learning_question_loader.gd.uid
?? script/learning_session.gd
?? script/learning_session.gd.uid
?? tests/prototype11_refinements_test.gd
?? tests/prototype11_refinements_test.gd.uid
?? tests/prototype11_test.gd
?? tests/prototype11_test.gd.uid
```

This newly created report is one additional untracked file. No reset, discard, overwrite of unrelated work, stash, branch change, commit, tag, push or merge occurred. Prototype 12 was not started. Stop for owner review.
