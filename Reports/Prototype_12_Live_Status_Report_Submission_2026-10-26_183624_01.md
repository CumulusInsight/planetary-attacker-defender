# Prototype 12 ? Live data-center status and Report submission

Completed 2026-10-26T18:36:24-07:00 (Pacific Daylight Time). Local implementation for owner review.

## Baseline and preservation

Repository: C:\Users\azwam\Projects\planetary-attacker-defender

Branch: feature/prototype12-martian-defense

HEAD unchanged: bd807108370d37e89c1d032602b2e7a937f96437

Main scene unchanged: res://scene/correct_only_learning_command.tscn

Accepted Prototype 11 tag planetary-prototype11-complete-v1 remains on 27ef7e8995de8a4270a548086614fabf52a7e6e4; annotated object 76a1775edc5aebd31311237d7a29dd1facf547c4.

All branch/tag references exactly match the pre-edit snapshot, including main and artwork branches. No commit, tag, push, merge, reset, stash, discard, or branch changes were performed. Existing uncommitted Prototype 12 work and all prior reports remain preserved. No accepted Prototype 3?12 test assertions were changed.

Verified external pre-edit backup:

C:\Users\azwam\Projects\Backups\ODC_P12_before_live_status_20261026_181823.zip

SHA-256: d1fc174589342a73cb5211641c92c14930bf8e0d136a0c7641ae4011667cbec0

All 260 project files in the ZIP passed CRC and individual SHA-256 comparison against source. Reproducible .git/.godot caches, Python caches, temporary logs, executables, and archives were excluded. A SHA manifest is inside the ZIP. Final comparison confirms only three pre-existing files changed during this assignment: the current correct-only game, session, and projectile scripts. All other pre-existing source, data, scenes, assets, reports, and project.godot are byte-preserved.

## Files changed

- script/correct_only_learning_game.gd
- script/correct_only_learning_session.gd
- script/correct_only_projectile.gd
- script/live_status_display.gd
- script/live_status_display.gd.uid
- tests/prototype12_live_status_test.gd
- tests/prototype12_live_status_test.gd.uid
- Reports/Prototype_12_Live_Status_Report_Submission_2026-10-26_183624_01.md (new completion report)

The display and focused test scripts plus their generated Godot UID files are new. The first three scripts extend/refine the existing uncommitted current Prototype 12 implementation. Earlier independent compatibility scenes remain intact.

## Existing command trace and final workflow

Inspection found that Report CLOSE already only dismissed the Report. It did not grade answers or fire. D's FIRE NOW / WAIT 1/5/10 MINUTES controls called the authoritative session request_fire method. The new Report action supplies a direct entry into that same authority.

1. A -> YES analyzes and opens Report; R reopens it directly without analysis or round advancement.
2. Choose one option for every unanswered current-round question.
3. SUBMIT ANSWERS submits immediately (WAIT=0), closes Report, and returns to the live orbital display. No second confirmation or D action is required.
4. For delayed firing, close Report and use the existing D -> WAIT 1, 5, or 10 MINUTES. That existing decision submits/schedules the chosen answers directly; it does not require a subsequent Report submission. D -> FIRE NOW also remains available with its existing selected-contact semantics.
5. Report CLOSE never submits, changes answers, cancels a queue, advances a round, or triggers a warning. R can reopen unsent selections for editing.

The footer explicitly says SUBMIT ANSWERS (now), or D for WAIT, rather than implying that both are required. Existing D's selective-answer workflow remains unchanged; Report's new complete-round submit requires all remaining questions to have selections.

## Exact Report controls

CLOSE and SUBMIT ANSWERS are separate upper-right buttons. The round-history selector was shifted within the Report header to make room; the nine sortable columns, answer highlighting, large definitions, results, and history controls are preserved.

submit_report calls session.submit_answers(0). The session first identifies missing contact IDs. If any are unanswered, it returns an error listing them, leaves Report open, and does not call the firing method or evaluate anything. CLOSE remains available to leave deliberately. The session then delegates accepted submissions to the existing request_fire method; no second grading, catalog validation, launch evaluator, or scoring formula was created.

Accepted answer IDs are locked by stable learning-question identity. This prevents editing accepted answers even if a remaining queue is explicitly canceled. Existing queue cancellation stops only queued launches; already airborne shots continue. D can deliberately reschedule canceled, unchanged selections through its existing authority. Repeated submit cannot add grades or missiles.

Submit is disabled while a queue, flight, or impact effect is active, or an accepted Report submission already exists. It is hidden for completed rounds, historical views, and missed-question review. The controller also rejects historical/review submission directly; session review locking remains authoritative. CLOSE remains usable and cannot cancel accepted launches.

## Live status lifecycle

The display is a presentation-only subclass. It derives each current-round contact's status from the authoritative results, queued shots, and claimed flights. It does not store an independent outcome or infer results from projectile position, elapsed UI time, or answer selection.

| Authoritative state | Visible wording |
|---|---|
| Incorrect answer evaluated | ANSWER INCORRECT ? MISSILE NOT LAUNCHED |
| Correct answer queued, including WAIT | CORRECT ANSWER ? MISSILE PENDING LAUNCH |
| Actual launch claim accepted | CORRECT ANSWER ? MISSILE LAUNCHED |
| Confirmed HIT callback | CORRECT ANSWER ? MISSILE LAUNCHED ? THREAT DISABLED |
| Confirmed EVADED callback | CORRECT ANSWER ? MISSILE LAUNCHED ? THREAT EVADED MISSILE |

Unsubmitted selections display no correctness label. An attempted/successful evasion does not display a final EVADED result while the projectile is airborne. Final wording changes only after finish_shot records the authoritative impact/passage result. Incorrect submissions create no projectile, warning, alarm, or random draw. Correct answers retain their grade independently of HIT/EVADED.

Each relevant target has its own contact-ID-prefixed line, so multiple contacts in one center do not overwrite each other. Labels reflect the current round even during historical Report review. Final lines remain until explicit round progression or restart. Previous-round outcomes remain in the historical Report and original all-results records; orbital tiles do not accumulate unlimited historical text.

Six-center labels use wrapped 14-pixel fallback-font text; enlarged views use full wording at 18 pixels. A dark band is reserved beneath each orbital area. Layout origins and ratios are presentation-only; canonical orbital simulation coordinates/speeds and learning orbit profiles remain unchanged. One/two/three/six-center layouts are supported. Two/three-center layouts reserve the manual reset row, and six-center bands leave the Martian controls and reset button accessible.

## Regression-discovered boundary correction

The initial existing correct-only regression exposed an intermittent fractional-clock impact issue and was stopped rather than ignored. Independent reproduction: fired_at=30.1 and clock=66.1 produced elapsed=35.999999999999993 and impacted=false, although the intended interval was exactly 36 seconds. The prior normalization added then subtracted the start time, reintroducing floating-point cancellation.

The current projectile's existing boundary normalization now adds a one-nanosecond visual comparison nudge only within its already-existing 1e-8-second equality tolerance. The authoritative clock and stored result timestamp are not changed. Duration remains 36 simulation seconds; launch spacing remains 15 seconds. The new test checks all 60 fractional frame phases, verifies no hit at 35.999 seconds, and confirms completion at 36.0. Accepted assertions were not weakened. The 169-check existing correct-only suite subsequently passed.

An additional new-test fixture initially reused a loader across detached models while its rendered owner still processed frames, causing a lookup error. The new fixture now stops only that test owner's processing while exercising detached models. The final runner rejects SCRIPT ERROR output even when a test prints PASS. Final logs contain no such error.

## Verification results

All 34 verification steps have final passing results across sequential runs. Existing Prototype 3?11 suites and original Prototype 12/persistence/six-center suites passed unchanged. After the diagnosed boundary correction, the affected current correct-only suite (169 checks), new live-status suite (210 checks), import, all startup checks, and whitespace check passed. Earlier unaffected suites were not needlessly rerun. No tests ran concurrently.

The new 210 checks cover separate controls, incomplete submissions, CLOSE/reopen persistence, mixed submission, no incorrect missiles, pending/actual/final statuses, no premature final outcomes, confirmed HIT and EVADED, multiple rows per center, wrapped six-center/enlarged layouts, reset-control clearance, 0/15/30-second launches, 36-second flights, duplicate prevention, submission locks, WAIT 0/60/300/600, queue survival across CLOSE, historical read-only views, noncombat review, cumulative history/NEXT behavior, original operational scoring/events, and fractional boundary phases.

Actual commands and final results:

- catalog: PASS (exit 0) ? `python tests/cyber_catalog_test.py`
- prototype3: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --position 0,0 --script res://tests/prototype3_test.gd`
- prototype4: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype4_test.gd`
- prototype5: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype5_test.gd`
- prototype6: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype6_test.gd`
- prototype7: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype7_test.gd`
- prototype8: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype8_test.gd`
- prototype9: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_test.gd`
- prototype9_corrections: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_corrections_test.gd`
- prototype9_cyber: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_cyber_test.gd`
- prototype9_decision: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype9_decision_test.gd`
- prototype10_stage1: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage1_test.gd`
- prototype10_stage2: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage2_test.gd`
- prototype10_stage3: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage3_test.gd`
- prototype10_stage4: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype10_stage4_test.gd`
- prototype11: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_test.gd`
- prototype11_refinements: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_refinements_test.gd`
- prototype11_multicenter: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_multicenter_test.gd`
- prototype11_continuity: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_continuity_test.gd`
- prototype11_manual_sort: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_manual_sort_test.gd`
- prototype11_ar_effects: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_ar_effects_test.gd`
- prototype12: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype12_test.gd`
- prototype12_persistence: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype12_persistence_test.gd`
- prototype12_six_centers: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype12_six_centers_test.gd`
- prototype12_correct_only: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype12_correct_only_test.gd`
- prototype12_live_status: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype12_live_status_test.gd`
- import: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --headless --editor --path . --import`
- main_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120`
- prototype12_six_legacy_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/six_center_learning_command.tscn --quit-after 120`
- prototype12_legacy_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/martian_learning_command.tscn --quit-after 120`
- prototype11_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/learning_command.tscn --quit-after 120`
- prototype10_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/direct_command.tscn --quit-after 120`
- standalone_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/game.tscn --quit-after 120`
- diff_check: PASS (exit 0) ? `git diff --check`

Cyber catalog validation passed without modifying the catalog or original SQLite source. Godot 4.7.2 stable Mono editor import and rendered main startup passed. Older Prototype 12 compatibility scenes, Prototype 11, Prototype 10, and standalone tactical startup passed. git diff --check passed; the pre-existing project.godot line-ending advisory is harmless. Changed/new scripts were additionally scanned for trailing whitespace because they are untracked. The index remains empty.

## Rendered screenshots

Automated rendered verification with injected input at 1600 ? 900 was captured and inspected. No manual native-desktop playthrough is claimed.

Evidence folder (outside repository):

C:\Users\azwam\AppData\Local\Temp\odc_p12_live_status_review_2026-10-26_183449

| Screenshot | Evidence |
|---|---|
| prototype4_p12_live_report_controls.png | Upper-right CLOSE and SUBMIT ANSWERS; readable nine-column Report |
| prototype4_p12_live_not_launched.png | Incorrect status; surviving target |
| prototype4_p12_live_wait_pending.png | Correct answer queued during actual 60-second WAIT |
| prototype4_p12_live_wait_launched.png | First actual launch after WAIT; later contacts still queued |
| prototype4_p12_live_mixed_launch.png | Mixed submitted outcomes, initial launch, and pending shots |
| prototype4_p12_live_hit.png | Confirmed THREAT DISABLED after impact |
| prototype4_p12_live_evaded.png | Confirmed THREAT EVADED MISSILE after passage |
| prototype4_p12_live_final_six.png | Six-center mixed outcomes: two incorrect/no launches, two EVADED, one HIT |
| prototype4_p12_live_enlarged.png | Full single-center status wording |

The same folder contains complete final logs/results, sequential runners, and the independent fractional-clock probe. The retained new-test fixture-failure log documents the development-only error described above; the final prototype12_live_status.log is clean and reports 210 checks, zero failures.

## Known limitations

- SUBMIT ANSWERS is the immediate action. Delayed submission remains the existing D/WAIT workflow; no new delay picker or extra confirmation was added.
- Live tile statuses intentionally show current-round targets only; earlier outcomes remain in historical Reports.
- Existing dense orbital contact captions can overlap in compact tiles; the new status bands themselves fit and do not cover orbital areas or reset/warning controls.
- Learning state remains in memory as before. Earlier compatibility scenes retain their historical behavior; F5/current main uses the current correct-only implementation.
- No required verification failures remain. Owner visual acceptance is pending.

## Git status

Status immediately before this report was written:

```text
 M project.godot
?? Reports/Prototype_11_Final_Git_Checkpoint_2026-10-25_224608_01.md
?? Reports/Prototype_12_Correct_Only_Staggered_Review_2026-10-26_153740_01.md
?? Reports/Prototype_12_Martian_Defense_2026-10-26_130357_01.md
?? Reports/Prototype_12_Persistent_Environment_Attack_Definitions_2026-10-26_133924_01.md
?? Reports/Prototype_12_Six_Centers_Monte_Carlo_Evasion_2026-10-26_135716_01.md
?? Reports/Prototype_12_Six_Centers_Monte_Carlo_Evasion_2026-10-26_142540_01.md
?? scene/correct_only_learning_command.tscn
?? scene/martian_learning_command.tscn
?? scene/six_center_learning_command.tscn
?? script/catalog_learning_loader.gd
?? script/catalog_learning_loader.gd.uid
?? script/correct_only_learning_game.gd
?? script/correct_only_learning_game.gd.uid
?? script/correct_only_learning_session.gd
?? script/correct_only_learning_session.gd.uid
?? script/correct_only_projectile.gd
?? script/correct_only_projectile.gd.uid
?? script/live_status_display.gd
?? script/live_status_display.gd.uid
?? script/martian_defense_panel.gd
?? script/martian_defense_panel.gd.uid
?? script/martian_learning_game.gd
?? script/martian_learning_game.gd.uid
?? script/martian_learning_session.gd
?? script/martian_learning_session.gd.uid
?? script/martian_orbital_display.gd
?? script/martian_orbital_display.gd.uid
?? script/martian_projectile.gd
?? script/martian_projectile.gd.uid
?? script/missed_question_review.gd
?? script/missed_question_review.gd.uid
?? script/missed_question_review_panel.gd
?? script/missed_question_review_panel.gd.uid
?? script/monte_carlo_panel.gd
?? script/monte_carlo_panel.gd.uid
?? script/monte_carlo_projectile.gd
?? script/monte_carlo_projectile.gd.uid
?? script/monte_carlo_session.gd
?? script/monte_carlo_session.gd.uid
?? script/six_center_display.gd
?? script/six_center_display.gd.uid
?? script/six_center_learning_game.gd
?? script/six_center_learning_game.gd.uid
?? tests/prototype12_correct_only_test.gd
?? tests/prototype12_correct_only_test.gd.uid
?? tests/prototype12_live_status_test.gd
?? tests/prototype12_live_status_test.gd.uid
?? tests/prototype12_persistence_test.gd
?? tests/prototype12_persistence_test.gd.uid
?? tests/prototype12_six_centers_test.gd
?? tests/prototype12_six_centers_test.gd.uid
?? tests/prototype12_test.gd
?? tests/prototype12_test.gd.uid
```

This report is one additional untracked local file. Only the three current Prototype 12 scripts listed above changed among pre-existing files. All earlier untracked work/reports remain preserved. No files are staged, and no Git history or remote references were changed.

Stop for owner review.
