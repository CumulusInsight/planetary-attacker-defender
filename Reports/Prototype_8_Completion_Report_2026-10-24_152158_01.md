# Prototype 8 Completion Report ? Elliptical Traffic and Fallible Intelligence

Created: 2026-10-24T15:21:58-07:00 ? America/Los_Angeles, Pacific Daylight Time, UTC offset -0700.

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_8_Completion_Report_2026-10-24_152158_01.md`

Status: implemented and verified locally; awaiting owner review. No commit, tag, merge, push, release or executable rebuild.

## Baseline and preservation

Branch: `feature/prototype8-orbital-intelligence`, created from accepted Prototype 7 HEAD `4af29a9c2f73bcd0830b1dfea364138deb02f1f7`. The accepted tag `planetary-prototype7-command-scoring-v1` retains annotated object `590661bd4d8857eb98f831aaaa262679873b5208` and the same commit target. HEAD remains at that accepted commit.

The pre-existing local `Reports/Prototype_7_Git_Checkpoint_Report_2026-10-24_150305_01.md` post-publication addendum was preserved and not edited by this task. Its SHA256 is `9473f6a8be373baaa64bac0a45ac32b446054dede6815d6e03acb3784f92b28c`. It remains modified relative to HEAD, separate from Prototype 8 edits.

Protected files verified identical to accepted Git blobs: all Prototype 3?7 test scripts, enemy movement/input script, orbital deadline, encounter session/outcomes, attack/scenario/strategic JSON, mission JSON/loader/ledger/UI, and existing tactical/enemy/console scenes. No hidden encounter truth, score weights, official replay semantics or original movement speeds were changed.

## Visible features and how to review

Run the source project with F5. The new main entry is `scene/orbital_command.tscn`, a thin inherited instance enabling additional surveillance on the existing command controller. Three centers now each report six monitored contacts: eighteen unique network contacts, three active deadlines. Scroll the existing readable triage table to reach later passive contacts; either sorting mode remains available. Select a row or center to enter the existing tactical view.

Each center retains its original three circular objects, plus three neutral native diamond symbols on distinct elliptical trajectories. Select a symbol to see current public assessment, confidence, latest source, ordered source history, optional suspected payload and advisory options in the existing stationary console. Source markers are `[S]`, `[P]`, `[T]`, `[F]`, always with readable labels. The selected symbol gets an outline; appearance does not encode actual allegiance. Hover freezes only that symbol; mouse exit resumes without catch-up. Passive objects never receive a fabricated countdown or executable defense/investigation/replay controls.

The left objectives panel, prominent countdown, top command levels/navigation, intelligence actions and scorecard keep their accepted bounds. The queue uses native scrolling rather than smaller text. Opening history/scorecard does not automatically pause Challenge simulation. Use Learning strategic pause for reading.

## Architecture and configuration schema

`intelligence_data_loader.gd` validates the entire optional extension atomically before any extra contact is installed. `surveillance_contact.gd` owns only movement, native display and hover/click input; it reads no files or intelligence truth. Each tactical host owns an `intelligence_session.gd` for release/history state. `strategic_registry.gd` projects latest released public assessment/confidence/severity, separately from active-deadline urgency. The existing console renders an explicit public report allowlist. Neither UI nor scoring receives the new private fixtures.

`data/orbital_intelligence.json` has three root collections:

- `traffic`: contact ID, center ID, initial public assessment/confidence/assessed severity, and `path`.
- `reports`: unique report ID, contact ID, source type, text, release condition, public assessment and severity; optional confidence, suspected payload, recommendation text array and supersedes reference.
- `private_fixtures`: stable passive-contact ID keys with private identity and hostile flag, used only for deterministic fixture integrity/tests. Public assessments do not modify these values. Original three encounters retain their separate accepted fixture/resolver.

Source values: SIGINT, Platform Profile, Trajectory Assessment, Follow-up Analysis. Assessment values: Suspected hostile, Uncertain, Assessed nonhostile, Assessment revised. Recommendations are explicitly advisory text; no new action executes from a recommendation. Preparation and passive investigations remain advisory because no matching encounter action exists. Missing confidence/payload/recommendations are labeled not supplied/reported, with no invented values.

Validation rejects missing files/invalid JSON/root structures, duplicate or unassociated contacts, invalid IDs, missing/unsafe path parameters, invalid source/state/severity/confidence, unsupported triggers, passive investigation triggers, malformed optional fields, and supersession references that do not point to a prior same-contact report. Private fixtures may belong only to the newly added traffic. Diagnostics identify the configuration problem without printing private fixture values. On extension failure, a visible overview notice and Godot diagnostic appear; no partial extra traffic is installed, and the accepted nine-contact encounters/mission remain available. This fallback is explicit, not silent substitution.

## Contact counts and movement parameters

Original IDs C-001..C-009 retain their associations; active IDs remain C-001, C-004 and C-007. New IDs are C-010..C-012 at DC-01, C-013..C-015 at DC-02, and C-016..C-018 at DC-03. There are fifteen passive contacts in total (six original and nine new).

Each center reuses these three externally configured paths; angles/rates use radians:

| Path | Horizontal radius | Vertical radius | Orientation | Initial phase | Direction | Angular rate |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 380 | 205 | 0.25 | 0.7 | +1 | 0.22 rad/s |
| 2 | 235 | 330 | -0.32 | 2.8 | -1 | 0.31 rad/s |
| 3 | 340 | 140 | 0.65 | 4.7 | +1 | 0.40 rad/s |

For eligible movement elapsed t, phase = initial_phase + direction ? angular_rate ? t. Position = (800,450) + rotated((horizontal_radius ? cos(phase), vertical_radius ? sin(phase)), orientation). t excludes hover, so no catch-up occurs. Geometry is a visual surveillance trajectory relative to DATA, not a physically validated gravitational orbit. Rotated extrema plus 38 pixels of symbol/label/interaction margin are checked against usable interface bounds. Full-cycle sampling tests also verify separation from left/right panels and essential controls.

Original circular rates 0.49/0.63/0.77 rad/s, radii, full-orbit counting, discrete inward jumps, continuous inner-ring motion and movement-derived 300-second default deadlines remain untouched. DC-02/DC-03 retain their accepted 360/240-second fixture overrides.

## Reports, reassessments and private truth

Forty authored reports are configured: four reports for each of nine new contacts, one additional later C-012 report, and one investigation-triggered source report for each original active encounter.

Developer fixture cases (not normal UI disclosures):

- **A / C-010:** genuine covert contact; initial suspected-hostile report is supported by subsequent directional-emission evidence, still with uncertain attribution.
- **B / C-011:** peaceful probe initially assessed suspected hostile with 100% confidence; at 30 eligible seconds a cross-check favors scientific telemetry and revises toward assessed nonhostile.
- **C / C-012:** private hostile contact initially assessed nonhostile; trajectory/SIGINT evidence increases concern at 16 seconds; a later 45-second report again favors nonhostile with 100% analyst confidence and is wrong. Truth never changes.
- **D / C-013 and other traffic:** evidence remains ambiguous; suspicion and nearby transmissions do not establish identity.

Old report objects/text remain in oldest-first history, marked PRIOR/newer assessment exists, with source, rationale, assessment, confidence, payload and advice. Supersession references identify the earlier report rather than rewriting it. The latest current assessment appears above history. Public projections omit hidden identity, hostile flag, future release schedule and private scoring fields. Tests confirm changing private truth with identical public records leaves the public feed identical. Reports describe possible capability, not an automatically verified loadout.

## Release timing, pause, investigation and replay

Supported deterministic triggers are `elapsed` with nonnegative seconds, and `investigation` on an existing active encounter. Reports follow authored order per contact; an unreleased earlier report blocks later ones. No arbitrary event/milestone inference engine was added.

The schedule derives eligible elapsed time from actual cumulative angular travel divided by angular rate. While strategic pause is active, background movement is subtracted from the release origin on each update. Therefore Learning pause holds **all source delivery** with no catch-up, while preserving accepted moving background traffic. Original active motion/deadlines are held together as before. Hover naturally holds only that contact's movement-derived report schedule. Active Challenge advances reports and movement offscreen. Views, selection and report opening never recapture a release origin or deadline.

New traffic releases at 0, 8, 16 and 30 eligible seconds; C-012 has a further release at 45. Investigation is still the accepted one-use authored action, with no timing cost/automatic ETA completion added. If investigation is requested during strategic pause, the accepted original follow-up remains immediately readable; its new source-feed entry waits until resume. This distinction preserves accepted behavior while preventing autonomous delivery during reading pause.

Replay resets only the original active contact's source history/origin alongside its accepted movement/deadline restoration. Passive histories/trajectories and other centers are untouched. First official resolution remains official; subsequent practice outcomes cannot replace or increase official points. Reports/investigation/navigation/passive observation never score. The mission still has exactly three participants and unchanged category weights. No scoring-formula conflict was introduced.

## Files created and modified

- `project.godot`
- `script/command_center.gd`
- `script/game.gd`
- `script/strategic_registry.gd`
- `script/attack_info_panel.gd`
- `Reports/Orbital_Defense_Command_Game_Concept.md`
- `data/orbital_intelligence.json`
- `scene/orbital_command.tscn`
- `script/surveillance_contact.gd`
- `script/surveillance_contact.gd.uid`
- `script/intelligence_data_loader.gd`
- `script/intelligence_data_loader.gd.uid`
- `script/intelligence_session.gd`
- `script/intelligence_session.gd.uid`
- `tests/prototype8_test.gd`
- `tests/prototype8_test.gd.uid`
- `Reports/Prototype_8_Completion_Report_2026-10-24_152158_01.md`

The checkpoint-report addendum listed above is pre-existing local work, not a Prototype 8 edit. New UID files were generated by Godot import. No artwork download, screenshot, cache, executable, database, cloud or educational-provider artifact was added to the repository.

## Actual verification commands and results

Godot 4.7.2 stable Mono on Windows; rendered Vulkan Forward+ on NVIDIA GeForce RTX 2070, 1600 ? 900 reference viewport.

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
& $godotExe --path . --script res://tests/prototype6_test.gd
& $godotExe --path . --script res://tests/prototype7_test.gd
& $godotExe --path . --script res://tests/prototype8_test.gd
& $godotExe --headless --editor --path . --quit
& $godotExe --headless --path . --quit-after 4
& $godotExe --headless --path . res://scene/game.tscn --quit-after 4
git diff --check
```

| Verification | Actual result |
| --- | --- |
| Prototype 3, unchanged | PASS, 0 failures, exit 0 |
| Prototype 4, unchanged | PASS, 13,048 checks, 0 failures, exit 0 |
| Prototype 5, unchanged | PASS, 992 checks, 0 failures, exit 0 |
| Prototype 6, unchanged | PASS, 229 checks, 0 failures, exit 0 |
| Prototype 7, unchanged | PASS, 241 checks, 0 failures, exit 0 |
| Prototype 8 final | PASS, 1,748 checks, 0 failures, exit 0 |
| Editor import | Exit 0; new script/test UIDs generated |
| Main Prototype 8 and standalone tactical startup | Both exit 0; no startup/script errors |
| Protected-file Git blob checks | All match accepted Prototype 7 |
| Whitespace check | Pass; ordinary line-ending notices only |

Prototype 8 tests cover full-ellipse bounds, all configured motion parameters and deterministic evaluation, three centers/eighteen IDs, six per tactical view, three unchanged mission participants/deadlines, scroll navigation and both sorting modes, actual mouse hover/click including overlapping hit areas, exit without catch-up, offscreen delivery, source loading/negative validation, release order, all four assessment cases, incorrect confidence, truth immutability/public-copy safety, public-truth invariance, report/history readability, pause/resume, advisory/disabled passive actions, direct rejected passive commands/replay, investigation with no points, replay isolation, scorecard access and standalone startup.

Expected missing/invalid-data diagnostics were observed in negative tests, not failed assertions. Intermediate development runs caught new-test GDScript inferred-type errors and JSON float-versus-integer direction membership during configuration validation; these were corrected before final passing runs. No legacy assertion was changed or removed.

## Rendered visual verification

Actually performed: rendered viewport input and screenshot inspection at 1600 ? 900, including crowded six-contact tactical view, selected passive contact, current/revised assessment, source history scrolling, expanded strategic queue, and scorecard access/return. Six symbols remain in the usable area; distinct ellipse outlines are visible. The console retains its 300 ? 772 bounds at (1280,64), its action controls remain outside the report scroll, the left objective panel remains clear, and the scorecard close control is accessible. All eighteen rows remain available via scrolling; the table does not shrink text. No native manual desktop GUI testing is claimed.

Screenshots are outside the repository under `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/`:

- `prototype4_p8_overview.png`
- `prototype4_p8_tactical_history.png`
- `prototype4_p8_history_scrolled.png`
- `prototype4_p8_scorecard.png`

The prototype4 prefix comes from accepted inherited capture helpers. No screenshots are staged or tracked.

## Design decisions, deviations and limitations

- Compatibility entry: normal F5 launches the eighteen-contact inherited scene; directly running the accepted `scene/command_center.tscn` deliberately retains nine contacts for unchanged regressions. This is an explicit compatibility decision, not three copied tactical implementations. Use F5 or `scene/orbital_command.tscn` to review Prototype 8.
- Background motion continues under strategic pause, while its intelligence schedule is held by excluding paused movement. This preserves accepted background motion and avoids unexpected report catch-up. A different full-traffic pause policy requires owner review.
- No additional encounter/deadline/score participation exists, even for a privately hostile passive fixture. Passive recommendations are advisory; no on-demand passive investigation or defense execution was added.
- Reports are authored/local and finite. There is no real SIGINT decoder, physics engine, procedural inference, staffing scheduler, database, cloud, learning-provider integration, persistence or automatic truth disclosure.
- Long source history requires scrolling; there is no dedicated unread-notification badge or report filter yet. Current latest assessment remains at the top when returning to the report start. The fixed 1600 ? 900 layout is verified; arbitrary window responsiveness is not claimed.
- The original current staffing/workload indicators remain labeled static demonstrations, not calculated eighteen-contact staffing.
- Native glyphs are temporary; future art must preserve neutral appearance and knowledge-state labeling. No mandatory art dimensions/formats are prescribed.
- Mission asset/quality/resource categories remain evidence-limited/unassessed as accepted. Reassessments do not establish independently verified identity or change public scoring rules.

No known failing automated checks remain. Recommended next action: owner visual review of the eighteen-contact queue, timing/revision examples and report-history workflow before any checkpoint or further prototype scope. No further gameplay or publication is authorized by this report.
