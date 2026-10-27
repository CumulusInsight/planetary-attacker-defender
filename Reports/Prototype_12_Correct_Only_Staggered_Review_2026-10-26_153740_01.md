# Prototype 12 ? Correct-only firing, staggered launches, missed-question review

Completed: 2026-10-26T15:37:40-07:00 (Pacific Daylight Time). Local implementation pending owner review.

## Preservation and backup

Repository: C:\Users\azwam\Projects\planetary-attacker-defender

Branch: feature/prototype12-martian-defense. HEAD remains bd807108370d37e89c1d032602b2e7a937f96437.
Accepted Prototype 11 tag planetary-prototype11-complete-v1 remains on 27ef7e8995de8a4270a548086614fabf52a7e6e4; tag object remains 76a1775edc5aebd31311237d7a29dd1facf547c4. All local branch/tag references exactly match the pre-edit snapshot. No commit, tag, push, merge, reset, stash, discard, or artwork-branch changes occurred.

Verified external pre-edit backup: C:\Users\azwam\Projects\Backups\ODC_P12_before_correct_only_20261026_150221.zip

SHA-256: 51027883d5c8455c76d37e4b9ca150d7d858deeebceeb9cb0bcdeb7eae917676

The ZIP's CRC and all 247 project-file hashes were verified against source. Final comparison confirms every pre-existing project file is unchanged except project.godot's main-scene selection. Earlier uncommitted Prototype 12 work, reports, catalog, accepted tests, and Prototype 10/11 source remain intact. New components extend existing components rather than rewriting historical fixtures.

## Root cause and enforcement

The previous behavior intentionally created a projectile for each selected answer and represented an incorrect defense as a later MISS. This was the earlier educational rule, rather than a rendering-only defect.

The new authoritative session validates the selected option, designated question answer, and authoritative catalog attack/defense mapping before queuing. Incorrect selections are recorded exactly once as INCORRECT / NOT LAUNCHED at the firing decision, with no physical outcome, warning, alarm, or evasion draw. Unanswered rows remain unanswered and never enter the queue. Incorrect targets remain alive.

Queue dispatch revalidates eligibility. Renderer creation requires a one-time authoritative launch claim matching question generation, defense, and stable physical identity. Duplicate or forged creation requests are rejected. Only correct answers can reach a projectile. Correct answers are graded at completed impact; Martian evasion changes HIT to EVADED without changing cybersecurity correctness. Only HIT removes a physical target.

F5 now opens scene/correct_only_learning_command.tscn. Prior explicitly launched compatibility scenes retain their historical behavior for unchanged regression fixtures; the current main controller has no compatibility bypass for incorrect launches.

## Launch queue and timing

Correct eligible contacts are sorted by stable contact ID. Incorrect/unanswered rows occupy no slots. Each firing decision snapshots selected answers and schedules correct shots at 0, 15, 30, 45, and 60 simulation seconds relative to its initial firing time. WAIT 1/5/10 minutes adds 60/300/600 seconds before the sequence begins.

All timing reads the existing shared simulation clock. Pausing suspends queue dispatch and flight progress. No wall-clock timers were introduced. At most one queued shot launches per dispatch; the next actual launch is at least 15 seconds later, avoiding catch-up bursts following an artificial large clock jump. A 1e-8-second comparison tolerance handles floating-point boundaries without changing simulation time. Flight remains 36 simulation seconds and existing explosion timing is retained.

Tested actual launch schedules: one correct [0]; three correct [0,15,30]; five correct [0,15,30,45,60]. Three-shot impacts occur at [36,51,66]. WAIT scheduling, pause, cancellation, duplicate prevention, and navigation preserve these associations. Pending answers are locked until the remaining queue is canceled; cancellation does not cancel already airborne shots.

The warning activates only at each actual launch. EVADE ALL affects currently airborne eligible shots; later launches remain eligible for a subsequent order. The queue does not consume evasion rolls. NEXT ROUND is blocked until queue, flights, and impact effects finish. Layout preparation includes all queued participating centers, avoiding mid-flight rescaling. Six centers, persistent physical targets, Monte Carlo records, and manual view reset are preserved.

## Completion and noncombat review

After all 22 original questions are processed and effects finish, a prompt shows the incorrect count and offers REVIEW MISSED QUESTIONS / FINISH SESSION. Zero misses instead produces congratulations with no empty review offer. Finish retains final results.

Review uses detached copies of only original incorrect questions, preserving attack names, descriptions, four options, and authoritative IDs. It has no projectile, physical-target mutation, evasion RNG, warning/alarm, or original-result write path. Answer selection evaluates one additional attempt per review question. Correct-answer name and catalog-derived purpose appear only after that review selection. The existing dark definition treatment uses 34-pixel wrapped text and a 3-pixel red outline. Original main Report keeps its nine columns; the noncombat review omits the combat TIME column.

Separate review metrics show original score, reviewed, corrected, still incorrect, and unreviewed. FINISH REVIEW and Close retain results. The player may finish early; unreviewed questions remain explicitly counted. Original 22-question grades/history and physical registry are unchanged. Original learning elapsed time freezes at the final original answer evaluation, preventing review time from inflating the original score summary; the shared simulation clock continues normally.

## Exact files created or modified

- project.godot
- scene/correct_only_learning_command.tscn
- script/correct_only_learning_session.gd
- script/correct_only_learning_game.gd
- script/correct_only_projectile.gd
- script/missed_question_review.gd
- script/missed_question_review_panel.gd
- tests/prototype12_correct_only_test.gd
- script/correct_only_learning_session.gd.uid
- script/correct_only_learning_game.gd.uid
- script/correct_only_projectile.gd.uid
- script/missed_question_review.gd.uid
- script/missed_question_review_panel.gd.uid
- tests/prototype12_correct_only_test.gd.uid
- Reports/Prototype_12_Correct_Only_Staggered_Review_2026-10-26_153740_01.md (this report)

Only project.godot was modified among pre-existing files. No accepted assertions were edited.

## Verification

All 33 final verification steps passed: 24 GDScript suites, catalog validation, import, six scene-startup checks, and whitespace validation. Tests ran sequentially in the final regression runner. A final catalog-purpose feedback refinement was followed by sequential reruns of the affected 169-check suite, editor import, main startup, and diff check, all passing. Earlier development failures were corrected before these final results; none remain outstanding.

The new suite covers incorrect/unanswered zero-launch behavior, no warning/audio/RNG draw, mapped eligibility, exact stagger schedules, 36-second completion, WAIT and pause, cancellation, no catch-up burst, no duplicate creation, successive EVADE ALL eligibility, queue/effect round gates, six-center navigation, all22 original questions, completion branches, review isolation, feedback, and original scoring/physical/history preservation.

Godot: C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe

Actual commands and results:

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
- import: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --headless --editor --path . --import`
- main_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120`
- prototype12_six_legacy_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/six_center_learning_command.tscn --quit-after 120`
- prototype12_legacy_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/martian_learning_command.tscn --quit-after 120`
- prototype11_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/learning_command.tscn --quit-after 120`
- prototype10_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/direct_command.tscn --quit-after 120`
- standalone_startup: PASS (exit 0) ? `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/game.tscn --quit-after 120`
- diff_check: PASS (exit 0) ? `git diff --check`

The final focused suite reports 169 checks, zero failures. Existing Prototype 3?12 suites passed unchanged, including Prototype 9 corrections/cyber/decision, Prototype 10 Stages 1?4, all Prototype 11 refinements, and prior Prototype 12 persistence/six-center tests. Catalog validation verifies reproducible source export and mappings. git diff --check passes; Git reports only the existing project.godot CRLF/LF normalization advisory. Nothing is staged.

## Rendered evidence

Actual 1600 ? 900 rendered execution with injected test input was inspected. This is automated rendered verification, not a claimed manual native-desktop playthrough.

Screenshots, runners, and full command logs are outside the repository:

C:\Users\azwam\AppData\Local\Temp\odc_p12_correct_final_review_2026-10-26_153457

- prototype4_p12_correct_completed_session.png
- prototype4_p12_correct_first_launch.png
- prototype4_p12_correct_mixed_report.png
- prototype4_p12_correct_overlapping.png
- prototype4_p12_correct_review_feedback.png
- prototype4_p12_correct_review_prompt.png
- prototype4_p12_correct_review_screen.png
- prototype4_p12_correct_review_summary.png
- prototype4_p12_correct_second_launch.png
- prototype4_p12_review_22_layout.png

The mixed Report shows three selected correct answers and two recorded incorrect answers; launch images show counts increasing at 0/15/30 seconds with overlapping flights. Final original results show 20 correct / 2 incorrect (91%). Review demonstrates one correction and one still-incorrect response with catalog-purpose explanation, while original results/time remain unchanged. The additional 22-missed-question capture verifies scroll access and the review layout with the maximum missed set.

## Known limitations

- Learning/review state remains in memory, matching existing session persistence; no disk save was added.
- Review offers one additional attempt per missed question and permits finishing early; unreviewed count is explicit.
- Older independently runnable compatibility scenes intentionally preserve earlier behavior; use F5/current main for this refinement.
- Compact orbital captions can overlap in dense tiles, as in the prior presentation; no unrelated layout redesign was performed.
- No outstanding required test failures. Owner visual acceptance is pending.

## Final working tree

This report is a new untracked local document. The following status was captured immediately before writing it; all earlier untracked Prototype 12 files remain preserved:

```text
 M project.godot
?? Reports/Prototype_11_Final_Git_Checkpoint_2026-10-25_224608_01.md
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
?? tests/prototype12_persistence_test.gd
?? tests/prototype12_persistence_test.gd.uid
?? tests/prototype12_six_centers_test.gd
?? tests/prototype12_six_centers_test.gd.uid
?? tests/prototype12_test.gd
?? tests/prototype12_test.gd.uid
```

No Git publication/history-changing operations were performed. Stop for owner review.
