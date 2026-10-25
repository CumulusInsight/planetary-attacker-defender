# Prototype 10 Stage 3 - Interface Usability, Navigation and Visual Refinements

Created: **2026-10-25T13:51:31-07:00**; America/Los_Angeles, local Pacific time, UTC offset -0700.
Full path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_10_Stage_3_Interface_Refinements_2026-10-25_135131_01.md`.
Implementation status: complete locally; awaiting owner visual review. No checkpoint/publication or next stage.

## Starting state and preservation

Repository: `C:\Users\azwam\Projects\planetary-attacker-defender`. Branch: `feature/prototype10-sliding-command-ui`.
HEAD remains `d9d85c7706c123fbab27231dccb468a91e413f8a` (published Stage 1), tag `planetary-prototype10-stage1-sliding-ui-v1`. Stage 2 was **not committed**. Its exact source/config/test/report manifest matched the previous handoff and `Reports/Prototype_10_Stage_2_Visual_Cyber_Defense_2026-10-25_122324_01.md`; no unexpected files were found.

A separate source preservation snapshot was made **before editing** at `C:\Users\azwam\AppData\Local\Temp\odc_stage2_preserved_20261025_133245\stage2_source.zip`, with SHA256 manifest `C:\Users\azwam\AppData\Local\Temp\odc_stage2_preserved_20261025_133245\manifest.json` and starting Git references `C:\Users\azwam\AppData\Local\Temp\odc_stage2_preserved_20261025_133245\refs.txt`. Stage 3 is an opt-in inherited scene/UI component, so Stage 2 remains runnable directly via `scene/visual_command.tscn`. No stash/reset/discard/branch-history operation was used. Existing untracked checkpoint/completion reports and all Stage 2 source/tests remain intact. Only the project entry/controller UI switch and appended concept section change pre-existing files relative to the preserved Stage 2 snapshot.

## Exact Stage 3 files created/modified

- `project.godot`
- `script/command_center.gd`
- `scene/refined_command.tscn`
- `script/refined_command_ui.gd`
- `script/refined_command_ui.gd.uid`
- `tests/prototype10_stage3_test.gd`
- `tests/prototype10_stage3_test.gd.uid`
- `Reports/Orbital_Defense_Command_Game_Concept.md`
- `Reports/Prototype_10_Stage_3_Interface_Refinements_2026-10-25_135131_01.md`

The project entry selects `refined_command.tscn`, inheriting Stage 2. The controller adds `refined_command_enabled` and component selection only. `refined_command_ui.gd` subclasses Stage 2 without altering its source. Godot generates the two required script UID files. Existing reports are not overwritten. The concept receives appended Section 28; prior sections remain historical.

## Upper-right report: alignment, sorting and navigation

Replaced manually joined text with a native Tree using fixed, shared columns, visible heading separation and readable headings **Data Center / Potential Threat / Time**. The middle heading intentionally explains the concern while preserving IDs such as C-001; it is not confirmed hostility. Each row is clickable and uses the existing public selection/center-navigation path. No defensive action is issued.

All three headings toggle ascending/descending and show direction. Data center/contact compare actual IDs; time compares actual numeric remaining seconds. Known expiry sorts as zero and displays EXPIRED. Contacts without a supported deadline are omitted rather than assigned a clock. If none remain, the table explicitly says No active decision deadlines. Contact ID breaks ties. Current contact highlight follows persistent selection; an older clicked deadline row is deselected when another contact is selected.

Layout rule: default/Contacts view uses the upper-right location (1168,52), 416 by 124 pixels, with scroll access as rows grow. While the right Threat panel is open, the deadline table moves to upper-left free space, avoiding the Threat title/Close controls. This responsive placement is an owner-review choice, not a simulation change.

## Selection-flash investigation and fix

A rendered **Stage 2** probe using actual viewport mouse input reproduced this sequence: contact C-010 stayed selected; no sliding Threat panel opened; one pre-draw frame had both the old tactical HUD and local mission card visible; following frames hid them. Probe output: `C:\Users\azwam\AppData\Local\Temp\odc_stage3_probe_actual2.log`. This establishes a rendered one-frame flash, **not** a reproduction of the owner's exact approximately half-second duration.

Cause: the sliding adapter hid legacy panels at the start of its process callback. Later in that callback, selection synchronization called `select_contact -> focus_center`, which re-enabled the selected tactical HUD and refreshed mission cards after cleanup. Next frame hid them again. Orbital selection updated public data but never opened persistent sliding information.

Fix: retain legacy data/controllers but hide their stable root controls/containers. Orbital contact signals now route to the same accepted selection method and persistent Threat section, then clean the legacy presentation. Selection survives hover exit and remains readable until deliberately replaced/closed. Original hover-freeze is untouched. Render-frame monitoring verifies **zero visible legacy flashes** through click selection, navigation, scorecard and actual outcomes. A reentrant visibility-signal prototype was rejected during local development after screenshots exposed inconsistent rendering; final code hides stable roots instead.

## Contacts pipeline and orbital presentation

All seven columns are visible simultaneously in a 704-pixel panel: Contact, Center, Severity, Confidence, Deadline, Assessment, State. The table's 668-pixel width contains all columns with no horizontal scrolling. Native Godot fallback font at 16 pixels gives readable compact values, with 14-pixel column headings; the surrounding established theme is preserved. All eighteen rows remain reachable by vertical scroll.

| Full public value | Compact display |
|---|---|
| Moderate severity | Medium |
| Unassessed severity | Unrated |
| Suspected hostile / explicit authored officer suspicion | Suspected |
| Assessed nonhostile | Nonhostile |
| Assessment revised | Revised |
| Unknown; no investigation assigned | Unknown |
| Assessment pending | Pending |
| No encounter assigned | Background |
| Decision recorded | Decided |
| Deadline expired | Expired |
| Follow-up received | Follow-up |
| MONITORED / WATCHLIST / INVESTIGATING / ESCALATED / RESOLVED | Monitored / Watchlist / Investigating / Escalated / Resolved |

Missing deadlines show a dash and retain Not applicable in the tooltip. Every cell retains its complete original value in a tooltip. Sorting/filtering operates on original public values, not shortened strings. Confidence is unchanged. The five operational states remain distinct; no private truth is used to summarize assessment text.

Opening Contacts translates only `Viewport.canvas_transform.origin` by **(360,0)** over **0.18 seconds**. Closing restores the exact saved canvas transform with the same short animation; teardown restores it too. World-node coordinates, center coordinates, contact identities, orbit radii, phases, angles, speeds and progression are not changed. There is no scale or rotation. Rendered input picking follows the translated display; hover-freeze, exit and contact clicks were tested there. The DATA center appears at x=1160 instead of x=800 while the pipeline is open.

Pin safety: the wide pipeline is **exclusive**, even if pinned. Opening it closes/unpins other large panels; opening another large panel closes/unpins the pipeline and recenters the orbital presentation. The pin tooltip explains this. Other side/drawer pin policies are inherited. No controls overlap the pipeline, and navigation never resets clocks.

## Terminology and Evidence

Threat now shows **Possible Cyberattacks** and **Likelihood based on available intelligence**. Initial hypothesis becomes Initial estimate as a display label only. The same three authored independent likelihoods remain, including sums over 100 and Unknown where absent. No probability calculation/data change.

Top Intelligence command is **E**, its tooltip says Evidence, and the drawer tab/title consistently say Evidence. Internal intelligence objects/files/report contents are unchanged. Decision Timeline remains the existing chronological view with authentic timestamps, references, filters and full details; no redesign was made.

## Graphical mission scorecard

The full-screen scorecard has the Final Mission Scorecard title (In progress suffix until complete), a horizontal separator and the same upper-right Close callback. Compact summary shows actual public confirmed points, configured maximum, dispositions, timely decisions and expirations. Each category shows its actual configured maximum; assessed categories get a display-only bar with fractional precision, unassessed categories get **no earned bar**. No unavailable points are presented as earned zeroes. Bars use `mission.public_snapshot()` only, not private adjudication. No scoring calculation changes.

Objectives retain accurate public status. Scoring details / outcomes toggles the original complete explanation/outcome report; Back returns to the graphical summary. Closing/Escape remains the accepted navigation. Rendered tests resolved the three original encounters through existing hold-fire rules and checked each displayed graph against the real public snapshot (example confirmed total 266.7 / 1000, with several categories still unassessed).

## Verification commands and actual results

Godot `4.7.2.stable.mono.official.ed1daf0bf`; rendered Vulkan Forward+ / NVIDIA RTX 2070. Existing suites ran sequentially, unchanged. No manual native-desktop playthrough is claimed.

```powershell
python tests/cyber_catalog_test.py
$godot = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
# Separately/sequentially for N=3 through 9:
& $godot --path . --script res://tests/prototypeN_test.gd
& $godot --path . --script res://tests/prototype9_corrections_test.gd
& $godot --path . --script res://tests/prototype9_cyber_test.gd
& $godot --path . --script res://tests/prototype9_decision_test.gd
& $godot --path . --script res://tests/prototype10_stage1_test.gd
& $godot --path . --script res://tests/prototype10_stage2_test.gd
& $godot --path . --script res://tests/prototype10_stage3_test.gd
& $godot --headless --editor --path . --import
& $godot --path . --quit-after 120
& $godot --path . res://scene/game.tscn --quit-after 120
git diff --check
```

| Suite | Final result |
|---|---|
| `prototype3_test.gd` | PROTOTYPE 3 TEST: PASS (0 failures) |
| `prototype4_test.gd` | PROTOTYPE 4 TEST: PASS (0 failures; 13000 checks) |
| `prototype5_test.gd` | PROTOTYPE 5 TEST: PASS (0 failures; 992 checks) |
| `prototype6_test.gd` | PROTOTYPE 6 TEST: PASS (0 failures; 229 checks) |
| `prototype7_test.gd` | PROTOTYPE 7 TEST: PASS (0 failures; 241 checks) |
| `prototype8_test.gd` | PROTOTYPE 8 TEST: PASS (0 failures; 1748 checks) |
| `prototype9_test.gd` | PROTOTYPE 9 TEST: PASS (0 failures; 311 checks) |
| `prototype9_corrections_test.gd` | PROTOTYPE 9 CORRECTIONS: PASS (0 failures; 266 checks) |
| `prototype9_cyber_test.gd` | PROTOTYPE 9 CYBER: PASS (0 failures; 361 checks) |
| `prototype9_decision_test.gd` | PROTOTYPE 9 DECISION: PASS (0 failures; 233 checks) |
| `prototype10_stage1_test.gd` | PROTOTYPE 10 STAGE 1: PASS (0 failures; 71 checks) |
| `prototype10_stage2_test.gd` | PROTOTYPE 10 STAGE 2: PASS (0 failures; 121 checks) |
| `prototype10_stage3_test.gd` | PROTOTYPE 10 STAGE 3: PASS (0 failures; 234 checks) |
| Python cyber catalog | PASS; exact export/schema/mappings/source fingerprint |
| Godot editor/import | PASS, exit 0 |
| Main rendered startup | PASS, exit 0 |
| Standalone tactical rendered startup | PASS, exit 0 |
| `git diff --check` | PASS |

Stage 3 final result is **234 checks, zero failures**. The sequential full run passed 226 checks before final additive alignment/animation/no-deadlines assertions; that affected suite was then rerun successfully at 234. No accepted test was weakened or changed. Earlier suites intentionally emit missing/invalid-fixture diagnostics; their final assertions pass. Logs/results: `C:\Users\azwam\AppData\Local\Temp\odc_stage3_checks`; sequential runner `C:\Users\azwam\AppData\Local\Temp\odc_stage3_run.py`. Final Stage 3 log supersedes its earlier successful run.

New checks include: shared-column alignment for every deadline row; all deadline sort directions and numeric order/expiry/missing behavior; real deadline-row click navigation without resolution; persistent actual orbital click beyond half a second; frame-pre-draw legacy visibility; seven columns fitting actual font metrics; full-value tooltips and selected-row correctness; all operational states compact/distinct; intermediate opening/closing animation positions; original world transform/progression unchanged; shifted hover and click picking; safe pin replacement; accessible terminology; Evidence/Timeline continuity; graph precision/maxima/unassessed handling; full explanation access; Close; score/deadline invariance; Challenge progression; and transform restoration at teardown.

## Before/after screenshots

Review copies (outside repository): `C:\Users\azwam\AppData\Local\Temp\odc_stage3_visual_review_20261025_134920`.

| View | Before Stage 2 | After Stage 3 |
|---|---|---|
| Default / deadline report | `before_stage2_default.png` | `after_stage3_default.png` |
| Contacts / orbital repositioning | `before_stage2_contacts.png` | `after_stage3_contacts.png` |
| Persistent selection | Stage 2 probe above (no persistent panel) | `after_stage3_selected.png` |
| Threat assessment | `before_stage2_threat.png` | `after_stage3_threat.png` |
| Evidence | `before_stage2_intelligence.png` | `after_stage3_evidence.png` |
| Mission | `before_stage2_mission.png` | `after_stage3_mission.png` |

All six final after images were inspected at 1600 by 900, including fresh final Contacts/selected/Mission copies. Default deadline headings align on one line; Contacts has all seven columns readable and the selected C-010 row matches the orbital highlight; all six current-center contacts and DATA remain visible beside the pipeline. Persistent Threat text stays visible, Evidence terminology/timestamps remain intact, and the final scorecard has no legacy overlays. The underlying screenshots are also under the Godot user-data directory, with `prototype4_p10s3_*.png` names. No screenshots were added to the repository.

## Known limitations and review decisions

- Deadline table moves upper-left while Threat is open to avoid title/control overlap; otherwise upper-right. Owner review should confirm this responsive placement.
- Wide Contacts replaces pin coexistence with an explicit exclusive-panel rule. It preserves the pinned selection/data, but intentionally closes/unpins the previous large panel to fit the reference viewport.
- Current eighteen-contact configuration and authored assessments are covered; future longer classification/state strings may need additional concise display mappings. Full values remain in tooltips; no data is discarded.
- Contacts still scrolls vertically through eighteen rows. Evidence and Timeline retain Stage 2 horizontal metadata/detail scrolling; that was outside this stage's Contacts-only no-horizontal-scroll requirement.
- The exact owner-reported half-second duration was not reproduced; a one-render-frame legacy flash was reproduced and corrected. Native manual desktop operation has not been claimed.
- Native fallback font is used for compact tables; all other typography/artwork remains. Only 1600 by 900 was rendered/inspected. No new art, dependency, probability, defense outcome, scoring rule or combat feature.

## Git status and stop

HEAD/branch/tag references unchanged; no files staged. Stage 2 remains uncommitted and preserved together with this work. Existing reports remain unchanged. Status before creating this report:

```text
M Reports/Orbital_Defense_Command_Game_Concept.md
 M project.godot
 M script/command_center.gd
?? Reports/Prototype_10_Stage_1_Git_Checkpoint_Report_2026-10-24_225417_01.md
?? Reports/Prototype_10_Stage_2_Visual_Cyber_Defense_2026-10-25_122324_01.md
?? scene/refined_command.tscn
?? scene/visual_command.tscn
?? script/refined_command_ui.gd
?? script/refined_command_ui.gd.uid
?? script/visual_command_model.gd
?? script/visual_command_model.gd.uid
?? script/visual_command_ui.gd
?? script/visual_command_ui.gd.uid
?? tests/prototype10_stage2_test.gd
?? tests/prototype10_stage2_test.gd.uid
?? tests/prototype10_stage3_test.gd
?? tests/prototype10_stage3_test.gd.uid
```

Additionally this report is new/untracked. The concept update includes only appended historical Stage 3 design. Final status is also verified after report creation. No commit, tag, push, merge, reset, amend, release or next stage occurred. Stop for owner visual review.
