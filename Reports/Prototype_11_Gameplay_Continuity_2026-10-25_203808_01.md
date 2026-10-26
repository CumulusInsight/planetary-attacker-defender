# Prototype 11 — Gameplay continuity and Report results

Created: 2026-10-25T20:38:08-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_11_Gameplay_Continuity_2026-10-25_203808_01.md`.
Status: implemented and locally verified; awaiting owner visual review. No commit/publication performed.

## Baseline and preservation

Repository `C:\Users\azwam\Projects\planetary-attacker-defender`; branch `feature/prototype11-simplified-cyber-game`; HEAD and accepted Prototype 10 tag target remain `ee96eebb88d942d9302a9aa740e1414fb931eba1`. Prototype 11 remains uncommitted. A task-start preservation copy/hash manifest is outside the repository at `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_backup_20261025_200738`.

All four pre-existing completion/checkpoint reports match their start-of-task SHA-256 hashes, as do both learning question JSON files, the cybersecurity catalog, projectile script, wrapper scene, existing UID files and the pre-existing `project.godot` change. No Prototype 10 scenes/scripts, movement, operational deadlines, private truths, official scoring or canonical event-ledger implementation changed. No Git history, refs or branch were mutated.

## Exact files changed

Modified:

- `script/learning_question_loader.gd`: preserves the existing seeded first round and creates a complete deterministic nonrepeating 5/5/2 round plan from the unchanged 12-template bank; tags learning identities.
- `script/learning_session.gd`: separate current-round contact-indexed state, immutable completed-round snapshots and cumulative results keyed by learning-question identity; cumulative metrics and guarded round advancement/reset.
- `script/learning_game.gd`: combined A-R control, confirmation-to-Report navigation, nine-column Result rendering, historical selector, manual/automatic view reset, and report/feedback overlap handling.
- `script/learning_orbital_display.gd`: safely hides out-of-view markers when changing between one and multiple center layouts; retains underlying actor state.
- `tests/prototype11_test.gd`, `tests/prototype11_refinements_test.gd`, `tests/prototype11_multicenter_test.gd`: requested A-R/nine-column navigation expectations and a shared rendered Report-opening helper. Existing movement, firing, deadline, mapping, privacy and scoring assertions are retained. No P3–10 assertions changed.

Added:

- `tests/prototype11_continuity_test.gd` and its Godot `.uid`.
- This new timestamped report.

The question bank remains exactly 12 validated templates. No attacks, defenses, mappings or new timing rules were invented.

## A-R navigation

Only the two P11 A/R icons are replaced by one **A-R** button; **D** and every original P10 icon retain their positions and behavior. The former R position is simply unused; no other controls were moved to fill it.

A-R always opens the existing `Analyze the existing threats on all data centers?` question with YES, NO and upper-right Close. NO/Close perform no analysis and open no Report. YES analyzes the current round, closes the question and immediately opens Report. Reopening an unfinished round preserves selections, scores, deadline anchors and seed. The introductory single-target path is now five clicks: A-R -> YES -> choose defense -> D -> FIRE NOW.

When the current round is complete and unused bank questions remain, A-R/YES archives it and opens the next round. During the brief remaining impact animation, next-round confirmation waits until effects finish so contact reuse cannot interrupt a shot. At bank exhaustion A-R/YES reopens final results without silently restarting. The existing Decide/Open Report shortcut can still review the current round without advancing it.

## Round plan, identity and result history

The validated bank is shuffled once using the existing recorded session seed. Its first five question/choice assignments retain the previous seed sequence; remaining templates are assigned to the next two rounds without replacement. Normal play is now:

- Round 1: five questions.
- Round 2: five unused questions.
- Round 3: the final two unused questions.

Each round uses valid source contact/data-center slots, with no more than three participating centers. Contact slots can be reused only after every question in the preceding round has been evaluated and its results archived. The last two-question round naturally uses at most two centers. Original P10 contacts are never deleted or replaced.

Identity is `R<two-digit-round>/<bank-question-id>`, for example `R01/P11-BANK-ROOTKIT`. Current selections/flights/results remain keyed by current contact ID for the existing firing workflow; the cumulative learning-result ledger is keyed by this distinct identity. A result stores round, template, contact, center, actual fired defense, verdict, correct defense and simulation evaluation time. Round-generation tokens reject stale callbacks, even if a later round reuses the same contact ID. Duplicate impacts, navigation and repeated analysis cannot add scores.

On advancement the model stores deep copies of the completed round's questions, choice order, selected answers, results and displayed TIME values. The existing Report's compact upper-right selector offers Current round and completed prior rounds. Historical choices are disabled/read-only; historical review cannot schedule shots or alter current selections. Its TIME values are frozen archival snapshots, identified by a tooltip, rather than live timers for a reused current contact. Current-round primary/Report clocks retain their existing authoritative sources.

The last round remains available as Current round 3; rounds 1 and 2 remain in the selector. After all 12 evaluations, a concise session-complete score is shown in Report and the ordinary feedback area when Report is closed. There is no automatic fourth round or repetition. Existing Restart deliberately clears all learning selections, cumulative scores, histories and pending shots, restores visuals, and replays round 1 of the same seeded plan.

## Scoring and time preservation

The cumulative result ledger is the sole learning score source:

- Correct Answers = evaluated results with a hit.
- Incorrect Answers = total evaluated results minus correct.
- Percentage Correct = 0 before evaluation, otherwise correct / total evaluated * 100.
- Elapsed Time = existing authoritative simulation time minus the original learning-session start.

Advancing rounds does not change the elapsed-time origin or clear earlier grades. Only an actual projectile impact/miss evaluates an answer. Selecting, analyzing, opening history, cancelling a schedule or resetting the view scores nothing. Explicit Restart resets all four metrics. Display percentage retains the existing whole-percent rounding; the model preserves the exact ratio. No P10 official points or events are generated.

The rendered demonstration accumulated 3 correct/2 incorrect in round 1, then 4 correct/1 incorrect in round 2, then 1 correct/1 incorrect in round 3: **8 correct, 4 incorrect, 66.666...%** (displayed 67%). It retained all 12 distinct records. Independent one-center tests deliberately reused all five contact slots and verified that earlier records were unchanged.

Current learning deadlines, operational-deadline priority, pause semantics, late-practice policy, 60/300/600-second waits and immutable scheduled volleys remain unchanged. New-round learning windows start only when that new round is explicitly analyzed; they do not reset any P10 deadline. Existing scheduled snapshots now also carry the learning identity.

## Manual and automatic view reset

A small **RESET VIEW** button is in the lower-left graphics area. It selects one large labeled center: DC-01 if no center was explicitly chosen, otherwise the center selected through the dropdown or contact/answer selection. It modifies only projection/layout state. Answers, completed questions, scores, absolute deadline anchors, elapsed time and underlying actor motion are preserved.

In single-center learning mode the existing top center dropdown selects the shown center. The original P10 callback is retained; outside the learning layer its behavior is unchanged. On returning to P10, the dropdown is synchronized with its original controller context.

A new volley reconstructs the participating center plots before calculating shot origins, so future volleys can again span two or three centers. Each projectile retains its own origin, target and result. Automatic reset waits for all projectiles to finish their unchanged 1.2-second flight and 0.65-second effect, then adds a 0.25-second simulation-time grace period. No layout changes occur during flight or impact. A manual reset requested during these effects is queued rather than moving targets prematurely. The reset follows strategic pause without wall-clock catch-up. If the player temporarily opens P10, an outstanding automatic presentation reset waits until learning view returns.

Feedback is not erased on reset. The ordinary corner feedback remains visible with the large single-center plot. While Report is open, that floating box is hidden because its same results are available in the table; this prevents it from covering the new Result column or Restart button. A pending scheduled countdown is also shown in the Report footer, while the existing Decide/corner controls retain cancellation access.

## Nine-column Report and selected-answer presentation

The Report retains Data Center, Contact, Suspected Attack, Time and the four exact catalog choice names, then adds **RESULT**. Status is NOT ANSWERED, SELECTED, CORRECT or INCORRECT. Before firing, selected choices have the existing blue highlight plus an underline, without correctness disclosure. After evaluation, the actual defense captured in the fired snapshot remains selected and underlined, even if the user had edited a pending draft selection. Correct choices/result text are green, incorrect choices/result text are red; readable verdict text accompanies color.

Hovering or clicking an evaluated Result cell reveals `Correct countermeasure: <catalog name>` in the existing explanation footer; its tooltip also contains the answer after evaluation only. Before evaluation no answer key appears. The existing catalog-description hover behavior for choices and the post-firing educational feedback are retained.

Nine columns fit the unchanged 1600 x 900 Report without horizontal scrolling. Final widths are 88/90/146/100/224/224/224/224/120 pixels plus eight-pixel gaps. Countermeasure text remains 18 pixels; result text is 15 pixels. Contact/attack widths were increased during visual review to avoid adjacent labels appearing joined, and text-fit assertions were added. No unrelated panel was redesigned.

## Verification commands and actual results

Godot 4.7.2 stable Mono; rendered Vulkan/NVIDIA RTX 2070 at 1600 x 900. All required existing suites ran sequentially. After the final Report-only spacing adjustment, the four affected P11 suites plus import/main startup were rerun sequentially and their final logs replaced the earlier ones. P3–10 source/tests were unchanged by that formatting adjustment. P3 retains its established off-desktop rendered-window position to isolate desktop hover input; later suites use isolated rendered viewports.

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
| prototype11 | PROTOTYPE 11: PASS (0 failures; 144 checks) |
| prototype11_refinements | PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| prototype11_multicenter | PROTOTYPE 11 TIME VARIETY MULTICENTER: PASS (0 failures; 229 checks) |
| prototype11_continuity | PROTOTYPE 11 GAMEPLAY CONTINUITY: PASS (0 failures; 173 checks) |
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
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_multicenter_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --script res://tests/prototype11_continuity_test.gd
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --headless --editor --path . --import
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/direct_command.tscn --quit-after 120
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/game.tscn --quit-after 120
git diff --check
```

The new suite covers A-R YES/NO/Close and automatic Report opening; default/manual/queued/automatic view reset; dropdown behavior inside/outside learning; no premature reset; 5/5/2 seed-reproducible progression; no repeated templates; deliberate contact reuse; stale-callback and duplicate-result rejection; cumulative scores/time; selected underlines and grade colors; post-evaluation answer discovery; historical review/locking; scheduled volley pause/cancellation; all 12 questions; final summary and explicit Restart. It compares P10 official score, operations events and cyber evaluator views before/after the complete flow.

An early implementation diagnostic found that the navigation builder still iterated three slots after A/R were combined; the loop was corrected to use the new specification size. This was not counted as a passing run. Screenshot review then caught the feedback box covering the Report and tightened column spacing; those presentation issues were corrected before final passing verification. No scoring/evaluator or existing P3–10 assertions were changed to obtain passing results. Long waits remain covered by deterministic clock tests, not a claim of ten-minute manual play.

## Screenshots and visual verification

Review directory: `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808`. Full verification command/output logs are under its `verification_logs` folder.

- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\taskbar.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\analyze.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\selected.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\results.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\multifire.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\single_reset.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\round2.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\history.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_continuity_review_2026-10-25_203808\session_complete.png`

All nine captures were inspected at the reference resolution. They show A-R with unchanged P10 controls, the Analyze question, five underlined selections, green/red results with the missed answer explanation, three-center firing, the large single-center reset with persistent feedback, five different second-round questions, read-only completed-round rows, and the two-question final score. All nine columns and Close/Restart controls are visible without horizontal scrolling or an overlapping feedback box. These are actual rendered viewport tests and screenshot inspection, not a manual native-desktop playthrough.

## Known limitations

- Results/history are retained in memory for this application session, not persisted across application closure. The existing seed/plan manifest is still recorded locally for reproduction.
- The finite bank remains 12 templates. Replay after exhaustion requires the explicit Restart control; no extra attacks or catalog relationships were added.
- A reset requested during live firing/effects is queued for animation safety, and the short automatic grace period follows simulation time. Explicit strategic pause can therefore postpone the visual reset.
- A-R/YES advances when a completed round has unused questions. Review the prior round through the Report selector, or use the existing Decide/Open Report shortcut before advancing.
- Historical TIME is a frozen value from round archival, not a live countdown for a reused contact slot.
- Expired learning questions remain available as late practice under the accepted policy. No operational success, damage, points or penalties are invented.
- Layout was verified at 1600 x 900. Existing P10 pinned panels and simulation behaviors remain unchanged; no general interface redesign or arbitrary-resolution certification is claimed.

## Final Git status and safety

Branch `feature/prototype11-simplified-cyber-game`; HEAD `ee96eebb88d942d9302a9aa740e1414fb931eba1`. The index is empty. Only the seven listed pre-existing source/test files differ from the task-start snapshot. All existing reports, question banks, catalog, projectile code, scenes, UID files and the pre-existing project setting match that inventory. The tracked `project.godot` modification below belongs to the earlier P11 implementation, not this assignment.

```text
M project.godot
?? Reports/Prototype_10_Final_Git_Checkpoint_2026-10-25_145510_01.md
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
?? tests/prototype11_multicenter_test.gd
?? tests/prototype11_multicenter_test.gd.uid
?? tests/prototype11_refinements_test.gd
?? tests/prototype11_refinements_test.gd.uid
?? tests/prototype11_test.gd
?? tests/prototype11_test.gd.uid
```

This new report is one additional untracked file. No commit, tag, push, merge, reset, discard, stash or branch change occurred. Prototype 12 was not started. Stop for owner review.
