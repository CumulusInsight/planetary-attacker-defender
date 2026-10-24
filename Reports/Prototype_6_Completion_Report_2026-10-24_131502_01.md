# Prototype 6 Completion Report - Strategic Overview and Tactical Navigation

Created: 2026-10-24T13:15:02-07:00 - America/Los_Angeles, Pacific Daylight Time (UTC-07:00).

Status: implemented and tested; ready for owner review, uncommitted on `feature/prototype6-strategic-overview`.

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_6_Completion_Report_2026-10-24_131502_01.md`

## Baseline and preservation

Read the updated master design, Prototype 5 completion history, report convention and existing regression tests before changes. Prototype 5 was reviewed but remains uncommitted in the shared working tree; the Git HEAD remains accepted Prototype 4 commit `16dc097421e4f2b1159ab3f5095db408e115b11e`. Created the Prototype 6 feature branch without discarding that work or pretending a new baseline commit exists.

The original tactical scene, information-panel scene, attack/scenario JSON, orbital-deadline component, all Prototype 3/4/5 test files, artwork, previous reports and unrelated work remain byte-for-byte unchanged from this assignment's start. Existing movement speeds 0.49/0.63/0.77, full-revolution inward jumps, continuous inner-ring motion, enlarged hit areas, highlight/selection, authored reports, deterministic decisions and replay remain intact. No executable was rebuilt. No commit, tag, merge, push, release, reset, stash or history rewrite was performed.

## Delivered behavior and how to run

Run the project normally (F5): `scene/command_center.tscn` is now the main scene. The existing Prototype 5 tactical scene remains independently runnable via `scene/game.tscn` (select that scene and F6), with its original local reading-pause behavior.

The strategic overview presents three selectable center cards and a one-page nine-contact triage table. Cards show center ID, monitored count, number of live deadlines, most urgent contact/time, highest assessed severity and text-based attention state. Click a center card to focus its retained tactical view, or click any triage row to navigate to its center and highlight that contact. STRATEGIC OVERVIEW at the top returns without resetting simulation. The selected center is identified in the top header.

The table shows stable contact ID, center association, public officer assessment, supplied confidence (otherwise Not given), assessed severity, applicable time remaining, and encounter status. Longer assessments have a public-only tooltip; full reports are available tactically. There is no combined threat score.

- Earliest deadline: live deadlines ascending, then contacts without an applicable live deadline; contact ID breaks ties.
- Highest assessed threat: authored public severity category descending, then contact ID. This does not mix in urgency or hidden identity.
- Background contacts have no invented countdown or encounter decision. Resolved/expired contacts no longer contribute a live deadline; their status explains closure.
- Attention uses public facts only: expired opportunity, live deadline within one minute, or review of high assessed severity. Amber is accompanied by explicit text, never a hidden-hostile badge.

## Encounter scope and fixture decisions

| Center | Monitored contacts | Active encounter | Window | Public assessed severity | Developer-only fixture |
| --- | --- | --- | --- | --- | --- |
| DC-01 | C-001 / C-002 / C-003 | C-001 | 300 seconds, accepted default | Moderate | H |
| DC-02 | C-004 / C-005 / C-006 | C-004 | 360 seconds, explicit demonstration override | High | N100 |
| DC-03 | C-007 / C-008 / C-009 | C-007 | 240 seconds, explicit demonstration override | Low | N |

Thus there are three deterministic active encounters and six unknown background contacts, not nine automatically hostile objects. In developer truth, DC-02's high-confidence hostile assessment is wrong about a peaceful probe. Its truth stays peaceful regardless of severity/confidence. The active contact uses the same first-slot artwork in all three fixtures. Normal UI never prints fixture keys, identity/objective, private capability profile or actual result codes.

The fixture windows are explicitly disclosed in the overview footer and local configuration. The default remains five minutes when an override is omitted. From startup, deadline sorting prioritizes C-007, while severity sorting prioritizes C-004, making urgency versus assessment visible without a hidden combined score. H/N/N100 outcomes and one-follow-up limits reuse the existing Prototype 5 resolver unchanged.

## Architecture

- `data/strategic_centers.json` defines centers, stable contact IDs/association, the active contact per center, public severity/background metadata, developer fixture selection and optional duration override. The loader validates IDs globally, associations, values and fixtures atomically, with clear failure diagnostics and no substitute data.
- `strategic_registry.gd` owns registry associations/public metadata and references authoritative tactical state. Its explicit public rows/center summaries read assessment/confidence through a new public-only session accessor. Sorting and attention never read `private_truth`.
- `command_center.gd` loads/configures reusable tactical instances, coordinates mode/pause/navigation, and builds the strategic UI using the existing font/conventions. It does not resolve defense correctness or integrate staffing/learning services.
- Every center uses the same `scene/game.tscn`, movement scripts, console and session/deadline components. There are no three independently maintained scene copies. Each instantiated center retains its own state for the application session; navigation changes visibility/input picking, not lifetime or time budget.
- Tactical data still passes through existing attack JSON validation. Managed contact-ID remapping and dynamic population use the validated movement/display templates. A one-center/four-contact test proves the registry/loader/component population is not fixed to exactly three by architecture. The authored normal game remains three by three.
- Offscreen tactical rendering/console and mouse picking are disabled, while processing continues. Leaving tactical clears hover so an invisible contact cannot remain accidentally frozen.

## Explicit simulation policy

All deadlines continue using actual cumulative orbital travel: capture B = abs(speed) * window_seconds, then remaining = max(0, B - (S-S0)) / abs(speed). No second timer, wall-clock drift or new global clock was introduced. Movement processes before tactical deadline observation and strategic UI refresh.

**Active Challenge:** all center encounters and background contacts keep progressing when the player views another center or the overview. Tactical hover still freezes only the hovered contact; leaving the view releases hover. Switching/selecting never extends a deadline.

**Learning Mode:** an explicit top-header **Strategic pause (read)** control holds all configured encounter contacts and their movement-derived clocks together; background traffic continues. Pause state is visible in the header and tactical console. Navigation does not release it; replay cannot release it or reset other centers. Resume consumes only subsequent movement deltas, with no catch-up. Switching to Challenge clears and disables this pause. Resolved encounter hosts also retain the shared movement hold while strategic pause is on; their already-closed clocks stay closed.

In the managed multi-center view, the standalone Prototype 5 local mode/reading controls are hidden so they cannot create conflicting pause scopes. The shell owns the explicit strategic controls. Standalone Prototype 5 retains its original local behavior; all its regression tests were preserved, not weakened. No unresolved accepted-behavior conflict was found. No SceneTree/global pause is used.

Replay affects only the selected active contact/session: initial orbit/ring/progress/full window and authored evidence/decision state restore; other centers/backgrounds are untouched. A shared strategic pause remains on if it was on. Expiration stays distinct from deliberate hold fire, rejects late timely actions and uses the existing deterministic no-intervention branch, without exposing private truth or calculating financial damage.

## Files created and modified for Prototype 6

| File | Purpose |
| --- | --- |
| project.godot | Main scene points to strategic command shell |
| script/game.gd | Optional managed mode, contact-ID/population configuration, active-contact index, shared pause/visibility/input hooks; default standalone behavior retained |
| script/enemy.gd | Adds separate strategic movement-hold flag alongside existing hover/local-reading holds |
| script/attack_info_panel.gd | Managed-control visibility and explicit strategic-pause status |
| script/encounter_session.gd | Public-only assessment/confidence accessor; resolution logic unchanged |
| data/strategic_centers.json | New deterministic three-center/nine-contact configuration |
| scene/command_center.tscn | New reusable command-shell entry scene |
| script/command_center.gd and .uid | New navigation, pause coordination and strategic presentation |
| script/strategic_registry.gd and .uid | New public contact registry, two triage orders and center summaries |
| script/strategic_data_loader.gd and .uid | New atomic configuration validation |
| tests/prototype6_test.gd and .uid | New rendered strategic integration and configuration/scaling checks |
| Reports/Prototype_6_Completion_Report_2026-10-24_131502_01.md | This new uniquely timestamped completion report |

No prior completion report was overwritten. Existing Prototype 5 changes remain in Git status along with these new changes; a Git diff against HEAD includes earlier work, so preservation was checked against a task-start file-hash snapshot as well.

## Test commands and actual results

Environment: Windows, Godot 4.7.2 stable Mono; Vulkan Forward+ / NVIDIA GeForce RTX 2070. Rendered tests use an isolated 1600 x 900 SubViewport with automated mouse events.

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
& $godotExe --path . --script res://tests/prototype6_test.gd
& $godotExe --headless --editor --path . --quit
& $godotExe --headless --path . --quit-after 4
```

| Verification | Actual final result |
| --- | --- |
| Prototype 3 | PASS, 0 failures, exit 0 |
| Prototype 4 | PASS, 12,904 checks, 0 failures, exit 0 |
| Prototype 5 | PASS, 992 checks, 0 failures, exit 0 |
| Prototype 6 | PASS, 229 checks, 0 failures, exit 0 |
| Headless editor import and main-scene startup smoke | Exit 0, no script/import errors on corrected implementation |
| git diff --check and direct new-file whitespace checks | Pass; existing normalization notices only |
| Task-start SHA-256 preservation | Only five intended existing files modified; prior tests/scenes/data/reports and unrelated files preserved |

Prototype 4's frame-sampling check count can vary with rendered frame cadence; its test source was byte-for-byte unchanged. Expected missing/invalid-data diagnostics were emitted by the legacy negative tests. An initial development startup identified two type-inference errors; these were corrected before final startup/tests.

Prototype 6 checks three centers/nine unique IDs, per-center counts and urgent contacts, association, public severity/confidence, both actual selector orders and disagreement between urgency/severity, no background deadlines, independent offscreen progression, shared pause/exact resume, background motion during pause, navigation without reset, cleared stale hover, rendered tactical hover, public/visible truth privacy (including buttons), investigation/deploy/hold/expiry/replay for hostile and neutral fixtures, paused replay isolation, center attention updates, one-page queue bounds and configurable population. Controlled movement deltas exercise full expiration without a five-minute wall-clock wait. No legacy assertions were removed or weakened.

## Rendered screenshots and visual verification

Actually performed: rendered automated viewport input plus inspection of initial strategic overview, strategic pause, tactical paused console and outcome overview at 1600 x 900. All nine queue rows fit on one page without vertical scrolling. Column headings/countdowns and center cards are readable; longer assessments are deliberately shortened with tooltips. Tactical console retains Rect2(1280,64,300,772), scrolling reports and all four action/replay controls. The navigation/mode/pause header lies above the orbital tracks and does not cover DATA or contact click areas. Background objects remain visible/moving in tactical view.

Screenshots are outside the repository under `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/`:

- `prototype4_p6_initial_overview.png` - initial 5/6/4-minute windows and nine-row queue.
- `prototype4_p6_overview.png` - triage after controlled test progression makes urgency differ further.
- `prototype4_p6_paused_overview.png` - explicit shared reading pause.
- `prototype4_p6_tactical_paused.png` - center-focused accepted tactical layout under strategic pause.
- `prototype4_p6_outcomes.png` - expired-status/attention summaries without identity disclosure.

The prefix comes from inherited screenshot helpers. No native manual desktop GUI interaction test was performed or claimed; owner review is still required.

## Known limitations and decisions for owner review

- One encounter per center is supported in this increment, not several simultaneously active contacts within one center. Six other contacts are unknown background traffic. More elaborate assignment/state models are future work.
- Configuration/registry population is data-driven, but presentation is tuned for three centers/nine contacts. Large environments such as 15/45 need a separately reviewed overview/card layout and performance pass. Persistent tactical instances are appropriate for this small prototype, not a claim of large-scale optimization.
- Public severity metadata and confidence are authored, not inferred by an AI engine. Follow-up/decision statuses update; no new general assessment-revision or standardized-report pipeline exists. Highest-assessed values can remain after closure; clearing/deprioritizing historical assessments needs an approved policy.
- Shared pause deliberately holds encounter hosts only, not background traffic. Default Learning Mode is unpaused until the explicit control is enabled. This replaces local reading scope only inside the new managed shell.
- Staffing/workload/analysis ETA remain the existing static demonstration panel, not real global scheduling or aggregated staff allocations. No database, provider integration, cloud, scoring, finances or diplomacy was added.
- Local fixture data remains developer-inspectable. Privacy is a public-presentation boundary, not encryption/anti-cheat. State lasts for the application session; no save/load persistence was introduced.
- Center cards are schematic status controls rather than a geographic/orbital network map. The fixed reference resolution was checked; responsive layouts are not claimed.

Owner review should assess the 5/6/4-minute demonstration pacing, triage readability, attention wording, and shared Learning pause policy. Further scope and checkpoint/publication require separate authorization. Stop for review after this handoff.
