# Prototype 11 — Time, threat variety and three-center display

Created: 2026-10-25T19:38:49-07:00 (Pacific Daylight Time, America/Los_Angeles).
Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_11_Time_Variety_Multicenter_2026-10-25_193849_01.md`.
Status: implemented and locally verified; awaiting owner visual acceptance. No checkpoint/publication performed.

## Baseline and preservation

Branch `feature/prototype11-simplified-cyber-game`, HEAD `ee96eebb88d942d9302a9aa740e1414fb931eba1`; accepted `planetary-prototype10-complete-v1` still peels to this P10 commit. All existing P11 work remains uncommitted. A start-of-task copy/hash inventory is outside the repository at `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_backup_20261025_191148`.

Hash comparison confirms every pre-existing file other than the six explicitly listed below remains unchanged. All three earlier completion/checkpoint reports are preserved byte-for-byte, including the P10 final checkpoint report and both P11 reports. The pre-existing `project.godot` main-scene change is unchanged from the start of this assignment. No P10 scenes/scripts, movement code, contact records, public intelligence fixtures, private truth, catalog mappings, evaluators, scoring or official deadline rules were edited.

## Exact files modified and added

Modified:

- `script/learning_question_loader.gd`: validates a separate authored learning bank and reproducibly selects/shuffles a session.
- `script/learning_session.gd`: explicit contact-keyed learning deadlines and late-practice flag; existing answer metrics/volley idempotency retained.
- `script/learning_game.gd`: records seed/content fingerprints, selects bank/session at startup, projects shared deadline values into primary/Report views, manages separate center displays and per-center firing.
- `script/learning_projectile.gd`: uses displayed center/target coordinates and scaled, bounded visual effects without changing deterministic hit/miss rules.
- `tests/prototype11_test.gd` and `tests/prototype11_refinements_test.gd`: explicitly request the original fixed five-question fixture for established regression assertions; update only deadline/layout expectations affected by this assignment. No P3–10 tests changed.

Added:

- `data/learning_question_bank.json`: 12 curated distinct attack templates, each with exact catalog references and an explicit learning budget.
- `script/learning_orbital_display.gd` and its `.uid`: presentation-only one/two/three-center layout and projected contact hover/selection.
- `tests/prototype11_multicenter_test.gd` and its `.uid`.
- This timestamped report. Screenshots and logs remain outside the repository.

## Root cause of the TIME discrepancy

This was a contact-ownership discrepancy, not countdown drift:

| Previous primary contact | Data center | Actual original deadline owner / initial window |
|---|---|---|
| C-001 | DC-01 | Existing original encounter + movement-derived OrbitalDeadline / 300 s |
| C-004 | DC-02 | Existing original encounter + movement-derived OrbitalDeadline / 360 s |
| C-007 | DC-03 | Existing original encounter + movement-derived OrbitalDeadline / 240 s |

The former fixed learning Report used C-010/C-011/C-012 in DC-01 and C-013/C-014 in DC-02. Those are different passive contacts with no active operational deadline in production configuration. Their earlier `NO DEADLINE` values accurately reflected that fact; they did not own C-001's timer merely because they shared DC-01. The source paths inspected were the original refined primary deadline list, strategic registry, contact operations public view and the P11 Report projection. No claim is made to have reproduced the owner's exact manual play session.

## Chosen explicit deadline policy

1. On the first successful Analyze YES, each selected learning contact receives its authored budget, anchored to existing `command.operations.session.now`: `learning_due_at[id] = now + question.learning_deadline_seconds`.
2. If that same contact has a real applicable operational deadline, its authoritative owner takes precedence. Original active encounters still use their existing movement-derived owner; configured operational windows use the existing operations public view and expiry events. No neighboring timer is copied.
3. Otherwise remaining learning time is `max(0, learning_due_at[id] - operations.session.now)`. All timing reads the existing simulation clock; no independent wall timer or duplicate delta integration was added.
4. Primary learning rows and Report TIME call the same `deadline_view/deadline_text` functions for the same contact IDs. Both use ceiling-rounded `MM:SS` and show `EXPIRED` at zero. Source ownership is available on the primary time tooltip.
5. While the A/R/D learning layer is active, a primary list labeled **Learning Contact** occupies the same primary-report rectangle and contains the Report's contacts. The original P10 table is preserved behind this context and restored through any original navigation control. Its timers continue under their accepted simulation rules.
6. Strategic pause holds learning time, pending volleys and projectile motion. Resume advances from the same authoritative state without catch-up. Contact hover freezes its existing movement only, as before; the shared learning/volley clock continues unless strategically paused.
7. Reopening Report, selecting another contact, or repeating Analyze never resets or extends a deadline. Learning restart resets the same seeded learning exercise and its own budgets/metrics; no operational replay or deadline restore is invoked.
8. A learning deadline is a **timely-learning opportunity**, not an automatically simulated attack or financial loss. Expiry is visible in both displays but causes no automatic shot, operational resolution or score penalty. Late practice remains allowed and is recorded/labeled after evaluation. Existing P10 expiry/outcome rules are never bypassed or reversed.

Budgets currently range from 240 to 480 simulation seconds according to the bank table below. This is explicit P11 configuration, not claimed intelligence about actual spacecraft capabilities. Tests separately configured an existing C-010 operational window in a fixture and verified exact DC-01 values `02:05` and `EXPIRED` in both displays, with no fallback to a neighboring or fresh learning timer.

## Question bank and session variety

The unchanged validated v12 catalog remains authoritative: 100 attacks, 185 defenses, 211 attack-defense mappings. Its Python validation passed exact export reproducibility and source fingerprint/schema/mapping verification. The SQLite database was not changed or copied.

Normal play selects **five of 12 distinct attack types** without replacement, shuffles question order and every four-option position, and assigns actual unique background contacts to their actual data centers. Default participation is three centers, with at least one learning encounter per center; five contacts are balanced across them. Existing original official encounter participants C-001/C-004/C-007 are excluded. Up to five passive slots per participating center allow the same five-question session size for one-center or two-center configurations as well.

The original `learning_questions.json` and its five keys remain unchanged as a deterministic regression fixture. Expanded templates are **authored P11 learning suspicions**, not edits to P10 intelligence reports or private payloads. The original P10 public assessment can therefore differ from the isolated learning exercise. Report status and plot headings explicitly identify the learning context. No private truth is used to select the templates, distribute contacts or calculate correct answers.

| Exact catalog attack / ID | Designated mapped answer / ID | Three validated nonmapped distractors / IDs | Learning budget (seconds) |
|---|---|---|---|
| VIRUS / 77 | Antivirus / 138 | Segmentation (111), Backups (19), Secure Boot (3) | 300 |
| WORM / 64 | Segmentation / 111 | Antivirus (138), Backups (19), Scrubbing (140) | 360 |
| RANSOM / 59 | Backups / 19 | Secure Boot (3), Segmentation (111), Scrubbing (140) | 420 |
| ROOTKIT / 2 | Secure Boot / 3 | Backups (19), Firewalls (112), Scrubbing (140) | 240 |
| DDoS / 78 | Scrubbing / 140 | Antivirus (138), Secure Boot (3), Backups (19) | 480 |
| PHISHING / 83 | Email Filtering / 150 | Antivirus (138), Segmentation (111), Secure Boot (3) | 330 |
| TROJAN / 76 | Allowlisting / 136 | Email Filtering (150), Backups (19), Scrubbing (140) | 390 |
| SPYWARE / 9 | Anti Spyware / 13 | Segmentation (111), Secure Boot (3), Scrubbing (140) | 450 |
| SQL INJECT / 27 | Prepared Statements / 43 | Antivirus (138), Segmentation (111), Backups (19) | 270 |
| DoS / 45 | Rate Limiting / 77 | Secure Boot (3), Antivirus (138), Backups (19) | 310 |
| XSS / 87 | Encoding / 158 | Antivirus (138), Segmentation (111), Backups (19) | 350 |
| PRIV ESC / 70 | Least Privilege / 50 | Antivirus (138), Scrubbing (140), Secure Boot (3) | 400 |

Exactly one displayed option is the designated mapped answer. Other mapped defenses are excluded from distractors, not declared wrong. Missing IDs, duplicate attacks/options, broken mappings, a second mapped option, malformed bank data or invalid budgets are rejected with diagnostics. A catalog mapping still does not guarantee real-world or original P10 operational effectiveness; this is an explicit introductory learning key.

## Seed recording and deterministic replay

Normal application launch uses a fresh Crypto-generated 32-bit seed. The actual seed is printed to the console and shown in the Report footer. `user://prototype11_learning_session.json` records the latest launch's seed, Godot version, center limit, bank/catalog SHA-256 hashes and selected contact/question/choice order, without publishing designated-answer fields. This is a local learning-session record outside Git and the canonical operational ledger; a subsequent launch replaces this latest-launch record.

Reproduce with the same bank/catalog, Godot version and arguments:

```text
godot --path . -- --odc-learning-seed=12345 --odc-learning-centers=3
```

Use centers 1 or 2 for the other layout sizes; allowed maximum is 3. The wrapper also exposes equivalent exported seed/center-limit properties for deterministic tests. `legacy_test_fixture` is test-only and selects the unchanged original five questions; it does not select an alternate P10 evaluator or skip new layout/deadline behavior.

The selected set is fixed for the application session. Re-analyzing, changing pages and navigating do not reshuffle. Existing Restart replays the same seed/questions while resetting only learning progress, metrics, shots and learning windows. A new normal application launch produces a fresh selection/seed. Repeated sessions can occasionally share an attack type; the bank contains 12 actual types, not a claim of five entirely new attacks every launch.

## One, two and three separate orbital displays

The isolated `learning_orbital_display.gd` projects the existing tactical actor positions into up to three separate, labeled rectangles inside the main area `(20,184)-(1218,832)`. One center receives a large plot; two divide the width; three share three columns, with 16-pixel gaps. A fit scale based on available width/height preserves the 160/280/400 radius ratios, ellipse shapes/orientation and current angular positions. Each participating center shows its own six actual contacts, its DATA asset and `$1,000,000` label. No horizontal scrolling, extra permanent navigation controls or changes to original panel positions were introduced.

Original actor textures and neutral surveillance symbols are reused. Projections read source positions after existing simulation updates; they never advance a second orbit simulation. Original tactical worlds are hidden only for the active learning presentation and restored for P10 comparison. Models continue under their existing movement/pause policies. Projected hover calls the source contact's accepted hover enter/exit, preserving contact-specific freeze; projected selection uses existing contact navigation without issuing a defense command.

Each shot now originates at its own displayed DATA center and homes toward its own displayed contact marker. All shots in a volley launch together, including multiple targets within one center. Miss offsets, trails and impact effects scale to the corresponding plot; visual bounds keep them associated with that center. Every contact independently hits/misses and contributes exactly once to learning metrics. Correct targets disappear only in the learning projection/visual override; underlying records, paths, encounter truth, operational state and official scoring remain intact.

The three-center rendered example used seed 12345 and a five-shot mixed volley. Correct/incorrect answers produced 3 hits and 2 misses for 60%, with all per-contact feedback retained. WAIT 1/5/10-minute scheduling, immutable snapshots, cancellation and replay isolation remain covered by the existing suites.

## Verification and actual results

Godot 4.7.2 stable Mono, rendered Vulkan/NVIDIA RTX 2070 at 1600 x 900. Existing suites ran sequentially, followed by the new suite, editor import, startup and command-line replay checks. P3 retains its established off-desktop rendered position to isolate root-viewport input from the desktop pointer; later suites use isolated rendered test viewports. No P3–10 assertions were weakened or edited.

| Check | Actual final result |
|---|---|
| catalog | CYBER CATALOG: PASS; reproducible exact export, declared schema, manual mappings and unchanged source hash verified |
| prototype3 | PROTOTYPE 3 TEST: PASS (0 failures) |
| prototype4 | PROTOTYPE 4 TEST: PASS (0 failures; 12792 checks) |
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
| prototype11 | PROTOTYPE 11: PASS (0 failures; 145 checks) |
| prototype11_refinements | PROTOTYPE 11 REFINEMENTS: PASS (0 failures; 142 checks) |
| prototype11_multicenter | PROTOTYPE 11 TIME VARIETY MULTICENTER: PASS (0 failures; 229 checks) |
| import | PASS; exit 0, no script/parse errors |
| main_startup | PASS; exit 0, no script/parse errors |
| prototype10_startup | PASS; exit 0, no script/parse errors |
| standalone_startup | PASS; exit 0, no script/parse errors |
| diff_check | PASS; exit 0, no script/parse errors |
| seeded_1_center_startup | Recorded seed/center/participation validation: PASS |
| seeded_2_center_startup | Recorded seed/center/participation validation: PASS |
| seeded_3_center_startup | Recorded seed/center/participation validation: PASS |

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
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --headless --editor --path . --import
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/direct_command.tscn --quit-after 120
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . res://scene/game.tscn --quit-after 120
git diff --check
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120 -- --odc-learning-seed=12345 --odc-learning-centers=1
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120 -- --odc-learning-seed=12345 --odc-learning-centers=2
C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe --path . --quit-after 120 -- --odc-learning-seed=12345 --odc-learning-centers=3
```

The original P11 suites still test their known five-question fixture with fixed IDs/choices. Affected assertions now require the explicit learning deadline and displayed center origins/markers rather than the superseded absent deadline/superimposed markers. The new suite exercises normal bank sessions, validates all 12 templates, fixed-seed reproduction and different-seed variety, shuffled option selection, deadline ownership/priority/expiration/reopen/pause, no premature answer-key fields, all three layout sizes, actual projected hover, five independent three-center shots, mixed outcomes and unchanged P10 mission/evaluator/ledger state.

Development diagnostics were not counted as passes: an initial new-test helper bypassed opening Analyze and therefore had no learning-context primary rows; its setup was corrected to follow the actual workflow. The new shuffled-choice test then used strict Array.find with integer IDs against JSON numeric variants and clicked the wrong option; integer normalization plus explicit selected-ID assertions corrected that test. A command-line argument indentation parse error in the new wrapper code was also corrected before the final passing run. No original evaluator or scoring changes were made to obtain passing results. Rendered tests and screenshot inspection are not a claim of manual native-desktop play or long-duration wall-clock waiting.

## Screenshots and visual inspection

Review directory: `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_review_2026-10-25_193849`; final command/result logs are in `verification_logs` there.

- `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_review_2026-10-25_193849\report.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_review_2026-10-25_193849\three_centers.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_review_2026-10-25_193849\volley.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_review_2026-10-25_193849\results.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_review_2026-10-25_193849\1_centers.png`
- `C:\Users\azwam\AppData\Local\Temp\odc_p11_multicenter_review_2026-10-25_193849\2_centers.png`

All captures are actual 1600 x 900 rendered frames. Inspection covered the eight-column Report and matching primary learning times, separate six-contact center plots, one/two-center scaling, five projectiles across three centers, independent impacts and persistent 3/2/60% results. Existing taskbar and Close/quick controls remain accessible. Report and Decide retain their accepted overlay positions; Decide closes for firing as before. Screenshots/logs are not in the source tree.

## Known limitations / owner review

- Learning deadlines are authored prioritization windows. Late practice remains permitted and labeled; there is no new financial loss, operational outcome, automatic shot or time-based score penalty.
- Expanded learning suspicions are explicitly authored exercises, not newly inferred or verified P10 intelligence. The original simulation and detailed interface can retain different uncertain assessments.
- Default normal participation is three centers. One/two-center modes are available via startup arguments/exported settings; no new permanent selector was added.
- Restart replays the current seed rather than selecting a new bank set; relaunch normally for new-session variety.
- The compact primary list scrolls when needed for five rows; the existing Report shows all five time/choice rows simultaneously.
- Existing pinned P10 panels can still overlay plots, following their preserved behavior. Close them or use the ordinary navigation when comparing views; no forced redesign of pins was introduced.
- Layout was verified at the requested 1600 x 900 reference resolution. No claim of arbitrary-resolution visual certification or physically validated spacecraft orbits.
- Learning results and latest seed record remain local/in-session; no new database, network dependency or official points were added.

## Working tree and safety

HEAD `ee96eebb88d942d9302a9aa740e1414fb931eba1`, branch `feature/prototype11-simplified-cyber-game`. Index is empty. Only the six authorized pre-existing source/test files changed from the task-start hash inventory; existing reports, original question file, catalog, project setting and all P10 assets/scenes/scripts match that inventory. The `project.godot` modification below predates this task and remains preserved.

```text
M project.godot
?? Reports/Prototype_10_Final_Git_Checkpoint_2026-10-25_145510_01.md
?? Reports/Prototype_11_Simplified_Cyber_Game_2026-10-25_154821_01.md
?? Reports/Prototype_11_Targeted_Refinements_2026-10-25_164947_01.md
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
?? tests/prototype11_multicenter_test.gd
?? tests/prototype11_multicenter_test.gd.uid
?? tests/prototype11_refinements_test.gd
?? tests/prototype11_refinements_test.gd.uid
?? tests/prototype11_test.gd
?? tests/prototype11_test.gd.uid
```

This new report is one additional untracked file. No commit, tag, push, merge, release, reset, discard, stash or branch change occurred. Prototype 12 was not started. Stop for owner review.
