# Prototype 12 — learning screen cleanup and partial submissions

2026-10-27T20:38:49-07:00

## Result

The current main scene remains res://scene/learning_retrofit_command.tscn. One or more new selected answers can be submitted, with remaining questions left available. CLOSE does not submit. SUBMIT ANSWERS closes Report and returns to the six-center live environment without requiring D. Expanded lesson content is retained verbatim and reorganized. No turret or mouse-button shooting feature was started.

## Preservation and verified backup

Branch: feature/prototype12-martian-defense. HEAD remains b2084113774bc5df268d7f2bfabdd5fdd1d4f626. The accepted Prototype 10/11/12 checkpoints and local branch/tag refs are unchanged. No staged files, commits, tags, pushes, merges, resets, stashes or discarded work. The interrupted work was resumed in place, not restored from backup.

ZIP: C:\Users\azwam\Projects\Backups\ODC_before_partial_submission_20261027_194311.zip

SHA-256: 3c4025dcbe2f6cecde5906c12aa22fcf07decf958cbb827274de2f3c1eb3b57b

302 archived project/input files, including untracked implementation and reports. ZIP CRC and every archived file hash were verified before editing and reverified after resuming. Reproducible caches, Git metadata, temporary logs and unnecessary executables were excluded. No existing files are missing. Educational source/export/catalog/input/review records were not rewritten. The 100 attacks, 185 defenses and 211 original mappings retain candidate review status; no production approval was granted.

## Exact changed files

- script/correct_only_learning_game.gd
- script/learning_detail_panel.gd
- script/retrofit_learning_game.gd
- script/rich_learning_session.gd
- tests/learning_retrofit_ui_test.gd

New files:

- tests/learning_partial_submission_test.gd
- tests/learning_partial_submission_test.gd.uid
- Reports/Prototype_12_Learning_UI_Partial_Submissions_2026-10-27_203849_01.md

The two tracked modifications project.godot and script/six_center_learning_game.gd belong to the preceding retrofit and were preserved, not changed by this assignment. Pre-existing untracked retrofit inputs and reports remain intact.

## Lesson layout and navigation

One vertical scroll area now presents attack Definition, Realistic Example, Question and four Answer Options in that order. Selecting a defense brings its own Definition, How It Works, When It Applies, Limitations and Realistic Example into view after container layout settles. Full fields come from the canonical-ID editorial layer; the original wording is unchanged. Attack-name clicks start at the actual attack lesson. Defense-option clicks show the selected defense, not the attack definition.

Only section headings receive BBCode underline markup. Generic Topic Type values Attack/Category and the generic Game Visualization paragraph are removed from this view. Meaningful classifications, such as potentially legitimate activity, remain near the bottom. Answer reasoning and mapping limitations remain after submission/evaluation; no answer key is revealed merely by hovering or selecting.

Hover tooltips use the actual attack/defense definition and never select, submit, grade or launch. The lesson has a fixed upper-right Close control and Escape support. Closing it leaves the underlying Report selection/order/layout intact. The Report has no separate vertical-scroll state to reset; its existing compact grid is preserved.

## Underline correction

The former line used y=34 from older rows; the expanded 80-pixel rows vertically center their text lower. The new scene measures the wrapped text using the actual button font and width, then places a centered line below its text block and inside the button bounds. Unselected answers have no line. Selected, evaluated and historical rows share this rule. Correct cybersecurity answers retain green styling even when the physical outcome is EVADED; incorrect selections remain red. No overline or strikethrough is used.

## Submission state and launch scheduling

The rich learning-session subclass identifies only selected, unsubmitted eligible questions. Empty submissions give a concise message and remain in Report. Nonempty submissions delegate to the existing correct-only request_fire authority, then lock just that subset by stable learning-question identity. Wrong selected answers grade once with zero projectile/warning/evasion draw; unanswered rows are untouched. Correct choices queue once and grade at their existing authoritative impact.

The inherited whole-round gate is unchanged for legacy scenes. A small virtual button-eligibility hook gives the retrofit scene a partial-round gate. This avoids the earlier per-frame disabled/enabled toggle, which canceled mouse presses after the first submission. A one-shot compatibility contact_id is supplied to the existing Decide summary for a single queued shot; the queue remains the scheduling authority.

Batches are serialized. During an active queue, flight or impact effect, the player can prepare remaining selections, but a second submission is disabled/rejected until the current sequence finishes. New selections are preserved on rejection. No batch can replace an existing queue or bypass the 15-second spacing. Each accepted batch schedules correct answers in the inherited stable contact order at 0/15/30/etc. Actual flights remain 36 simulation seconds; pause, late-practice, evasion RNG and physical results are unchanged.

D retains 0/60/300/600-second timing choices and uses the same request_fire authority and subset locks. Existing cancellation unlocks only canceled unlaunched answers; already airborne or evaluated answers remain locked. SUBMIT ANSWERS means immediate scheduling, with no additional D action. CLOSE is nonmutating navigation and never cancels an existing queue.

Round progression still requires all current questions evaluated, an empty queue and all flights/effects finished. Partial submission does not advance or reinitialize a round. NEXT ROUND remains explicit, with 5/5/5/5/2 progression, cumulative score and stable historical question IDs. Historical Report is read-only; missed-question review remains noncombat and preserves original results.

## Verification

All 39 sequential checks passed, including the complete unchanged Prototype 3–12 regression suites, canonical catalog validation, learning-retrofit validation/core/rendered tests, new partial-submission tests, editor import, main/legacy/tactical startup and git diff --check. Existing learning-retrofit UI assertions were adapted only for the requested move from one inner RichTextLabel scroll area to the ordered shared ScrollContainer; no gameplay assertion was removed. Legacy Prototype 3–12 assertions were unchanged.

| Check | Actual result |
|---|---|
| catalog | PASS, exit 0; CYBER CATALOG: PASS; reproducible exact export, declared schema, manual mappings and unchanged source hash verified |
| editorial_validation | PASS, exit 0; LEARNING RETROFIT: PASS (814 checks); 100/185/211; production blocked pending owner acceptance |
| prototype3 | PASS, exit 0; PROTOTYPE 3 TEST: PASS (0 failures) |
| prototype4 | PASS, exit 0; PROTOTYPE 4 TEST: PASS (0 failures; 12968 checks) |
| prototype5 | PASS, exit 0; PROTOTYPE 5 TEST: PASS (0 failures; 992 checks) |
| prototype6 | PASS, exit 0; PROTOTYPE 6 TEST: PASS (0 failures; 229 checks) |
| prototype7 | PASS, exit 0; PROTOTYPE 7 TEST: PASS (0 failures; 241 checks) |
| prototype8 | PASS, exit 0; PROTOTYPE 8 TEST: PASS (0 failures; 1748 checks) |
| prototype9 | PASS, exit 0; PROTOTYPE 9 TEST: PASS (0 failures; 311 checks) |
| prototype9_corrections | PASS, exit 0; PROTOTYPE 9 CORRECTIONS: PASS (0 failures; 266 checks) |
| prototype9_cyber | PASS, exit 0; PROTOTYPE 9 CYBER: PASS (0 failures; 361 checks) |
| prototype9_decision | PASS, exit 0; PROTOTYPE 9 DECISION: PASS (0 failures; 233 checks) |
| prototype10_stage1 | PASS, exit 0; PROTOTYPE 10 STAGE 1: PASS (0 failures; 71 checks) |
| prototype10_stage2 | PASS, exit 0; PROTOTYPE 10 STAGE 2: PASS (0 failures; 121 checks) |
| prototype10_stage3 | PASS, exit 0; PROTOTYPE 10 STAGE 3: PASS (0 failures; 234 checks) |
| prototype10_stage4 | PASS, exit 0; PROTOTYPE 10 STAGE 4: PASS (0 failures; 84 checks) |
| prototype11 | PASS, exit 0; PROTOTYPE 11: PASS (0 failures; 145 checks) |
| prototype11_refinements | PASS, exit 0; PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| prototype11_multicenter | PASS, exit 0; PROTOTYPE 11 TIME VARIETY MULTICENTER: PASS (0 failures; 229 checks) |
| prototype11_continuity | PASS, exit 0; PROTOTYPE 11 GAMEPLAY CONTINUITY: PASS (0 failures; 174 checks) |
| prototype11_manual_sort | PASS, exit 0; PROTOTYPE 11 MANUAL RESET TIMER SORTING: PASS (0 failures; 302 checks) |
| prototype11_ar_effects | PASS, exit 0; PROTOTYPE 11 AR PROJECTILE EXPLOSION: PASS (0 failures; 55 checks) |
| prototype12 | PASS, exit 0; PROTOTYPE 12 MARTIAN DEFENSE: PASS (0 failures; 106 checks) |
| prototype12_persistence | PASS, exit 0; PROTOTYPE 12 PERSISTENCE: PASS (0 failures; 299 checks) |
| prototype12_six_centers | PASS, exit 0; PROTOTYPE 12 SIX CENTERS: PASS (0 failures; 392 checks) |
| prototype12_correct_only | PASS, exit 0; PROTOTYPE 12 CORRECT ONLY: PASS (0 failures; 169 checks) |
| prototype12_live_status | PASS, exit 0; PROTOTYPE 12 LIVE STATUS: PASS (0 failures; 210 checks) |
| learning_core | PASS, exit 0; LEARNING RETROFIT CORE: PASS (0 failures; 5305 checks) |
| learning_ui | PASS, exit 0; LEARNING RETROFIT UI: PASS (0 failures; 59 checks) |
| learning_partial | PASS, exit 0; LEARNING PARTIAL SUBMISSION UI: PASS (0 failures; 103 checks) |
| import | PASS, exit 0 |
| main_startup | PASS, exit 0 |
| prototype12_six_legacy_startup | PASS, exit 0 |
| prototype12_legacy_startup | PASS, exit 0 |
| prototype11_startup | PASS, exit 0 |
| prototype10_startup | PASS, exit 0 |
| standalone_startup | PASS, exit 0 |
| prototype12_checkpoint_startup | PASS, exit 0 |
| diff_check | PASS, exit 0 |

Exact commands and raw logs: C:\Users\azwam\Projects\Backups\ODC_P12_Partial_Submissions_Review_20261027_203849. results.json records each invocation. Standard forms: python tests/cyber_catalog_test.py; python tests/learning_retrofit_test.py; Godot --path . --script res://tests/<suite>_test.gd (sequential); Godot --headless --path . --script res://tests/learning_retrofit_core_test.gd; Godot --headless --editor --path . --import; Godot --path . --quit-after 120.

Focused coverage includes underlines/heading order, exact attack and defense fields, hover safety, one/two/five selections, reopened remaining questions, correct-only grades/launches, busy/duplicate rejection, active queue preservation, exact 15/36-second timing, all four WAIT delays, cancellation, no premature NEXT, all five rounds, historical underlines, physical HIT persistence, noncombat review and unchanged canonical mission/ledger/contacts.

Initial targeted runs exposed the single-queue summary field and per-frame button gating defects. Both were corrected and the focused suite reran successfully; failed exploratory runs are not reported as passes. Older suites deliberately print errors for negative invalid-configuration fixtures. No new parse/script errors occurred in the final passing run.

## Screenshots and visual inspection

C:\Users\azwam\Projects\Backups\ODC_P12_Partial_Submissions_Review_20261027_203849

- prototype4_partial_attack_lesson.png — ordered attack content and underlined headings.
- prototype4_partial_defense_lesson.png — selected defense-specific fields.
- prototype4_partial_report_underline.png — selected answer underline and distinct Close/Submit controls.
- prototype4_partial_one_live.png — one submitted question, live six-center presentation.
- prototype4_partial_reopened_remaining.png — completed result plus four untouched selectable questions.
- prototype4_partial_round_results.png — live results after repeated submissions.
- prototype4_partial_history.png — retained read-only historical selections/results.

Rendered input/viewport tests ran at 1600 × 900 on Godot 4.7.2 Mono/Vulkan; screenshots were inspected for clipping, wrapping and selection/result visibility. This is automated rendered verification, not a manual native-desktop playthrough or owner acceptance.

## Known limitations and owner review

Submission batches deliberately do not append to an airborne batch: wait for its effects to finish before submitting again. Full lesson text may require vertical scrolling, but is not shortened. Editorial content remains candidate material with the previously documented mapping exceptions; no mappings, definitions or answer keys were edited. No new firing mechanic or scoring rule was introduced.

Launch: F5, A → YES, select one or more options, close lesson, SUBMIT ANSWERS. Watch live outcomes; R reopens the same round for remaining questions. CLOSE alone returns to live without submitting. Stop for owner review.

## Final working-tree status

```text
M project.godot
 M script/correct_only_learning_game.gd
 M script/six_center_learning_game.gd
?? Learning_Content_ID_Reconciliation_2026-10-27_150655.json
?? Learning_Content_ID_Reconciliation_2026-10-27_150655.md
?? Reports/Learning_Content_ID_Reconciliation_2026-10-27_150655.json
?? Reports/Learning_Content_ID_Reconciliation_2026-10-27_150655.md
?? Reports/Learning_Retrofit_Before_After.json
?? Reports/Learning_Retrofit_Editorial_Review.md
?? Reports/Learning_Retrofit_Full_Mode_Pursuit_2026-10-27_171211_01.md
?? Reports/Learning_Retrofit_Quality.json
?? cyber_100_attacks_learning_draft.db
?? data/learning_retrofit.json
?? editorial/
?? scene/learning_retrofit_command.tscn
?? script/learning_detail_panel.gd
?? script/learning_detail_panel.gd.uid
?? script/pursuit_display.gd
?? script/pursuit_display.gd.uid
?? script/pursuit_projectile.gd
?? script/pursuit_projectile.gd.uid
?? script/retrofit_learning_game.gd
?? script/retrofit_learning_game.gd.uid
?? script/rich_learning_loader.gd
?? script/rich_learning_loader.gd.uid
?? script/rich_learning_session.gd
?? script/rich_learning_session.gd.uid
?? script/rich_review_panel.gd
?? script/rich_review_panel.gd.uid
?? tests/learning_partial_submission_test.gd
?? tests/learning_partial_submission_test.gd.uid
?? tests/learning_retrofit_core_test.gd
?? tests/learning_retrofit_core_test.gd.uid
?? tests/learning_retrofit_test.py
?? tests/learning_retrofit_ui_test.gd
?? tests/learning_retrofit_ui_test.gd.uid
?? tools/__pycache__/
?? tools/export_learning_retrofit.py
?? tools/render_learning_editorial_review.py
```

This completion report is also an untracked local document. Prior uncommitted retrofit files and Python cache entries remain in the working tree; no publication was performed.
