# Prototype 11 - Restore A/R and Enhance Firing Animation

Created: 2026-10-25T22:24:08-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_11_AR_Projectile_Explosion_2026-10-25_222408_01.md`.
Status: Implemented, locally verified, awaiting owner review.

## Repository preservation

Branch: `feature/prototype11-simplified-cyber-game`. HEAD and accepted Prototype 10 complete tag both remain `ee96eebb88d942d9302a9aa740e1414fb931eba1`. Nothing was committed, tagged, pushed, merged, reset, stashed or discarded. All six existing completion/checkpoint reports match their start-of-task hashes; prior Prototype 11 work remains uncommitted.
External pre-edit backup: `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_backup_20261025_221301`.

## Exact files modified

- `script/learning_game.gd`: restore separate A, R and D controls, active-button indication and concise pre-analysis instruction; update current workflow guidance from A-R to A.
- `script/learning_projectile.gd`: 3.6-second homing flight; tripled hit-effect radius and duration; geometry-only clipping to the owning display; hold visual flight/effect state while the authoritative clock is unchanged.
- `tests/prototype11_test.gd`: obsolete combined-button expectations and interaction references updated; impact/effect observation waits extended.
- `tests/prototype11_refinements_test.gd`: extend the mixed-volley impact observation wait.
- `tests/prototype11_multicenter_test.gd`: extend the moving-target volley impact observation wait.
- `tests/prototype11_continuity_test.gd`: separate-button expectations/references and longer impact/effect observation waits.
- `tests/prototype11_manual_sort_test.gd`: longer flight/effect completion observation waits.
- New `tests/prototype11_ar_effects_test.gd` and Godot `.uid`: focused navigation, exact-duration, moving-target, pause, clipping and reset checks.
- This new report.

No changes to the question bank, answer keys, learning-session evaluator, deadline ownership, scoring, source intelligence, catalog, original Prototype 10 scenes/scripts, contact movement, or canonical operational ledger. The pre-existing `project.godot` change remains byte-identical.

## A / R navigation

The three learning buttons now appear as A, R, D at x=412, 466, 520; existing Prototype 10 controls and D retain their positions. A opens the original YES/NO/Close question. YES performs the existing analysis/next-round transition and opens Report automatically; NO and Close do neither. The 5/5/2 progression and historical question identities are unchanged.

R directly opens Report without analyzing, advancing rounds, replacing answers, resetting clocks, or changing scores. Before analysis it displays: "Use A to analyze threats, then YES to prepare the Report." After analysis it preserves the current or historical review selection. All nine sortable columns, hover explanations, selected-answer underlines and neutralized clock projection are retained.

## Projectile timing and effect geometry

| Parameter | Before | After |
|---|---:|---:|
| Flight duration | 1.2 simulation seconds | 3.6 simulation seconds |
| Correct-hit effect duration | 0.65 simulation seconds | 1.95 simulation seconds |
| Hit ring maximum radius, before layout scale | 60 | 180 |
| Hit burst-ray maximum outer radius, before layout scale | 69 | 207 |
| Incorrect-miss effect duration | 0.65 simulation seconds | 0.65 simulation seconds |

The existing flight interpolation now uses elapsed / 3.6, so projectiles travel more slowly rather than waiting to launch. Volley shots share the same firing timestamp and continue homing to their own moving contact positions. Miss steering, answer evaluation and WAIT 60/300/600-second scheduling are preserved. Evaluation still happens only at the completed hit/miss event.

At a correct impact, the effect center is captured at the target position and remains fixed afterward. All hit-effect radial geometry is multiplied by three, using the existing max(0.5, visual_scale) layout factor. The expanding ring and burst rays are clipped geometrically to the associated center tile, with a small stroke margin, preventing spill into adjacent displays. Miss effects retain their previous radius, duration and visual behavior.

Repeated frames with an unchanged authoritative simulation timestamp no longer recompute flight position against moving background traffic. This keeps the projectile and explosion visually paused when strategic pause holds the clock. Contact movement itself remains under the existing Prototype 10 policy. No wall-clock timer was introduced.

The full correct-shot visual sequence lasts approximately 5.55 simulation seconds (3.6 + 1.95). A manual RESET TO ONE request waits until all flights/effects complete; it does not cut off an explosion. Automatic reset remains absent. Correct results still neutralize only the learning TIME projection to 00:00, and official operational outcomes remain independent.

## Verification

Godot 4.7.2 stable Mono; rendered Vulkan Forward+ on NVIDIA RTX 2070. All suites ran sequentially. Rendered interaction uses the existing 1600 x 900 viewport and injected mouse events, not a claimed manual native-desktop playthrough.

| Check | Actual result |
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
| prototype11 | PASS - PROTOTYPE 11: PASS (0 failures; 145 checks) |
| prototype11_refinements | PASS - PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| prototype11_multicenter | PASS - PROTOTYPE 11 TIME VARIETY MULTICENTER: PASS (0 failures; 229 checks) |
| prototype11_continuity | PASS - PROTOTYPE 11 GAMEPLAY CONTINUITY: PASS (0 failures; 174 checks) |
| prototype11_manual_sort | PASS - PROTOTYPE 11 MANUAL RESET TIMER SORTING: PASS (0 failures; 302 checks) |
| prototype11_ar_effects | PASS - PROTOTYPE 11 AR PROJECTILE EXPLOSION: PASS (0 failures; 55 checks) |
| import | PASS - Exit 0; no script/parse errors |
| main_startup | PASS - Exit 0; no script/parse errors |
| prototype10_startup | PASS - Exit 0; no script/parse errors |
| standalone_startup | PASS - Exit 0; no script/parse errors |
| diff_check | PASS - Exit 0; no script/parse errors |

Commands:

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

The focused suite checks pre-analysis R behavior, A YES/NO/Close, direct current/historical R access, exact flight/effect durations, motion before impact, moving-target hits and misses, simultaneous three-center firing, pause in flight and explosion, enlarged radii, tile bounds, deferred reset, unchanged scores, neutralized clocks, and next-round progression. Existing continuity tests verify the full 5/5/2 sequence and cumulative results. Earlier test updates change only obsolete A-R expectations and waits made obsolete by the requested slower/longer animation. New/untracked edited sources also passed explicit trailing-whitespace checks.

During initial focused testing, a decimal-boundary fixture used a nonzero time origin that introduced subtraction rounding; it was corrected to test the exact 3.6-second interval from zero. Pause testing also identified and corrected repeated-position recomputation at a frozen clock. Final results above are from the successful verification run.

## Screenshots and visual findings

External review folder: `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408`. Full command arrays and logs are in its `checks` directory. Eight screenshots were opened and inspected; the six requested views plus one- and two-center hit examples are retained. A/R/D match the taskbar style, Report remains readable, all projectile origins correspond to their centers, larger effects remain recognizable and bounded, result feedback persists, and manual reset remains available for multi-center layouts.

- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_ar_default.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_ar_analyze.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_ar_direct_report.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_ar_midflight.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_ar_expanded_hit.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_ar_three_retained.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_hit.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_ar_review_2026-10-25_222408\p11_refined_mixed.png`

## Known limitations

- Hit effects at a tile edge are intentionally clipped at that display boundary; their actual impact center is not moved.
- On-screen timing resolves on rendered simulation updates; pure-clock tests verify the exact configured intervals.
- Prototype 10 background traffic retains its existing pause policy. Only learning flight/effect progression uses the frozen simulation clock.
- These are visual learning-game effects, not new combat physics or operational defense outcomes.
- Owner manual visual acceptance remains pending.

## Git status

No index entries were staged. Prototype 11 remains uncommitted on the original feature branch. The only tracked modification is the preserved `project.godot` change; Prototype 11 files/reports remain untracked, with this report and the new focused test/UID added. No checkpoint history was changed.

```text
 M project.godot
?? Reports/Prototype_10_Final_Git_Checkpoint_2026-10-25_145510_01.md
?? Reports/Prototype_11_AR_Projectile_Explosion_2026-10-25_222408_01.md
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
?? tests/prototype11_ar_effects_test.gd
?? tests/prototype11_ar_effects_test.gd.uid
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

Stopped for owner review. Prototype 12 was not begun.
