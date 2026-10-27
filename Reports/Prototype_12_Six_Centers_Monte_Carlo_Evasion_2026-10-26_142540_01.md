# Prototype 12 - Six Centers, Catalog-Driven Questions and Monte Carlo Evasion

Created: 2026-10-26T14:25:40-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_12_Six_Centers_Monte_Carlo_Evasion_2026-10-26_142540_01.md`.
Implementation status: Complete and locally verified; awaiting owner visual acceptance. No Git publication performed.

## Authorization and preserved baseline

This resumes the earlier stopped assignment using the owner's explicit authorization to construct and validate additional questions from the authoritative catalog. The 12-template bank is retained as a regression fixture, not a session-content limit. The earlier stopped report remains unchanged. The continuation message ends at heading B; implementation follows the fully specified preceding six-center assignment for the remaining requested features.

- Branch: `feature/prototype12-martian-defense`.
- HEAD remains `bd807108370d37e89c1d032602b2e7a937f96437`.
- Accepted P11 tag `planetary-prototype11-complete-v1` still resolves to `27ef7e8995de8a4270a548086614fabf52a7e6e4`; annotated object remains `76a1775edc5aebd31311237d7a29dd1facf547c4`.
- Verified all recorded prior branch/tag references unchanged, including main. No programmer artwork branch changes.
- All pre-existing P12 implementation, tests, scenes, UID files, banks, catalog, reports and P11 audit report match the pre-edit ZIP byte-for-byte. The only changed pre-existing file is `project.godot`, selecting the expanded main scene.
- Accepted P11 source, scenes, data, assets and tests remain hash-identical to the recorded baseline; its sole tracked project-setting difference is the pre-existing P12 main-scene change, now updated to the expanded wrapper.
- Nothing staged. No commit, tag, push, merge, reset, stash, discard or release.

External pre-edit ZIP: `C:\Users\azwam\Projects\Backups\ODC_P12_catalog_resume_20261026_140032.zip`.
SHA-256: `26740c7969bdbd78af814b6cf14b320b161a220dbab872e458ae56e76dd3fb74`.
ZIP CRC validation passed; backup was created before editing and preserved all tracked/nonignored project files, including uncommitted P12 work and reports. Git metadata and reproducible ignored caches are excluded.

## Exact files created/modified

Modified:

- `project.godot`: main scene is `res://scene/six_center_learning_command.tscn`.

Created (each GDScript has its corresponding Godot-generated `.gd.uid`):

- `scene/six_center_learning_command.tscn`: expanded P12 wrapper around the same accepted detailed command-center scene.
- `script/catalog_learning_loader.gd`: validated catalog-to-question adapter and 22-question seeded plan.
- `script/monte_carlo_session.gd`: independent seeded evasion stream, immutable per-shot trials and recorded physical/knowledge outcomes.
- `script/monte_carlo_projectile.gd`: 36-second learning projectile and outcome-controlled evasion trajectory.
- `script/six_center_display.gd`: one/two/three/six-center projection, target selection, contained zigzag offset/trail, source-art reuse and manual layouts.
- `script/monte_carlo_panel.gd`: EVADE ALL; no individual incoming-contact selector; per-target and aggregate outcomes; inherited warning/alarm/mute.
- `script/six_center_learning_game.gd`: expanded learning contacts/profiles, navigation, launch/reset/round orchestration, shared-clock deadlines and historical evasion details.
- `tests/prototype12_six_centers_test.gd`: 392 focused checks including rendered/input verification.
- This new completion report.

Earlier P12 scripts/scenes/tests were preserved rather than rewritten. The earlier three-center P12 scene remains independently runnable as a compatibility/regression fixture. F5 launches the expanded implementation.

## Authoritative catalog and generated questions

Inspected `data/cyber_catalog.json`, `script/learning_question_loader.gd`, `script/cyber_data.gd`, `tools/export_cyber_catalog.py` and Python catalog validation. The export contains 100 attacks, 185 defenses and 211 mappings. Its source SQLite SHA-256 remains `22867011a01db80a8766e7320d58aece09373f783a06700a97197c254eb6a871`. No SQLite database or catalog modification was made.

The existing loader reads/validates the committed export. The adapter considers attack IDs in sorted order and obtains names/descriptions from `attacks[ID].attack_name` / `.definition`. Defense names/descriptions use the exact defense records. For each eligible attack:

1. Collect all catalog-mapped defense IDs and all distinct unmapped IDs.
2. Exclude attacks with no mapped defense, no description, or fewer than three distinct unmapped distractors; record the specific reason.
3. Use the seeded question RNG to designate one mapped defense and choose three distinct unmapped distractors.
4. Shuffle these four IDs deterministically. Other valid mapped defenses are never labeled incorrect.
5. Run the inherited bank validator over all generated candidates: unique question/attack IDs, real IDs, exactly four unique options, one designated mapped answer, no mapped distractor, and a valid explicit deadline.
6. Shuffle the eligible pool, select 22 distinct attacks, and create rounds **5 / 5 / 5 / 5 / 2**.

Actual catalog eligibility: **100 eligible, zero excluded**. A negative fixture removes one attack's mappings in an in-memory copy and verifies exclusion with a reason; the authoritative catalog is untouched. A different seed changes the attack selection/options. The question set and answer keys remain fixed throughout an active session.

Generated questions have stable `P12-CATALOG-NNN` question IDs and the existing round-prefixed `learning_id`. The generated answer is the one catalog-mapped choice among the displayed options; it is not a claim that this is the only useful real-world defense or that a mapping guarantees operational effectiveness. No new attack-defense relationship or original cyber evaluator rule was created.

The original `data/learning_questions.json` and `data/learning_question_bank.json` remain unchanged and are exercised by accepted regression tests. The full catalog, not either fixture's length, determines eligible learning content.

### Session/deadline/round policy

The normal application records a fresh seed. `--odc-learning-seed=12345` enables deterministic reproduction. A public reproduction record at `user://prototype12_catalog_session.json` contains session/evasion seeds, catalog hash, eligibility and selected question/contact/option IDs; it omits answer keys.

Each new catalog question explicitly receives `learning_deadline_seconds = 300 + 30 * (attack_id % 8)` (300..510 simulation seconds). These are isolated learning opportunities, not original P10 attack deadlines. The inherited deadline ownership check is retained for existing contacts; no new canonical deadline is invented. All countdowns, scheduling, movement and evasion use `command.operations.session.now` through `session.now`.

NEXT ROUND archives the completed questions, selections, time snapshots and full result fields. It is available only after all current questions/effects finish and unused questions remain. A does not silently advance a completed round. R reopens current/history; the nine sortable columns, selected-answer highlighting, 34px definitions and cumulative grading remain. RESTART resets only learning-session state and restarts the evasion RNG for reproducibility. A normal fresh launch chooses a new seed.

Because each round contains at most five questions, a volley has at most five eligible learning targets, even though all six centers are supported and visible. The 22-question plan rotates assignments across all six; it does not fabricate a sixth question for a five-question round.

### Seed 12345 example selection (developer reproduction)

Exact public plan: `C:\Users\azwam\AppData\Local\Temp\odc_p12_six_review_2026-10-26_142026\seed_12345_public_plan.json`.

| Round | Center / contact slot | Catalog attack ID | Exact catalog name |
|---|---|---:|---|
| 1 | DC-01 / C-002 | 91 | IMPERSON |
| 1 | DC-02 / C-005 | 68 | RAT |
| 1 | DC-03 / C-008 | 93 | TAILGATE |
| 1 | DC-04 / C-401 | 44 | KEYLOG |
| 1 | DC-05 / C-501 | 9 | SPYWARE |
| 2 | DC-06 / C-601 | 96 | PHYSBRUF |
| 2 | DC-01 / C-003 | 49 | CSRF |
| 2 | DC-02 / C-006 | 21 | ENVIRO |
| 2 | DC-03 / C-009 | 61 | ZERO |
| 2 | DC-04 / C-402 | 75 | WATERING |
| 3 | DC-05 / C-502 | 1 | VM ESC |
| 3 | DC-06 / C-602 | 31 | SESS HIJAC |
| 3 | DC-01 / C-010 | 13 | WIRELESS |
| 3 | DC-02 / C-013 | 52 | RAINBOW |
| 3 | DC-03 / C-016 | 41 | PASS SPRAY |
| 4 | DC-04 / C-403 | 2 | ROOTKIT |
| 4 | DC-05 / C-503 | 73 | IoT DDoS |
| 4 | DC-06 / C-603 | 46 | BRUTE |
| 4 | DC-01 / C-011 | 37 | WPA |
| 4 | DC-02 / C-014 | 12 | CHOSENTXT |
| 5 | DC-03 / C-017 | 16 | PRETEXT |
| 5 | DC-04 / C-404 | 50 | RFID |

## Six-center learning environment and persistence

P10 retains its original three canonical centers and eighteen contacts. The expanded P12 layer has six learning centers and 36 learning contact slots:

- DC-01..DC-03 retain the original public contact/center associations and reuse source artwork where available.
- DC-04 has C-401..C-406; DC-05 C-501..C-506; DC-06 C-601..C-606. These are learning-only contacts, not additions to canonical P10 registry/scenarios.
- New-center profiles use the accepted angular-rate set 0.49/0.63/0.77 radians per simulation second, explicit phases and fixed surveillance circles of radius 160/280/400. They are visual learning trajectories, not validated gravitational orbits.
- First-three-center learning profiles copy the original starting angle/progress/ring/speed or ellipse parameters and follow the same movement formula. No canonical actor coordinates, speeds, hover state, truth or outcome are written.

The display occupies x=20..1218. Six overview is three columns by two rows in DC-01/DC-02/DC-03, then DC-04/DC-05/DC-06 order. Bottom space is reserved for manual RESET TO 1 DATA CENTER. The warning panel begins at x=1232 and does not overlap the tiles. One/two/three-center layouts remain supported. `Learning DC-XX` selects any of six enlarged views; `6 CENTERS` restores the overview. These are learning-graphics controls, not new permanent taskbar icons. Layout changes during flight/effects are blocked or deferred by the existing manual-reset rule so shot coordinates are not invalidated. No automatic post-volley reset was reintroduced.

The existing persistent physical registry remains authoritative: question identity, reusable contact slot and physical ID are separate. Only a physical HIT marks its physical record dead. EVADED, MISS and unanswered targets remain alive across all five rounds, view selection and Report history. Necessary replacements receive a new physical generation; the destroyed identity remains dead. Correct-hit TIME projects 00:00; surviving/incorrect threats keep their real learning countdown. Original P10 deadline owners are not zeroed or resolved by learning hits.

## Projectile timing and zigzag presentation

Current main-mode flight is **36 simulation seconds**, previously 18. Progress is continuously `clamp((now - fired_at) / 36, 0, 1)`: no launch delay. Homing uses the moving display target each step. All shots in a volley launch at the same clock value; WAIT 60/300/600 seconds and cancellation are unchanged. The accepted hit effect radius and 1.95-second duration, and miss effect, remain unchanged.

Every attempted target maneuvers, whether its trial succeeds or fails. The visual offset is lateral to its center-to-target incoming direction, alternates smoothly with a 1.4-second period, ramps in over 0.4 seconds, and reaches up to 30% of the smaller tile dimension. Position and trail points are clamped inside the owning tile. An amber trail exposes the alternating zigzag path. Survivors interpolate back to their normal trajectory after passage; this offset does not modify canonical movement or determine success.

Pause handling was verified independently from canonical movement. The old canonical pause intentionally freezes only its active encounter actors; some background actors keep moving. Therefore the new learning projection uses copied orbit profiles and one shared simulation-clock delta rather than reading those changing positions every frame. This prevents learning targets from drifting while shots/zigzags are paused. Local learning hover holds only the hovered learning profile without catch-up. Canonical P10 hover/movement rules remain unchanged.

## EVADE ALL and Monte Carlo model

The incoming-shot selector is removed from the expanded panel. EVADE ALL PROJECTILES orders every currently eligible shot, across any participating centers, in stable ascending contact-ID order. Resolved/impacted, already attempted or late-at-boundary shots are rejected; repeated UI refreshes/commands cannot reroll them.

Dedicated RNG initialization:

```text
evasion_seed = session_seed XOR 0x45564144
for each newly accepted shot in ascending contact-ID order:
    roll = evasion_rng.randf()
    success = roll < 0.50
```

Each shot consumes its own independent draw. This stream is separate from question/option shuffling. The same seed and sequence of evasion orders produces identical trials. Rendering, pause, sorting, history and view changes never generate draws. Resetting the learning session resets this dedicated stream.

Each evaluated learning record, including archived rounds, retains `evasion_attempted`, `evasion_probability`, `evasion_roll`, `evasion_success`, `projectile_outcome`, physical identity and unchanged answer correctness. Unattempted shots carry false attempt/success and unavailable probability/roll.

| Cybersecurity answer | Evasion attempt result | Physical outcome | Grade / survival |
|---|---|---|---|
| Correct | Success | EVADED | Correct; target survives; TIME continues |
| Correct | Failure or no attempt | HIT | Correct; physical target removed; TIME 00:00 |
| Incorrect | Success, failure or no attempt | MISS | Incorrect; target survives; TIME continues |

Thus a successful trial against an already-incorrect countermeasure stays a MISS rather than claiming a HIT or changing the grade. Per-target panel lines and aggregate attempts/successes/failures/hits report these separately. Historical Result hover/click details expose the recorded trial/probability after evaluation without adding a tenth column.

Seed 12345 rendered demonstration: five incoming; five attempts; three successful trials; two failures; two physical HITs, one EVADED, two MISSes; learning score remains 3 correct / 2 incorrect (60%). Later correct answers finish the full session at 20 correct / 2 incorrect, displayed as 91% (unrounded fraction 20/22).

## Verification: actual commands and results

Godot: `C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe`, 4.7.2 stable Mono.

**31/31 final verification steps passed**, including all 23 Godot suites. All Godot checks ran sequentially. No existing regression assertions were modified. New focused suite: **392 checks, zero failures**. Earlier P12 suites remain 106 and 299 checks, unchanged.

Commands from repository root (`godot` means the full executable above):

```powershell
python tests/cyber_catalog_test.py
godot --path . --position 0,0 --script res://tests/prototype3_test.gd
# Every other suite in table order:
godot --path . --script res://tests/<suite>_test.gd
godot --headless --editor --path . --import
godot --path . --quit-after 120
godot --path . res://scene/martian_learning_command.tscn --quit-after 120
godot --path . res://scene/learning_command.tscn --quit-after 120
godot --path . res://scene/direct_command.tscn --quit-after 120
godot --path . res://scene/game.tscn --quit-after 120
git diff --check
# Additional successful seeded startup for the saved public reproduction plan:
godot --path . --quit-after 120 -- --odc-learning-seed=12345
```

Exact argument arrays/results: `C:\Users\azwam\AppData\Local\Temp\odc_p12_six_review_2026-10-26_142026\test_logs\results.json`. Logs: `C:\Users\azwam\AppData\Local\Temp\odc_p12_six_review_2026-10-26_142026\test_logs`. Sequential runner: `C:\Users\azwam\AppData\Local\Temp\odc_p12_six_review_2026-10-26_142026\run_sequential_checks.py`.

| Verification | Actual result |
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
| `prototype12_six_centers` | PROTOTYPE 12 SIX CENTERS: PASS (0 failures; 392 checks) |
| `import` | PASS (exit 0; no script/parse errors) |
| `main_startup` | PASS (exit 0; no script/parse errors) |
| `prototype12_legacy_startup` | PASS (exit 0; no script/parse errors) |
| `prototype11_startup` | PASS (exit 0; no script/parse errors) |
| `prototype10_startup` | PASS (exit 0; no script/parse errors) |
| `standalone_startup` | PASS (exit 0; no script/parse errors) |
| `diff_check` | PASS (exit 0; no script/parse errors) |

Focused checks cover all generated mappings/unique questions and eligibility exclusion, seed variation/reproduction, 5/5/5/5/2 NEXT progression, all six associations, one/two/three/six layouts, real UI evasion button, five independent trials, controlled zero/partial/all-success seeds, correct and incorrect shots for successful/failed trials, late/duplicate rejection, no rerolls, 36-second boundary, continuous homing, paused zigzag/flight, per-tile bounds, real catalog definitions and wrapped choice geometry, cumulative/historical results, persistent destroyed/surviving identities across all five rounds, restart and P10 official score/canonical event invariance.

Initial focused development checks caught learning-target drift during pause and a test click issued before GridContainer layout completed. The learning-only clock projection fixed the first; the new input test now waits for actual rendered layout before clicking. No accepted suite was weakened. The final full run passed without such failures. Negative-fixture ERROR diagnostics in passing older suites are expected; startup/import had no script/parse errors.

## Rendered screenshots and observations

Actual Godot rendered verification at **1600 x 900**, using an isolated viewport with injected mouse input and explicit simulation-clock fixtures. All nine PNG dimensions verified and images visually inspected. This was not a manual native-desktop playthrough.

Directory: `C:\Users\azwam\AppData\Local\Temp\odc_p12_six_review_2026-10-26_142026`.

- `prototype4_p12_six_overview.png`: labeled 3x2 overview with all six centers and persistent targets.
- `prototype4_p12_six_single.png`: enlarged DC-06, reset hidden.
- `prototype4_p12_six_incoming.png`: five simultaneous incoming projectiles; active warning and EVADE ALL.
- `prototype4_p12_six_evade_all.png`: five accepted attempts, no individual selector.
- `prototype4_p12_six_zigzag.png`: visible alternating trails and tile-contained maneuvers.
- `prototype4_p12_six_mixed.png`: 3 successful/2 failed trials, 2 physical hits, independent grading.
- `prototype4_p12_six_round4.png`: fourth round, accumulated score, catalog-specific wrapped options.
- `prototype4_p12_six_round5.png`: final two unused questions.
- `prototype4_p12_six_final.png`: full 22-question completion, retained selections and cumulative result.

Inspected panel separation, reset access, labels, all nine Report columns, wrapped long catalog defense names, score/result visibility, warning/evasion controls and final round navigation. Tests measured choice bounds to ensure no overlap with the definition area. Warning panel does not cover the six orbital tiles. Some contact captions can converge on inner orbits; this existing small-scale labeling limitation remains, and the enlarged center view is available.

## Launch and owner review

F5 opens `scene/six_center_learning_command.tscn`. A -> YES prepares the first Report, R reopens it, D fires/schedules selected answers. Close Report to see the overview. The learning center selector enlarges any DC-01..DC-06; 6 CENTERS restores the grid. EVADE ALL affects only actual incoming shots. NEXT ROUND appears after all current impacts/effects complete. RESET TO 1 DATA CENTER remains manual and defers during effects. Original top controls open the unchanged detailed P10 interface, whose registry intentionally remains three centers/eighteen contacts.

Compatibility launches remain: `scene/martian_learning_command.tscn` (earlier P12, 12 questions/18-second deterministic evasion), `scene/learning_command.tscn` (accepted P11), `scene/direct_command.tscn` (P10), and `scene/game.tscn` (standalone tactical).

## Known limitations

- Physical registry, trials and results persist in memory across learning rounds, not across closing/reloading the application; a save/resume system was not added.
- Six-center graphics and contacts are a learning-only projection. They do not add operational centers, combat capabilities, staff or official scoring participants.
- Generated distractors are valid catalog defenses that are unmapped to the selected attack; no semantic pedagogical ranking of distractor difficulty is claimed.
- The 50% evasion probability is a prototype Bernoulli game rule, not a physical or real-world defense-success model.
- At most five learning shots per volley follow directly from the requested five-question rounds. All six centers participate across the session.
- Occasional close captions in miniature/innermost views remain; no unrelated table/navigation redesign was undertaken.
- No outstanding functional failure in final verification. Owner visual acceptance is pending.

## Final Git status

All changes remain local and unstaged. Earlier reports and all uncommitted work are preserved. This report is an additional untracked file. Status immediately before creating this report:

```text
M project.godot
?? Reports/Prototype_11_Final_Git_Checkpoint_2026-10-25_224608_01.md
?? Reports/Prototype_12_Martian_Defense_2026-10-26_130357_01.md
?? Reports/Prototype_12_Persistent_Environment_Attack_Definitions_2026-10-26_133924_01.md
?? Reports/Prototype_12_Six_Centers_Monte_Carlo_Evasion_2026-10-26_135716_01.md
?? scene/martian_learning_command.tscn
?? scene/six_center_learning_command.tscn
?? script/catalog_learning_loader.gd
?? script/catalog_learning_loader.gd.uid
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
?? tests/prototype12_persistence_test.gd
?? tests/prototype12_persistence_test.gd.uid
?? tests/prototype12_six_centers_test.gd
?? tests/prototype12_six_centers_test.gd.uid
?? tests/prototype12_test.gd
?? tests/prototype12_test.gd.uid
```

No commit, tag, push, merge, release, reset, stash or discard. Stop for owner review; no Prototype 13 or further development initiated.
