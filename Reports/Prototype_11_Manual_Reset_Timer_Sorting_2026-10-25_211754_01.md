# Prototype 11 - Manual Reset, Neutralized Timers, Sortable Report

Created: 2026-10-25T21:17:54-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_11_Manual_Reset_Timer_Sorting_2026-10-25_211754_01.md`.
Status: Implemented and locally verified; awaiting owner review.

## Scope and preservation

Branch: `feature/prototype11-simplified-cyber-game`. HEAD and accepted Prototype 10 tag: `ee96eebb88d942d9302a9aa740e1414fb931eba1`. No commit, tag, push, merge, reset, stash, or discard was performed. All five prior reports were verified byte-for-byte unchanged against the start-of-task backup. Existing uncommitted Prototype 11 work is preserved.
External backup: `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_backup_20261025_210441`.

## Files changed in this assignment

- `script/learning_game.gd`: remove automatic reset scheduling; manual button visibility/deferred reset; neutralized clock projection; clickable Report headings and stable sorting.
- `script/learning_session.gd`: record explicit `NEUTRALIZED` or `ANSWERED_INCORRECT` learning outcome at accepted projectile impact.
- `tests/prototype11_continuity_test.gd`: replace the superseded attempt to click the now-hidden single-center reset button with a hidden-button assertion; describe its already-requested deferred reset accurately. Remaining round/scoring/projectile assertions retained.
- New `tests/prototype11_manual_sort_test.gd` and required Godot `.uid`: focused model and rendered interaction checks.
- This new report.

The pre-existing `project.godot` modification remains unchanged. Question bank, catalog, answer keys, projectile script, movement/display component, original Prototype 10 scripts/scenes, official scoring and operational deadline owners were not edited.

## Manual reset

The post-volley automatic-reset flag and timer were removed. Participating centers remain at their current layout after flight and impact effects. `RESET TO ONE` appears only while two or three learning centers are displayed. It returns to the explicitly selected center (DC-01 fallback), then hides. A request during flight waits until all projectile/effect nodes finish; there is no automatic reset countdown. Results, answers, scores, raw deadline budgets and simulation state are retained. Later multi-center volleys show the button again. Existing single-center dropdown behavior is preserved.

## Neutralized learning timers

Only `finish_shot` for a confirmed correct impact sets `learning_state = NEUTRALIZED`. Before impact, selection, scheduling and flight leave the timer running. The shared learning `deadline_view`/`deadline_text` projection returns numeric zero and `00:00` for neutralized questions, both in Report and the primary learning deadline table. The underlying absolute deadline, authoritative simulation clock and original operational owner are untouched. Incorrect/unanswered questions keep counting down and retain `EXPIRED` behavior. Late practice and scoring rules remain unchanged.

Round archiving captures this displayed value: correct results retain `00:00`; incorrect results retain the remaining-time or EXPIRED snapshot taken when archived. Reused contact slots receive new question identities, preserving old results.

## Sorting rules

All nine headings are clickable. A newly selected column starts ascending; repeated clicks reverse direction. The active heading shows `^` or `v`. Center IDs and attack/defense names sort lexically (names case-insensitive); contact IDs sort numerically. TIME uses actual numeric remaining time, never formatted text. Neutralized and expired rows both sort as zero, retaining different visible labels; unavailable times sort last in either direction. Equal keys use stable learning-question identity as the ascending secondary key regardless of primary direction.

RESULT order: NOT ANSWERED, SELECTED, CORRECT, INCORRECT (reversed for descending). Option columns sort by the corresponding displayed countermeasure name. Sorting changes presentation only; answer callbacks retain their contact association, and archived/cumulative results retain stable learning IDs.

Live countdowns refresh without rearranging displayed rows. Sorting is recomputed on a header click, reopening the Report, or changing the reviewed round. Historical sorting operates on read-only snapshots. Selected-answer underlining, explanations and post-evaluation answer disclosure are preserved. Nine columns fit at 1600 x 900 without horizontal scrolling; heading padding/widths were adjusted without reducing font sizes.

## Verification

Godot 4.7.2 stable Mono, Vulkan Forward+, NVIDIA RTX 2070. Tests executed sequentially. Rendered tests use the existing 1600 x 900 test viewport and injected mouse input; no manual native-desktop playthrough is claimed.

| Check | Result |
|---|---|
| catalog | PASS - CYBER CATALOG: PASS; reproducible exact export, declared schema, manual mappings and unchanged source hash verified |
| prototype3 | PASS - PROTOTYPE 3 TEST: PASS (0 failures) |
| prototype4 | PASS - PROTOTYPE 4 TEST: PASS (0 failures; 13048 checks) |
| prototype5 | PASS - PROTOTYPE 5 TEST: PASS (0 failures; 992 checks) |
| prototype6 | PASS - PROTOTYPE 6 TEST: PASS (0 failures; 229 checks) |
| prototype7 | PASS - PROTOTYPE 7 TEST: PASS (0 failures; 241 checks) |
| prototype8 | PASS - PROTOTYPE 8 TEST: PASS (0 failures; 1748 checks) |
| prototype9 | PASS - PROTOTYPE 9 TEST: PASS (0 failures; 311 checks) |
| prototype9_corrections | PASS - PROTOTYPE 9 CORRECTIONS: PASS (0 failures; 266 checks) |
| prototype9_cyber | PASS - PROTOTYPE 9 CYBER: PASS (0 failures; 361 checks) |
| prototype9_decision | PASS - PROTOTYPE 9 DECISION: PASS (0 failures; 233 checks) |
| prototype10_stage1 | PASS - PROTOTYPE 10 STAGE 1: PASS (0 failures; 71 checks) |
| prototype10_stage2 | PASS - PROTOTYPE 10 STAGE 2: PASS (0 failures; 121 checks) |
| prototype10_stage3 | PASS - PROTOTYPE 10 STAGE 3: PASS (0 failures; 234 checks) |
| prototype10_stage4 | PASS - PROTOTYPE 10 STAGE 4: PASS (0 failures; 84 checks) |
| prototype11 | PASS - PROTOTYPE 11: PASS (0 failures; 144 checks) |
| prototype11_refinements | PASS - PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| prototype11_multicenter | PASS - PROTOTYPE 11 TIME VARIETY MULTICENTER: PASS (0 failures; 229 checks) |
| prototype11_continuity | PASS - PROTOTYPE 11 GAMEPLAY CONTINUITY: PASS (0 failures; 174 checks) |
| prototype11_manual_sort | PASS - PROTOTYPE 11 MANUAL RESET TIMER SORTING: PASS (0 failures; 302 checks) |
| import | PASS - Exit 0; no script/parse errors |
| main_startup | PASS - Exit 0; no script/parse errors |
| prototype10_startup | PASS - Exit 0; no script/parse errors |
| standalone_startup | PASS - Exit 0; no script/parse errors |
| diff_check | PASS - Exit 0; no script/parse errors |

Commands used:

```text
python tests/cyber_catalog_test.py
Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/<suite>_test.gd
# Prototype 3 additionally uses --position 3000,2000 for its viewport mouse checks.
Godot_v4.7.2-stable_mono_win64_console.exe --headless --editor --path . --import
Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120
Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/direct_command.tscn --quit-after 120
Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/game.tscn --quit-after 120
git diff --check
```

The first focused run passed 250 checks; expanded rendered header-fit testing found one clipped Data Center heading. Its width was corrected, then all Prototype 11 suites were rerun successfully. Final focused suite: 302 checks, zero failures. Earlier Prototype 3-10 suites passed unchanged; only the directly superseded continuity reset expectation was updated as described above. Full final check manifest and command arrays are in the review folder. New/untracked edited source files also passed explicit trailing-whitespace checks.

## Rendered screenshots

Review folder (outside repository): `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754`. All seven images were opened and inspected. Nine headings and all choice/result columns are readable, sorting indicators visible, selection underlines intact, and the reset button is absent in single-center view. Existing close/navigation controls remain accessible.

- `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754\p11_manual_three_survivors.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754\p11_manual_single_hidden.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754\p11_manual_zero_report.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754\p11_manual_sorted_time.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754\p11_manual_sorted_attack.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754\p11_manual_zero_time_sort.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_manual_review_2026-10-25_211754\p11_manual_history.png`

## Known limitations

- TIME sorting intentionally keeps a snapshot row order until a new sort/reopen; the numeric labels continue updating.
- Expired and neutralized rows share numeric zero for sorting; their labels and stable question IDs distinguish them.
- Historical times are archived display snapshots, not continuously advancing clocks.
- Screenshots are automated rendered verification, not owner/manual desktop acceptance. Existing occasional close contact-label overlap is unchanged.

## Git working tree

Prototype 11 remains uncommitted. Nothing is staged. The only tracked modification remains the pre-existing `project.godot` change; Prototype 11 source/data/tests/reports remain untracked as before, with the new focused test/UID and this report added. The accepted checkpoint and branch remain unchanged.

Status including this new report:

```text
 M project.godot
?? Reports/Prototype_10_Final_Git_Checkpoint_2026-10-25_145510_01.md
?? Reports/Prototype_11_Gameplay_Continuity_2026-10-25_203808_01.md
?? Reports/Prototype_11_Manual_Reset_Timer_Sorting_2026-10-25_211754_01.md
?? Reports/Prototype_11_Simplified_Cyber_Game_2026-10-25_154821_01.md
?? Reports/Prototype_11_Targeted_Refinements_2026-10-25_164947_01.md
?? Reports/Prototype_11_Time_Variety_Multicenter_2026-10-25_193849_01.md
?? data/learning_question_bank.json
?? data/learning_questions.json
?? scene/learning_command.tscn
?? script/learning_game.gd
?? script/learning_game.gd.uid
?? script/learning_orbital_display.gd
?? script/learning_orbital_display.gd.uid
?? script/learning_projectile.gd
?? script/learning_projectile.gd.uid
?? script/learning_question_loader.gd
?? script/learning_question_loader.gd.uid
?? script/learning_session.gd
?? script/learning_session.gd.uid
?? tests/prototype11_continuity_test.gd
?? tests/prototype11_continuity_test.gd.uid
?? tests/prototype11_manual_sort_test.gd
?? tests/prototype11_manual_sort_test.gd.uid
?? tests/prototype11_multicenter_test.gd
?? tests/prototype11_multicenter_test.gd.uid
?? tests/prototype11_refinements_test.gd
?? tests/prototype11_refinements_test.gd.uid
?? tests/prototype11_test.gd
?? tests/prototype11_test.gd.uid
```

Stopped for owner review. No further development performed.
