# Prototype 12 internal-threat warning fix

Completed: 2026-10-28T13:57:28-07:00

## Result and root cause

The arrival registry previously listened only to `finish_shot`, so it saw finalized EVADED outcomes but never saw incorrect answers: those are finalized by `record_incorrect` during normal combat submission, with no projectile created.

The Prototype 12 session now delegates incorrect grading to the existing evaluator and then records its authoritative result. Both outcomes share the same first-arrival writer and warning presentation. No UI refresh, timer, Report CLOSE or history view creates arrival records.

## Preservation

- Branch: `feature/prototype12-martian-defense`.
- HEAD unchanged: `68f10377d8d54c7339d54b84486c1476dbec7fce`.
- Main scene unchanged: `res://scene/learning_retrofit_command.tscn`.
- All accepted uncommitted work and prior reports preserved; no original files missing.
- No commit, tag, push, merge, reset, stash, discard or branch switch performed.
- Catalog/editorial data, original grading routine, launch scheduler, projectile motion, evasion calculator and unrelated source files are unchanged from the pre-edit backup.

Verified pre-edit ZIP: `C:\Users\azwam\Projects\Backups\ODC_P12_before_arrival_fix_20261028_134432.zip`

- 331 files; archive CRC and individual source/archive SHA-256 comparisons passed.
- SHA-256: `f47ac6c53729e0f65860eb4be2af4070e36034279264f4de2d121194d76eceac`; archive hash reverified after implementation.
- Per-file manifest: `C:\Users\azwam\Projects\Backups\ODC_P12_before_arrival_fix_20261028_134432.zip.json`.
- Reproducible Git/Godot/Python caches and `.log`/`.tmp` files excluded; earlier backups retained.

## Exact files changed

Modified relative to this task's backup:

1. `script/player_fire_session.gd`: extend the existing authoritative incorrect-result callback, share the first-arrival writer with EVADED completion, and add the cause enum without altering grading or launch eligibility.
2. `script/pursuit_display.gd`: retain the red warning and compromise clarification, include cause in warning metadata tooltip, and draw a native red warning triangle with an exclamation mark. The inspected source had a red warning box but no drawn triangle.

Added:

- `tests/prototype12_unopposed_arrival_test.gd` and `.gd.uid`.
- `tests/prototype12_unopposed_arrival_ui_test.gd` and `.gd.uid`.
- This completion report.

No existing tests were modified. Other modified/untracked files in the final Git status predate this assignment.

## Updated arrival contract

Registry: `session.internal_threats`, keyed by stable `physical_id`. Center query: `internal_for_center(center_id)`, returning sorted defensive copies.

All previous fields are retained: physical/contact/center identity, learning-question and canonical attack provenance, source outcome, simulation timestamp, `state: ARRIVED_INTERNAL` and `compromise_confirmed: false`.

The additive field **arrival_cause** distinguishes:

| Cause | Authoritative trigger | source_outcome |
| --- | --- | --- |
| `EVADED_INTERCEPTION` | A correct answer's launched missile completes with EVADED | `EVADED` |
| `UNOPPOSED_ARRIVAL` | A normal combat question receives its first incorrect evaluation | `NOT LAUNCHED` |

Incorrect arrivals are recorded at the existing incorrect-evaluation time, including the existing D/WAIT path; the evaluation timing was not changed. No missile, launch animation, incoming-shot alarm or evasion RNG draw is created for an incorrect answer.

A repeated callback or another question involving an already-recorded physical threat cannot replace its first-arrival record, cause or timestamp. Counts describe unique physical threats, not question/submission counts. The same physical identity may appear in more than one learning question.

Excluded from arrival creation:

- Unanswered questions, merely selected answers and Report CLOSE.
- Questions left unanswered by a partial submission.
- Correct pending/manual authorizations and airborne shots, including a successful evasion roll before authoritative completion.
- HIT outcomes on a previously unrecorded threat.
- Incorrect retries in the detached, noncombat missed-question review.

Existing arrivals remain through subsequent rounds, mode switching, Report/history and War Room navigation, center changes and completion of all 22 questions. Only the existing explicit learning-session reset clears them. Records remain session-local, with no new disk persistence or resolution mechanic.

The visible message remains:

> Threat has migrated inside your data center infrastructure.

The center/contact identity, red triangle and **Arrival only; compromise not confirmed** clarification are retained. Multiple physical threats retain independent records. Arrival does not mean a successful network compromise; no SIEM, intrusion evaluation, damage, resources or new scoring was implemented.

## Verification

**All 47 sequential verification steps passed** in Godot 4.7.2 Mono.

- Python catalog validation: PASS, including reproducible export and unchanged authoritative source hash/mappings.
- Learning-retrofit/editorial validation: PASS, 814 checks; 100 attacks, 185 defenses, 211 mappings. Approval metadata unchanged.
- Prototype 3-9 regressions, including corrections/cyber/decision: PASS.
- Prototype 10 Stage 1-4 regressions: PASS.
- Prototype 11 and all refinement/multicenter/continuity/sorting/A-R suites: PASS.
- Prototype 12 base/persistence/six-center/correct-only/live-status suites: PASS.
- Learning retrofit core/UI/partial-submission tests: PASS.
- Prior final-enhancement, firing-mode/UI-refinement, final-refinement and internal-arrival tests: PASS.
- New unopposed-arrival headless suite: PASS, **96 checks**. Covers same-center and multiple-center arrivals, all 22 questions, partial unanswered preservation, manual WAIT/airborne/HIT exclusions, no queue or evasion draw for incorrect answers, cause distinction, duplicate/first-arrival protection, stable original grades and noncombat review isolation.
- New rendered unopposed-arrival UI suite: PASS, zero failures. Covers CLOSE without evaluation, reopening/partial submission, correct warning identity and text, absence of missiles/incoming warnings, mode/Report/War Room navigation, return to single-center view and unchanged canonical score/ledger.
- Editor/import, current main scene and legacy compatibility/tactical startup: PASS.
- `git diff --check`: PASS.

The initial new focused test assumed one arrival per incorrect question. It was corrected to assert one entry per unique physical threat, matching the required deduplication contract; production behavior was not weakened to satisfy that assertion. The complete final run passed without script errors.

Full commands, logs and exit codes: `C:\Users\azwam\Projects\Backups\P12_Arrival_Fix_Review_2026-10-28_135004_01\checks`.

- Machine-readable results: `C:\Users\azwam\Projects\Backups\P12_Arrival_Fix_Review_2026-10-28_135004_01\checks\results.json`.
- Sequential runner: `C:\Users\azwam\Projects\Backups\P12_Arrival_Fix_Review_2026-10-28_135004_01\odc_unopposed_run.py`.
- Protected-file/hash comparison: `C:\Users\azwam\Projects\Backups\P12_Arrival_Fix_Review_2026-10-28_135004_01\preservation.json`.

## Rendered evidence

Automated rendered interaction and screenshots inspected at 1600 x 900. No manual native-desktop playthrough is claimed.

- Six-center incorrect-answer warning, triangle, no-launched-missile status: `C:\Users\azwam\Projects\Backups\P12_Arrival_Fix_Review_2026-10-28_135004_01\prototype4_unopposed_arrival_warning.png`.
- Same warning after returning to the affected enlarged center: `C:\Users\azwam\Projects\Backups\P12_Arrival_Fix_Review_2026-10-28_135004_01\prototype4_unopposed_arrival_single_center.png`.

Warning text, identity, triangle, red styling and compromise clarification were inspected for readability and clipping.

## Owner review

Run the project with F5. Analyze, choose an incorrect answer for one question and SUBMIT ANSWERS. Its center should immediately show the arrival warning and MISSILE NOT LAUNCHED status, while unanswered questions remain untouched. Existing EVADED warnings continue to appear only after authoritative missile completion.

No additional gameplay or threat-resolution mechanics were introduced. All changes remain local for owner review.

## Final Git status

```text
 M project.godot
 M script/learning_detail_panel.gd
 M script/pursuit_display.gd
 M script/pursuit_projectile.gd
 M script/retrofit_learning_game.gd
 M script/rich_review_panel.gd
 M script/six_center_display.gd
 M tests/learning_partial_submission_test.gd
 M tests/learning_retrofit_ui_test.gd
?? Reports/Prototype_12_Final_Gameplay_Enhancements_2026-10-28_095328_01.md
?? Reports/Prototype_12_Final_Refinements_2026-10-28_121658_01.md
?? Reports/Prototype_12_Internal_Threat_Warning_Fix_2026-10-28_135728_01.md
?? Reports/Prototype_12_UI_Refinements_2026-10-28_105434_01.md
?? new_projectV2/
?? script/learning_action_icon.gd
?? script/learning_action_icon.gd.uid
?? script/learning_answer_controls.gd
?? script/learning_answer_controls.gd.uid
?? script/learning_weapon_overlay.gd
?? script/learning_weapon_overlay.gd.uid
?? script/martian_war_room.gd
?? script/martian_war_room.gd.uid
?? script/player_fire_session.gd
?? script/player_fire_session.gd.uid
?? tests/prototype12_final_core_test.gd
?? tests/prototype12_final_core_test.gd.uid
?? tests/prototype12_final_refinements_test.gd
?? tests/prototype12_final_refinements_test.gd.uid
?? tests/prototype12_final_ui_test.gd
?? tests/prototype12_final_ui_test.gd.uid
?? tests/prototype12_internal_arrival_test.gd
?? tests/prototype12_internal_arrival_test.gd.uid
?? tests/prototype12_mode_transfer_test.gd
?? tests/prototype12_mode_transfer_test.gd.uid
?? tests/prototype12_ui_refinements_test.gd
?? tests/prototype12_ui_refinements_test.gd.uid
?? tests/prototype12_unopposed_arrival_test.gd
?? tests/prototype12_unopposed_arrival_test.gd.uid
?? tests/prototype12_unopposed_arrival_ui_test.gd
?? tests/prototype12_unopposed_arrival_ui_test.gd.uid
?? tools/__pycache__/
```

Nothing was staged, committed or published.
