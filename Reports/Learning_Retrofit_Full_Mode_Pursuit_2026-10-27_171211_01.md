# Full-mode learning retrofit and pursuit presentation

Completed local verification: 2026-10-27T17:12:11-07:00.

## Status and scope

Implemented as a local editorial review build. All 100 attacks, 185 defenses and 211 original mapping pairs have individually authored candidate material. This is not owner acceptance or independent SME approval. All 496 records remain EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED; owner_accepted and production_eligible remain false. Production validation rejects these candidates. No commit, tag, push, merge or release occurred.

Branch: feature/prototype12-martian-defense. HEAD remains b2084113774bc5df268d7f2bfabdd5fdd1d4f626. Local branch/tag refs unchanged. No staged files.

## Preservation and ID reconciliation

External pre-edit ZIP: C:\Users\azwam\Projects\Backups\ODC_before_learning_retrofit_20261027_161634.zip

ZIP SHA-256: b5aef380a7cfc4f27fecd78fbd0ef41ff139be793b70ef3717b45652d1795906

270 pre-existing files were hash-compared; none are missing. Only project.godot and script/six_center_learning_game.gd changed among them. All pre-existing reports, reconciliation inputs, question-bank fixtures, accepted tests, original evaluator/session/scoring/deadline code and canonical catalog remain intact. The source databases were opened read-only.

Canonical source: C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db. SHA-256: 22867011a01db80a8766e7320d58aece09373f783a06700a97197c254eb6a871

Editorial draft SHA-256: 73ba2ab75cddad7213d1ca0c1c27ceadec4ea2d90720799b3d4ed23b628701ec

Exact attack-name reconciliation and the six owner-authorized defense aliases produce one-to-one 100/185 crosswalks and all 211 corresponding pairs. Draft IDs are provenance only; runtime references use canonical IDs. The exporter does not join bare numeric IDs across databases. Runtime validates canonical names and references; Python additionally validates the entire input crosswalk and provenance. All original relationships remain unchanged.

## Content and outstanding editorial decisions

Each attack has a full display name, mechanism definition, scenario-specific question, designated mapped answer, three curated unmapped distractors, answer reasoning, option contrast, and distinct realistic example. Each defense has a full display name, definition, mechanism, conditions, limitations and example. Each mapping has its own role, applicability and limitation/rationale. No generic placeholder entries remain in this authored candidate set. Automated completeness checks do not prove technical approval or distractor fairness.

Mapping judgments: 60 RETAIN; 133 QUALIFY; 15 CORRECT; 3 REMOVE_PROPOSED. Roles: 72 direct controls, 93 partial mitigations, 27 detection, 19 indirect support. These judgments are annotations, not changes to the canonical mapping graph.

The three removal proposals are canonical mapping 19 (attack 13 wireless jamming / defense 19 backups), mapping 76 (attack 43 rogue access point / defense 74 MAC filtering), and mapping 204 (attack 97 wardriving / defense 179 hiding SSID). None is used as a designated question key. All mapped controls, including weak/removal-proposed ones, are excluded from incorrect answer choices.

Owner/technical review remains required for all questions and the 151 non-RETAIN judgments. Important review topics include source-address validation for reflection, Kerberos versus pass-the-hash, offline salting, modern password KDFs, public bucket authorization versus encryption, conditional VPN/DNS protections, WEP/WPA differences, and modern Kubernetes admission policy. Category, weakness, environmental and legitimate-research records are honestly labeled rather than all described as discrete malicious attacks. See the complete itemized review book and primary-source references.

- Reports/Learning_Retrofit_Editorial_Review.md: all 100 lessons, 185 controls and 211 mapping judgments, readable in canonical-ID order.
- Reports/Learning_Retrofit_Quality.json: itemized required-field checks, categories and mapping exceptions.
- Reports/Learning_Retrofit_Before_After.json: exact draft-before and canonical-ID after records.
- editorial/README.md and editorial/REFERENCES.md: schema, approval policy, bounded-question rules and primary technical references.

## Deterministic export and full-mode integration

Run from the repository:

```powershell
python tools/export_learning_retrofit.py --source C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db --draft cyber_100_attacks_learning_draft.db
python tests/learning_retrofit_test.py
python tools/render_learning_editorial_review.py
```

The additive data/learning_retrofit.json is deterministic for identical inputs. The original SQLite tables and data/cyber_catalog.json are unchanged. All 100 curated canonical attacks are eligible; a session still chooses 22 distinct attacks with the existing seeded 5/5/5/5/2 round structure. No old fixture bank participates in the new main scene. Forty deterministic sample seeds reached all 100 attacks in tests. Other legitimate mapped defenses are never offered as incorrect options. Narrow scenario scope and explicit contrast, rather than absent mapping alone, explain distractors.

F5 now starts res://scene/learning_retrofit_command.tscn. The accepted Prototype 12 scene remains res://scene/correct_only_learning_command.tscn; Prototype 10 remains res://scene/direct_command.tscn. The only legacy script change is a loader factory whose default is the original loader.

Owner walkthrough: open A, choose YES, then click an attack or QUESTION & LESSON in Report. Read the full scenario, definition and realistic example; select a control to inspect its full mechanism/conditions/limitations. Close the lesson and use the existing Report submission or D/WAIT path. Selection alone never grades or fires. Reopen the lesson after authoritative submission/evaluation to read answer reasoning, option contrast and annotated mapping limitations. R/history and missed-question review use the same full-content panel; historical views are read-only and missed review stays noncombat. Escape/upper-right Close dismiss the lesson. Fixed-seed reproduction: append -- --odc-learning-seed=12345 to the Godot invocation.

The compact nine-column board retains short canonical choice labels where useful; complete expanded control names and text are in the 20-pixel scrollable lesson area. Questions wrap at 22 pixels, full-name choices have their own 2-by-2 layout, and scrolling does not reset during UI refresh. No content is reduced to checkerboard-sized explanations.

## Result wording and animation

Incorrect live statuses now read INCORRECT ANSWER — MISSILE NOT LAUNCHED. They never contain a contradictory launched status. Confirmed hit status retains CORRECT ANSWER — MISSILE LAUNCHED — THREAT DISABLED.

Only the new learning presentation replaces zigzag with continuous, mostly outward target travel. The missile uses a fast initial closing curve, tracks the rendered moving target, and reaches it on an assigned HIT. A successful recorded evasion travels toward its own tile boundary, exits late in the pursuit, and leaves a visible following gap; it never changes the grade or random roll. Captions are constrained inside their owning tile.

Flight duration stays 36 simulation seconds, launch spacing stays 15 seconds, and existing hit/miss effect durations remain unchanged. Trail samples fade over 8 simulation seconds and fade/clear after effects. Pause freezes pursuit/trail simulation time. Escape survivors remain alive in the physical registry; if reused for a later learning question, they visibly reenter from their own tile edge over four seconds. HIT targets remain removed. Cosmetic departure is not a canonical operational resolution.

No new RNG draws, scoring formulas, mission outcomes, deadlines, hidden-truth inference or command evaluator changes were introduced. The existing Report CLOSE/SUBMIT interaction issue from the prior checkpoint was not redesigned in this task.

## Verification

All 38 sequential verification steps passed. Existing regression assertions were unchanged. Rendered tests used Godot 4.7.2 Mono at 1600 × 900, on the actual Vulkan renderer. This was automated rendered input/viewport verification, not a manual native-desktop playthrough or owner visual acceptance. Expected error logs in older negative-configuration tests are deliberate fixtures; no new parse/script errors occurred.

| Check | Result / evidence |
|---|---|
| catalog | PASS; exit 0; CYBER CATALOG: PASS; reproducible exact export, declared schema, manual mappings and unchanged source hash verified |
| editorial_validation | PASS; exit 0; LEARNING RETROFIT: PASS (814 checks); 100/185/211; production blocked pending owner acceptance |
| prototype3 | PASS; exit 0; PROTOTYPE 3 TEST: PASS (0 failures) |
| prototype4 | PASS; exit 0; PROTOTYPE 4 TEST: PASS (0 failures; 12976 checks) |
| prototype5 | PASS; exit 0; PROTOTYPE 5 TEST: PASS (0 failures; 992 checks) |
| prototype6 | PASS; exit 0; PROTOTYPE 6 TEST: PASS (0 failures; 229 checks) |
| prototype7 | PASS; exit 0; PROTOTYPE 7 TEST: PASS (0 failures; 241 checks) |
| prototype8 | PASS; exit 0; PROTOTYPE 8 TEST: PASS (0 failures; 1748 checks) |
| prototype9 | PASS; exit 0; PROTOTYPE 9 TEST: PASS (0 failures; 311 checks) |
| prototype9_corrections | PASS; exit 0; PROTOTYPE 9 CORRECTIONS: PASS (0 failures; 266 checks) |
| prototype9_cyber | PASS; exit 0; PROTOTYPE 9 CYBER: PASS (0 failures; 361 checks) |
| prototype9_decision | PASS; exit 0; PROTOTYPE 9 DECISION: PASS (0 failures; 233 checks) |
| prototype10_stage1 | PASS; exit 0; PROTOTYPE 10 STAGE 1: PASS (0 failures; 71 checks) |
| prototype10_stage2 | PASS; exit 0; PROTOTYPE 10 STAGE 2: PASS (0 failures; 121 checks) |
| prototype10_stage3 | PASS; exit 0; PROTOTYPE 10 STAGE 3: PASS (0 failures; 234 checks) |
| prototype10_stage4 | PASS; exit 0; PROTOTYPE 10 STAGE 4: PASS (0 failures; 84 checks) |
| prototype11 | PASS; exit 0; PROTOTYPE 11: PASS (0 failures; 145 checks) |
| prototype11_refinements | PASS; exit 0; PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| prototype11_multicenter | PASS; exit 0; PROTOTYPE 11 TIME VARIETY MULTICENTER: PASS (0 failures; 229 checks) |
| prototype11_continuity | PASS; exit 0; PROTOTYPE 11 GAMEPLAY CONTINUITY: PASS (0 failures; 174 checks) |
| prototype11_manual_sort | PASS; exit 0; PROTOTYPE 11 MANUAL RESET TIMER SORTING: PASS (0 failures; 302 checks) |
| prototype11_ar_effects | PASS; exit 0; PROTOTYPE 11 AR PROJECTILE EXPLOSION: PASS (0 failures; 55 checks) |
| prototype12 | PASS; exit 0; PROTOTYPE 12 MARTIAN DEFENSE: PASS (0 failures; 106 checks) |
| prototype12_persistence | PASS; exit 0; PROTOTYPE 12 PERSISTENCE: PASS (0 failures; 299 checks) |
| prototype12_six_centers | PASS; exit 0; PROTOTYPE 12 SIX CENTERS: PASS (0 failures; 392 checks) |
| prototype12_correct_only | PASS; exit 0; PROTOTYPE 12 CORRECT ONLY: PASS (0 failures; 169 checks) |
| prototype12_live_status | PASS; exit 0; PROTOTYPE 12 LIVE STATUS: PASS (0 failures; 210 checks) |
| learning_core | PASS; exit 0; LEARNING RETROFIT CORE: PASS (0 failures; 5305 checks) |
| learning_ui | PASS; exit 0; LEARNING RETROFIT UI: PASS (0 failures; 59 checks) |
| import | PASS; exit 0 |
| main_startup | PASS; exit 0 |
| prototype12_six_legacy_startup | PASS; exit 0 |
| prototype12_legacy_startup | PASS; exit 0 |
| prototype11_startup | PASS; exit 0 |
| prototype10_startup | PASS; exit 0 |
| standalone_startup | PASS; exit 0 |
| prototype12_checkpoint_startup | PASS; exit 0 |
| diff_check | PASS; exit 0 |

Complete commands and raw logs: C:\Users\azwam\Projects\Backups\ODC_Learning_Retrofit_Review_20261027_171100. results.json records each exact command. New checks cover wrong-ID joins, aliases, reference integrity, production blocking, full-mode content, fixed seeds, no mapped distractors, noncombat review, wording, pursuit hits/escapes, pause, 36-second boundary/idempotency and trail cleanup. Existing suites cover Prototype 3–12 gameplay, original scoring, physical persistence, evasion and Report behavior.

## Screenshots

C:\Users\azwam\Projects\Backups\ODC_Learning_Retrofit_Review_20261027_171100

Before: before_prototype4_p12_live_report_controls.png and before_prototype4_p12_correct_overlapping.png are captured by unchanged legacy rendered tests against the accepted old scene. After: prototype4_retrofit_report.png, question.png, defense.png, pursuit.png, escape.png, hit.png, reasoning.png, reasoning_scrolled.png, review.png and review_after.png (each after name has the prototype4_retrofit_ prefix). Screenshots were inspected for readable wrapping, panel bounds, scroll access, status wording and outcome depiction. No video or manual desktop playthrough is claimed.

## Exact files changed/created

Existing files modified:

- project.godot
- script/six_center_learning_game.gd

New implementation/editorial/test/report files (Godot UID sidecars included):

- Reports/Learning_Retrofit_Before_After.json
- Reports/Learning_Retrofit_Editorial_Review.md
- Reports/Learning_Retrofit_Quality.json
- data/learning_retrofit.json
- editorial/README.md
- editorial/REFERENCES.md
- editorial/attacks.psv
- editorial/defenses.psv
- editorial/mappings.psv
- scene/learning_retrofit_command.tscn
- script/learning_detail_panel.gd
- script/learning_detail_panel.gd.uid
- script/pursuit_display.gd
- script/pursuit_display.gd.uid
- script/pursuit_projectile.gd
- script/pursuit_projectile.gd.uid
- script/retrofit_learning_game.gd
- script/retrofit_learning_game.gd.uid
- script/rich_learning_loader.gd
- script/rich_learning_loader.gd.uid
- script/rich_learning_session.gd
- script/rich_learning_session.gd.uid
- script/rich_review_panel.gd
- script/rich_review_panel.gd.uid
- tests/learning_retrofit_core_test.gd
- tests/learning_retrofit_core_test.gd.uid
- tests/learning_retrofit_test.py
- tests/learning_retrofit_ui_test.gd
- tests/learning_retrofit_ui_test.gd.uid
- tools/export_learning_retrofit.py
- tools/render_learning_editorial_review.py
- Reports/Learning_Retrofit_Full_Mode_Pursuit_2026-10-27_171211_01.md

Pre-existing untracked owner draft/reconciliation files remain unchanged. Python __pycache__ entries are reproducible local caches, not intended project deliverables. No generated screenshot/log was placed inside the repository.

## Known limitations and owner review

All editorial content is candidate material; owner acceptance and independent technical review remain outstanding. The itemized 151 mapping exceptions are not resolved by silently changing source data. Several catalog records describe broad categories rather than discrete attacks; their questions teach a stated scenario and scope. Unmapped alternatives can still be useful in other contexts, so scenario fairness deserves review. The animation remains an educational visualization, not real-world cyber effects or physical interception physics. Screen-escape is relative to the owning data-center tile.

No merge, commit, tag, push, release or new prototype stage was performed. Stop for owner review.

## Working-tree status

```text
M project.godot
 M script/six_center_learning_game.gd
?? Learning_Content_ID_Reconciliation_2026-10-27_150655.json
?? Learning_Content_ID_Reconciliation_2026-10-27_150655.md
?? Reports/Learning_Content_ID_Reconciliation_2026-10-27_150655.json
?? Reports/Learning_Content_ID_Reconciliation_2026-10-27_150655.md
?? Reports/Learning_Retrofit_Before_After.json
?? Reports/Learning_Retrofit_Editorial_Review.md
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
?? tests/learning_retrofit_core_test.gd
?? tests/learning_retrofit_core_test.gd.uid
?? tests/learning_retrofit_test.py
?? tests/learning_retrofit_ui_test.gd
?? tests/learning_retrofit_ui_test.gd.uid
?? tools/__pycache__/
?? tools/export_learning_retrofit.py
?? tools/render_learning_editorial_review.py
```
