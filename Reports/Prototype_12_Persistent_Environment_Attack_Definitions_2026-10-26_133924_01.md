# Prototype 12 - Persistent Orbital Environment and Attack Definitions

Created: 2026-10-26T13:39:24-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_12_Persistent_Environment_Attack_Definitions_2026-10-26_133924_01.md`.
Status: Implemented and locally verified; awaiting owner visual review. No Git publication authorized or performed.

## Scope and preservation

- Branch: `feature/prototype12-martian-defense`; HEAD remains `bd807108370d37e89c1d032602b2e7a937f96437`.
- Accepted Prototype 11 gameplay/tag: `27ef7e8995de8a4270a548086614fabf52a7e6e4` / `planetary-prototype11-complete-v1`; annotated tag object remains `76a1775edc5aebd31311237d7a29dd1facf547c4`.
- Existing Prototype 12 source, UID files, scene, main-scene configuration, tests and reports were inspected and retained. The earlier Prototype 12 report and untracked Prototype 11 final audit report remain byte-for-byte unchanged.
- All accepted Prototype 11 source/data/scenes/tests/assets hash-identical to the recorded baseline. The sole existing tracked difference is the previously accepted P12 main-scene setting in `project.godot`; it was not changed by this follow-up.
- All recorded prior branch references (including main) and accepted tag objects remain unchanged. No programmer artwork branch was modified. Index is empty.
- Pre-edit uncommitted-work preservation ZIP: `C:\Users\azwam\Projects\Backups\ODC_P12_before_persistence_20261026_132621.zip`. SHA-256: `2047473b91665b09946d8c9ebbdcb2d955616e7a8cadad9b53cea4422e9fb3f7`. Only the three listed P12 scripts differ from this snapshot; no earlier work was discarded.
- No commit, tag, push, merge, reset, stash, or discard occurred.

## Exact files changed by this follow-up

1. `script/martian_learning_session.gd`: persistent physical-target registry; question/slot bindings; captured shot identity; final physical outcome storage; explicit restart restoration.
2. `script/martian_orbital_display.gd`: registry-based visibility; distinct replacement markers/identity captions; retained previously participating centers on later-round configuration.
3. `script/martian_learning_game.gd`: physical visibility projection and attack-name hover/click controls using the existing explanation box; physical identity in Report contact tooltips.
4. New `tests/prototype12_persistence_test.gd` and Godot-generated `.gd.uid`: 299 focused model/rendered/input checks.
5. This new report. No catalog, question-bank, original P11 source, scene, artwork, scoring, or deadline edits were required.

## Root cause and physical identity model

Previously, marker visibility depended on `session.results[contact_slot].projectile_outcome`. Advancing a round intentionally clears that current-round results dictionary. As a result, hiding a destroyed target lasted only until the next round. `next_round()` also restored temporary original-actor visibility before showing the new questions. No permanent learning physical-state registry existed.

The P12 session now owns three separate identity layers:

- Learning question: existing stable `learning_id`, such as `R01/P11-BANK-VIRUS`, retained in grading and historical results.
- Contact slot: existing integer contact ID/data-center association used to read the accepted moving orbital source. Slots may be reused between rounds.
- Physical target: stable string identity, such as `DC-01/C-002/P01`. `physical_targets` is keyed by this identity and stores slot, center, version, alive flag, and latest physical outcome. `physical_slots` maps a slot to its current physical target; `question_targets` binds each question to its physical target for the entire session.

The initial environment registers all 18 existing display slots without creating or changing canonical P10 contact records. A HIT sets only that learning physical record's `alive` flag to false, permanently until explicit learning restart. MISS and EVADED retain the same live identity and orbital source. Unanswered contacts remain alive and visible. Reopening Analyze/Report never rebinds a question that already has a target.

### Later rounds and replacement targets

The accepted 5/5/2 plan, seeded question selection, scoring, histories, and deadlines are unchanged. When a new question reuses a surviving slot, it refers to that same surviving physical target. When its slot's previous target was destroyed, it introduces a new physical identity (`P02`, then `P03` if needed) and leaves the old physical record dead. The destroyed marker is hidden and removed rather than made visible again. New markers are clearly captioned `C-002 / P2`; their tooltip gives the full physical ID. Report contact tooltips also identify the current or historical physical target.

No survivor is deleted to make space. New targets reuse the slot's read-only accepted trajectory source and center association; orbital physics and speeds are untouched. The physical identity is captured in scheduled-shot snapshots and carried into evaluated results and historical/all-results records. Duplicate impact callbacks remain rejected by the inherited generation/results guards.

All one/two/three-center layouts read the same registry. Manual RESET TO 1 DATA CENTER changes only the view. Later-round default layouts retain centers that participated in earlier questions, including centers without a question in the final two-question round. Historical review neither binds new targets nor changes physical state. Explicit RESTART LEARNING SESSION clears physical records/question bindings and restores the initial live environment alongside the existing learning reset; it does not reset canonical P10 movement.

### Grading remains independent

`hit`/`answer_correct` retain cybersecurity answer correctness. `projectile_outcome` remains HIT, MISS, or EVADED. Only physical HIT marks a target dead and the learning question neutralized; a correct-but-evaded answer still receives its correct learning grade while its target survives. P10 official score, canonical event ledger, private truth, operational outcomes, and original deadlines are unchanged.

## Attack definitions

Inspected the committed `data/cyber_catalog.json` and validated question bank. Attack records contain `ID`, `attack_name`, `definition`, `difficulty`, `severity`, and `priority_rank`. The authoritative descriptive field available in this export is `attacks[].definition`; the bank references attacks by `attack_id` and does not provide a separate longer description. These catalog definitions are sometimes brief; no longer text was invented or inferred from labels.

All 100 attack records have a nonempty definition; no catalog records require the missing-description fallback. Maximum current definition length is 74 characters. The fallback is nevertheless tested: `No description available in the current catalog.`

Report attack names are now flat buttons with hover and click handlers bound to the actual question's attack ID, including after sorting and during historical review. They show `attack_name`, newline, and the exact full `definition` text in the existing 34-pixel wrapped Label inside the same dark, 3-pixel red-bordered box. Example: `ROOTKIT` / `Hides malicious processes.` The text is unchanged from the catalog. No defense mapping, answer key, or correctness status is included in an attack explanation. Hover does not select an answer. Existing countermeasure hover excerpts and post-evaluation explanations remain unchanged.

## Verification commands and actual results

Godot executable: `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe` (4.7.2 stable Mono).

All Godot checks ran sequentially. Final run: **29/29 verification steps passed**, including all 22 GDScript suites. Existing regression scripts/assertions were not edited. The new suite passed **299 checks**; the original P12 suite passed **106 checks** unchanged.

Commands (run from repository root; `godot` below means the full executable above):

```powershell
python tests/cyber_catalog_test.py
godot --path . --position 0,0 --script res://tests/prototype3_test.gd
# For every other suite in the table, in the displayed order:
godot --path . --script res://tests/<suite>_test.gd
godot --headless --editor --path . --import
godot --path . --quit-after 120
godot --path . res://scene/learning_command.tscn --quit-after 120
godot --path . res://scene/direct_command.tscn --quit-after 120
godot --path . res://scene/game.tscn --quit-after 120
git diff --check
```

Exact argument arrays, exit codes and per-step results: `C:\Users\azwam\AppData\Local\Temp\odc_p12_persistence_review_2026-10-26_133726\test_logs\results.json`. Sequential runner copy: `C:\Users\azwam\AppData\Local\Temp\odc_p12_persistence_review_2026-10-26_133726\run_sequential_checks.py`. Individual stdout/stderr logs are in `C:\Users\azwam\AppData\Local\Temp\odc_p12_persistence_review_2026-10-26_133726\test_logs`.

| Check / suite | Actual result |
|---|---|
| `catalog` | CYBER CATALOG: PASS; reproducible exact export, declared schema, manual mappings and unchanged source hash verified |
| `prototype3` | PROTOTYPE 3 TEST: PASS (0 failures) |
| `prototype4` | PROTOTYPE 4 TEST: PASS (0 failures; 13048 checks) |
| `prototype5` | PROTOTYPE 5 TEST: PASS (0 failures; 992 checks) |
| `prototype6` | PROTOTYPE 6 TEST: PASS (0 failures; 229 checks) |
| `prototype7` | PROTOTYPE 7 TEST: PASS (0 failures; 241 checks) |
| `prototype8` | PROTOTYPE 8 TEST: PASS (0 failures; 1748 checks) |
| `prototype9` | PROTOTYPE 9 TEST: PASS (0 failures; 311 checks) |
| `prototype9_corrections` | PROTOTYPE 9 CORRECTIONS: PASS (0 failures; 266 checks) |
| `prototype9_cyber` | PROTOTYPE 9 CYBER: PASS (0 failures; 361 checks) |
| `prototype9_decision` | PROTOTYPE 9 DECISION: PASS (0 failures; 233 checks) |
| `prototype10_stage1` | PROTOTYPE 10 STAGE 1: PASS (0 failures; 71 checks) |
| `prototype10_stage2` | PROTOTYPE 10 STAGE 2: PASS (0 failures; 121 checks) |
| `prototype10_stage3` | PROTOTYPE 10 STAGE 3: PASS (0 failures; 234 checks) |
| `prototype10_stage4` | PROTOTYPE 10 STAGE 4: PASS (0 failures; 84 checks) |
| `prototype11` | PROTOTYPE 11: PASS (0 failures; 145 checks) |
| `prototype11_refinements` | PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| `prototype11_multicenter` | PROTOTYPE 11 TIME VARIETY MULTICENTER: PASS (0 failures; 229 checks) |
| `prototype11_continuity` | PROTOTYPE 11 GAMEPLAY CONTINUITY: PASS (0 failures; 174 checks) |
| `prototype11_manual_sort` | PROTOTYPE 11 MANUAL RESET TIMER SORTING: PASS (0 failures; 302 checks) |
| `prototype11_ar_effects` | PROTOTYPE 11 AR PROJECTILE EXPLOSION: PASS (0 failures; 55 checks) |
| `prototype12` | PROTOTYPE 12 MARTIAN DEFENSE: PASS (0 failures; 106 checks) |
| `prototype12_persistence` | PROTOTYPE 12 PERSISTENCE: PASS (0 failures; 299 checks) |
| `import` | PASS (exit 0; no script/parse errors) |
| `main_startup` | PASS (exit 0; no script/parse errors) |
| `prototype11_startup` | PASS (exit 0; no script/parse errors) |
| `prototype10_startup` | PASS (exit 0; no script/parse errors) |
| `standalone_startup` | PASS (exit 0; no script/parse errors) |
| `diff_check` | PASS (exit 0; no script/parse errors) |

Focused checks cover HIT removal across rounds 1/2/3; EVADED/MISS/unanswered survival; forced reuse of every slot at one center; distinct replacement IDs; retained destroyed records; new questions bound to live targets; initial environment restoration only on restart; one/two/three-center consistency; manual reset; historical immutability; all 100 catalog descriptions; hover/click; fallback; no answer disclosure; unchanged countermeasure definitions; and canonical-score/event invariance. Existing P12 checks additionally verify warnings, mute/alarm, evasion, 18-second flights, NEXT ROUND and cumulative grading/history.

### Earlier test attempts, retained for accuracy

Before the successful final run, rendered P3 at `--position 3000,2000` failed four real-time checks for attacker 1 (two inward jumps, inner ring, continued inner orbit, no jump past inner ring); an unchanged retry had the same result. An attempted headless run failed 12 hover/selection checks, so headless was not used as a substitute for rendered mouse verification. The rendered test passed unchanged at `--position 0,0`, both as a standalone retry and in the final complete run. No accepted assertions or movement code were altered. Window/input/environment sensitivity remains a regression-harness limitation; the precise underlying cause was not proven. Preserved logs: `prototype3_rendered_failure.log` and `prototype3_headless_failure.log` in the test-log directory.

Negative-fixture error messages in passing regression logs are expected validation cases, not suppressed failures. Import and all four startup checks exited 0 without script/parse errors. Main starts P12; P11, detailed P10 and standalone tactical scenes remain independently runnable.

## Rendered verification and screenshots

Godot rendered at 1600 x 900 using its isolated test viewport and injected mouse input; screenshots were captured and visually inspected. This was not a manual native-desktop playthrough. All six PNG dimensions verified as 1600 x 900. Review directory: `C:\Users\azwam\AppData\Local\Temp\odc_p12_persistence_review_2026-10-26_133726`.

1. `p12_persistent_round1_before.png`: initial three-center environment before firing.
2. `p12_persistent_round1_after.png`: two HIT targets removed; two MISS and one EVADED target survive; 3 correct / 2 incorrect grades retained.
3. `p12_persistent_round2.png`: original survivors remain and destroyed targets remain absent.
4. `p12_persistent_round3.png`: accumulated environment remains; a necessary new replacement is visibly identified as P2, rather than reviving P1.
5. `p12_attack_definition.png`: ROOTKIT's catalog definition in the existing red-bordered 34-pixel box.
6. `p12_countermeasure_definition.png`: unchanged Backups explanation in the same box for comparison.

Inspected definition text, wrapping, red border, all nine Report columns, answer/result access, three distinct center tiles, manual reset, target disappearance/survival and replacement identity captions. Definition text and Report controls fit without clipping in the captured views. Some contact captions can overlap when existing orbital paths converge; this pre-existing presentation issue was not redesigned in this focused follow-up.

## Known limitations and scope

- Persistence is in memory for the current learning session; no disk save/load system was added.
- Replacement targets use their associated slot's existing read-only movement source and approved path. They have distinct physical identities but are not new canonical P10 simulation actors.
- Report's compact Contact column keeps the original slot ID; its tooltip and orbital caption distinguish physical generations. Full identities are retained in results/history.
- Definitions are exactly as detailed as the existing authoritative catalog; no expanded educational wording was fabricated.
- Existing strategic pause, late-practice behavior, scoring and physical/knowledge separation are preserved. There are no new combat, timing, grading or operational-scoring rules.
- No outstanding functional test failure in the final run. The earlier P3 invocation sensitivity is documented above.

## Git working-tree status

All work remains local and unstaged. Existing P12 untracked implementation and the preserved P11 audit report remain present. This report is also a new untracked file. Status captured immediately before creating this report:

```text
M project.godot
?? Reports/Prototype_11_Final_Git_Checkpoint_2026-10-25_224608_01.md
?? Reports/Prototype_12_Martian_Defense_2026-10-26_130357_01.md
?? scene/martian_learning_command.tscn
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
?? tests/prototype12_persistence_test.gd
?? tests/prototype12_persistence_test.gd.uid
?? tests/prototype12_test.gd
?? tests/prototype12_test.gd.uid
```

No commit, tag, push, merge, release, reset, stash or discard performed. Stop for owner visual review.
