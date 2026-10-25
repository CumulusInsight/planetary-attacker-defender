# Prototype 10, Stage 1 ? Sliding Command Interface

Created: 2026-10-24T21:07:09-07:00 ? America/Los_Angeles (Pacific Daylight Time, UTC offset -0700).

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_10_Stage_1_Sliding_Interface_2026-10-24_210709_01.md`

Status: **implemented and locally verified; awaiting owner visual acceptance**. No commit, tag, push, merge, release or Stage 2 work.

## Git safety and baseline

Repository: `C:\Users\azwam\Projects\planetary-attacker-defender`.

Branch: `feature/prototype10-sliding-command-ui`, created from the verified published Prototype 9 tag. HEAD remains `1e9700b4de32d583fbcd41c329d394797f8e91d9`. Accepted tag `planetary-prototype9-cyber-command-v1` still targets that commit; no history rewrite occurred.

The starting tracked tree/index were clean. The requested new branch did not exist before creation. Only the two expected local audit reports were untracked. They remain byte-identical and untracked:

- `Reports/Prototype_9_Git_Checkpoint_Report_2026-10-24_195000_01.md` ? SHA256 `0a8af4eafdccadbde2a82d1cdc3eda0c4c115c1206d995f2d1077eb634135c75`.
- `Reports/Prototype_9_Git_Checkpoint_Report_2026-10-24_200224_01.md` ? SHA256 `0fecc587fe2307d1c4195ddf7b56037480b5dcad5eeb86634d9d27ceeb920e46`.

No reset, stash, discard, deletion or overwrite was used. No existing prototype report was replaced. The owner's request to proceed by ordinary typed messages was respected; no further interactive decision menu was required.

## Files created and modified

Created:

- `scene/sliding_command.tscn`: thin inherited Prototype 9 command scene enabling the sliding presentation.
- `script/sliding_command_ui.gd` and `script/sliding_command_ui.gd.uid`: native Godot presentation adapter, panel layout/animation, compact controls and delegation to accepted workflows.
- `tests/prototype10_stage1_test.gd` and `tests/prototype10_stage1_test.gd.uid`: rendered Stage 1 regression checks.
- This uniquely named completion report.

Modified:

- `project.godot`: F5 entry changed to `res://scene/sliding_command.tscn`.
- `script/command_center.gd`: one optional `sliding_command_enabled` property and presentation-component selection; old scenes retain their accepted UI by default.
- `Reports/Orbital_Defense_Command_Game_Concept.md`: appended section 26, preserving historical sections and rules.

No movement, intelligence-source, scenario, catalog, evaluator, deadline, mission-ledger, scoring configuration, artwork or accepted test file was edited. Hash/path-aware Git comparisons confirmed protected files remain equal to the accepted checkpoint. The v12 catalog and original SQLite source were not modified.

## Interface architecture

`SlidingCommandUI` inherits the accepted P9 decision presentation/controller rather than creating another simulation or inference engine. It reuses the existing public assessment model, complete report/history projections, canonical event journal, investigation owners, validation and confirmation handling. Legacy presentation controls remain allocated but hidden as compatibility adapters. No second set of report timers, encounters or scoring participants is created.

The new presentation runs after existing UI controllers refresh, suppressing their permanent left/right cards while leaving their simulation processing enabled. This ordering was important: initial screenshots exposed old cards being redrawn after an earlier hide operation. The final UI presentation priority fixes that visibility issue without changing gameplay-process priorities.

The default view focuses DC-01 and selects C-001 for context. This is selection only, not a command or deadline reset. All three existing tactical instances and eighteen network contacts remain. Changing center/contact navigates to the existing instance. The orbital transform, center, artwork size, circle/ellipse paths, selected-object instance IDs and orbital geometry are unchanged when panels open or close.

### Compact command strips

The top strip has native letter/symbol icons: O Overview, C Contacts, T Threat Assessment, I Intelligence, H History, M Mission Status and ! Alerts. Each has a readable tooltip and active styling. It also exposes tactical center, Learning/Active Challenge, explicit strategic pause, and command-role selection. These are presentations of accepted controls, not new simulation modes.

Applicable network deadlines remain visible at the upper-right margin, labeled with each center/contact. No background contact gets a fabricated clock. Actual expired opportunities remain labeled EXPIRED. The warning accent/count is used only for applicable deadlines at/below sixty seconds or an actual expiry. Public severity does not become hidden-truth coloring or a combined risk score.

The bottom quick strip keeps Investigate, Monitor, Cyber Defense, Physical Defense and History within reach. It shows selected ID/center and pause/live status or brief action feedback. Review/opening never executes a defensive response. Existing escalation and confirmation rules remain authoritative.

### Left Contacts panel

- 640 ? 724 reference-pixel overlay at the left edge, independent of orbital coordinates.
- All eighteen contacts, with center/status display filters.
- Seven accepted sort keys: contact ID, center, ordinal severity, numeric confidence, numeric deadline, public assessment and operational state. Display column order places concise operational fields first.
- The table uses readable 16-point type and native horizontal scrolling for longer assessment/state columns; all content remains accessible. Missing values preserve the accepted explicit semantics.
- Same-population sort changes reorder existing TreeItems, preserving row identity/selection; filter changes rebuild only the displayed population while retaining selected contact state.
- An obvious Open selected Threat Assessment button.
- Overview clears display filters to the full network; it does not reset contacts, investigations or clocks.

No confidence slider was added. All filters are labeled as display-only and cannot mutate confidence or gameplay state.

### Right Threat Assessment panel

The 640 ? 724 right overlay shows selected contact/center/status, physical suspicion/confidence and evidence excerpt, three nonexclusive cyber hypotheses with likelihood/Unknown and catalog severity, concise supporting evidence, and the accepted recommendation/rationale/confidence. Full originals are retained in Intelligence; summaries never rewrite data.

Assessment and Countermeasures views distinguish suspected attacks from response mechanisms. The latter joins the accepted catalog mappings and existing validated scenario options. Informational, requires-escalation, executable and already-issued states retain their existing labels/confirmation behavior. No new defense, likelihood or outcome was invented.

Fixed controls open investigation, cyber response, physical review, monitoring review, coordinated proposal and existing operational commands. Unsupported proposals cannot confirm. Original active encounters also expose explicit Hold fire and practice-replay review controls; they delegate to accepted original handlers. Replay explicitly restores only its existing encounter state and preserves first-resolution-official scoring. No panel navigation triggers replay.

### Bottom drawer

The drawer supports Intelligence and History tabs, source filters and selected-contact/network history filtering. It is capped at 380 reference pixels high with one internal scroll area. Full SIGINT, platform, trajectory, follow-up, superseded reports, original briefs, public multi-threat details and after-action results are retained.

The Intelligence tab begins with selected ID/center/path and the latest matching report's authentic receipt metadata. This keeps real local date/time/offset and simulation time visible before scrolling into longer historical briefs. Observation time remains explicitly unavailable when not recorded; no historical timestamp is fabricated. The complete accepted report projection follows, plus full public hypothesis/recommendation details. History uses the existing chronological journal and preserves received-report/decision metadata and supersession annotations.

### Existing modal workflow exceptions

Mission Status opens the existing confirmed scorecard. Operational escalation and disposition use the accepted operations console and its explicit reason/confirmation. The sliding shell yields while those focused workflows are open so their controls remain usable, then returns without resetting state. They remain deliberate temporary modal workflows; Stage 1 did not duplicate their validation into a new evaluator.

## Animation, pinning and navigation policy

- Short **0.18-second ease-out** slides via UI Tweens.
- One large information panel by default: opening another closes the previous unpinned panel.
- At most **one pinned panel**. Pinning another replaces the earlier pin and closes the no-longer-protected panel as needed.
- Two side panels occupy separate left/right regions with a central gap.
- A bottom drawer sharing space with a side panel narrows its own UI rectangle to 912 pixels on the opposite side. Its text wraps inside that rectangle; the simulation never shrinks or shifts.
- Pin/Unpin and Close remain fixed in each header. Close explicitly closes/unpins. Escape closes the active unpinned panel, leaves a pinned panel open, or first cancels a confirmation.
- Top controls/deadlines and bottom quick actions remain outside panel bounds. Tested pinned combinations have no overlapping panel rectangles or inaccessible critical controls.
- Closing panels preserves selection, investigation jobs, report history, official points and deadlines. Learning/Challenge and contact-specific hover-freeze retain accepted semantics. There is no new strategic clock or automatic pause on reading.

## Visual design and references

The implementation uses the supplied written direction: dark blue-gray surfaces, subtle native borders, readable existing project typography, compact native text-symbol icons and restrained warning accents. No external dependency, downloaded art or new artwork was introduced.

The previously approved mockup images were not available in the project/context. An optional reference-location question was raised before the owner explicitly instructed proceeding with the provided Stage 1 requirements. Work continued from those written requirements; fidelity to a particular unavailable mockup image is not claimed. No further design approval was inferred.

## Actual verification

Godot: `4.7.2.stable.mono.official.ed1daf0bf`; rendered Vulkan Forward+ on NVIDIA RTX 2070. Reference viewport: 1600 ? 900.

Commands from repository root:

```powershell
python tests/cyber_catalog_test.py
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
# Executed separately, sequentially, for N = 3,4,5,6,7,8,9:
& $godotExe --path . --script res://tests/prototypeN_test.gd
& $godotExe --path . --script res://tests/prototype9_corrections_test.gd
& $godotExe --path . --script res://tests/prototype9_cyber_test.gd
& $godotExe --path . --script res://tests/prototype9_decision_test.gd
& $godotExe --path . --script res://tests/prototype10_stage1_test.gd
& $godotExe --headless --path . --editor --import --quit
& $godotExe --path . --quit-after 120
& $godotExe --path . res://scene/game.tscn --quit-after 120
git diff --check
```

| Verification | Actual result |
| --- | --- |
| Python catalog validation | PASS; exact v12 export reproduction/source hash verification |
| Prototype 3 sequential run | PASS, 0 failures, exit 0 |
| Prototype 4 | PASS, 12,944 checks, exit 0; frame-dependent observation count |
| Prototype 5 | PASS, 992 checks, exit 0 |
| Prototype 6 | PASS, 229 checks, exit 0 |
| Prototype 7 | PASS, 241 checks, exit 0 |
| Prototype 8 | PASS, 1,748 checks, exit 0 |
| Prototype 9 | PASS, 311 checks, exit 0 |
| P9 acceptance corrections | PASS, 266 checks, exit 0 |
| P9 cybersecurity integration | PASS, 361 checks, exit 0 |
| P9 decision interface | PASS, 233 checks, exit 0 |
| New P10 Stage 1 suite, final rendered run | PASS, **71 checks**, exit 0 |
| Editor/import | Exit 0, no script errors |
| Main rendered startup | Exit 0, no script errors; repeated after final presentation changes |
| Standalone tactical rendered startup | Exit 0, no script errors |
| git diff --check | PASS |

The new suite covers clean default rendering, tooltips, slide start/end, all eighteen contacts, seven sort handlers, display filters, actual row navigation, stable contact selection, pin/unpin, nonoverlapping pinned layouts, Escape behavior, real timestamps, history, event idempotency, simulation transform/object identity, unchanged paused deadlines/scoring, escalation/confirmation gating, existing cyber containment, scorecard access, actual orbital hover/click/mouse-exit behavior, independent other-contact movement and Challenge progression with panels closed/open. It also checks that compact pause status updates correctly and public panels omit private truth fields.

**Initial failure disclosed:** the first Prototype 3 attempt reported four timed inward-orbit assertions while another rendered Stage 1 suite was running concurrently. No movement code or accepted assertion was changed. The full rendered regression set was rerun sequentially, and Prototype 3 and all remaining suites passed. Concurrent rendered-window/input/GPU timing is a plausible contributor, but the exact cause was not proven; the initial failed log is retained rather than hidden.

During UI development, screenshots found old cards being redrawn after hiding; the new presentation-pass ordering corrected it. A new test was synchronized to the rendered frame after changing strategic pause, and later checks caught and corrected stale compact pause text. No accepted tests were weakened or deleted.

Logs: `%TEMP%/odc_p10_stage1_checks/`, with `_sequential.log` files, `sequential_results.json`, final Stage 1 and startup logs, and the initial failed Prototype 3 log. Existing negative-fixture diagnostics remain expected in legacy suites. No test is claimed successful merely because it ran headlessly.

## Screenshots and visual inspection

All captures are outside the repository:

`C:/Users/azwam/AppData/Roaming/Godot/app_userdata/planetary-attacker-defender/`

1. `prototype4_p10_default.png`
2. `prototype4_p10_contacts.png`
3. `prototype4_p10_threat.png`
4. `prototype4_p10_intelligence.png`
5. `prototype4_p10_history.png`
6. `prototype4_p10_pinned.png`

All six required views were opened and visually inspected at 1600 ? 900. The default leaves orbital traffic unobstructed by large cards; deadline labels sit outside the main orbital region. Side-panel text and actions are readable; full detail remains scroll-accessible. The Intelligence capture visibly shows actual receipt date/offset and simulation metadata at the top. Pinned drawer/side regions do not overlap, and the top/quick-action strips remain accessible. Brief evidence excerpts are intentional summaries with complete source text in the drawer. The table has explicit horizontal scrolling for long columns rather than shrinking its text.

Rendered tests exercise actual Godot viewport mouse and keyboard events. **No separate manual native-desktop playthrough is claimed.** Owner visual review is still required.

## Known limitations and remaining UI refinements

- Icons are temporary native letter/symbol controls; final icon artwork and exact mockup alignment remain owner-review items.
- Target is the existing 1600 ? 900 layout. Other aspect ratios/resolutions need a separate responsive-layout review.
- The one-pin policy is intentionally conservative. More simultaneous pinned panels are not supported because readability and access take priority.
- Contact assessment/state columns require horizontal scrolling; full reports require the drawer's vertical scroll. Fixed primary actions stay outside those scrolling regions.
- Long evidence is summarized in the right panel; full public hypotheses and original reports remain accessible, not deleted.
- Existing scorecard and operational confirmation remain focused modal subviews. A later UI-only migration of those subviews can be considered after review.
- Hidden legacy presentation objects are retained as compatibility adapters; Stage 1 prioritizes accepted controller reuse rather than removing those objects.
- Monitoring review alone issues no high-impact command. Explicit Hold fire/de-escalation/release continues through accepted workflows. Unsupported physical/coordinated proposals remain unavailable.
- Existing deadlines, hover policy and Learning pause scope are unchanged. Opening an information panel does not stop Challenge simulation or analyst work.
- The earlier concurrent Prototype 3 failure is recorded; sequential execution is recommended for these rendered/input-sensitive suites.

Recommended next action: owner visual review of panel density, icon/tooltips, horizontal table access, animation speed and the single-pin policy. No Stage 2 implementation is authorized or begun.

## Git working-tree status

No staging, commit, tag, push, merge or release occurred. Accepted Prototype 9 HEAD/tag remain unchanged. Existing audit reports remain untracked. Status immediately before creating this report, with this new report added below:

```text
 M Reports/Orbital_Defense_Command_Game_Concept.md
 M project.godot
 M script/command_center.gd
?? Reports/Prototype_9_Git_Checkpoint_Report_2026-10-24_195000_01.md
?? Reports/Prototype_9_Git_Checkpoint_Report_2026-10-24_200224_01.md
?? scene/sliding_command.tscn
?? script/sliding_command_ui.gd
?? script/sliding_command_ui.gd.uid
?? tests/prototype10_stage1_test.gd
?? tests/prototype10_stage1_test.gd.uid
?? Reports/Prototype_10_Stage_1_Sliding_Interface_2026-10-24_210709_01.md
```
