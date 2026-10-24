# Prototype 7 Completion Report - Command Hierarchy, Mission Objectives and Scoring

Created: 2026-10-24T14:43:47-07:00 - America/Los_Angeles, Pacific Daylight Time (UTC-07:00).

Status: implemented and tested locally; awaiting owner review. No commit, merge, tag, push or release.

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_7_Completion_Report_2026-10-24_144347_01.md`

## Baseline and preserved work

Verified HEAD equals accepted `planetary-prototype6-strategic-command-v1`, commit `4dccf04644a213932570923f655ea745407d8cba`. Created `feature/prototype7-command-mission-scoring` from that tag. The only pre-existing local modification was the Prototype 6 Git checkpoint report's verification addendum; its bytes remain unchanged and it is not part of this implementation's edits.

Read the master concept, Prototype 5/6 completion history, reporting convention and existing regression tests. Three centers, nine contacts, three independent active encounters, six backgrounds, orbital speeds/jumps, hover-freeze, reports, investigation, defense, hold fire, expiration, replay, triage/navigation and Learning/Challenge behavior remain. No scenario truth, artwork, movement script, accepted test, scene or application setting changed. Standalone `scene/game.tscn` remains independently runnable. Accepted tags and HEAD remain unchanged.

## What to review

Run the project normally (F5). The strategic overview now represents **Operations Commander**, with network mission status and the existing center cards/nine-row triage queue. Choose **Tactical Officer** in the top selector, a center card or a contact row to enter one-center focus. The narrow left panel displays local objectives/performance while the existing right intelligence console/countdown/actions remain intact. Return with STRATEGIC OVERVIEW or the Operations Commander selector; the last selected center is remembered for returning to Tactical Officer.

The role changes presentation/responsibility only: no altered truth, difficulty, movement, time budgets, outcomes or pause policy. Shared strategic Learning pause remains explicit; Challenge continues across views. A future **Strategic Commander** tier is documented only; there are exactly two implemented roles, no personnel delegation or 15-center implementation.

The top **Mission scorecard** button opens a bounded, scrollable detail panel. After every active participant has one official resolution, it becomes **Final mission scorecard**. The panel explains weights, confirmed/unassessed capacity, five objectives and official observable outcomes. Opening it does not pause simulation; use Learning strategic pause before reading when desired. Closing returns to the same command context. Hidden tactical hover is released while the modal is open to prevent a stale invisible freeze.

## Data and architecture

`data/mission.json` defines mission ID/title, objective IDs, full/short display text, category weights/maximum, public-evidence scoring rules, unassessed reasons and replay policy. The participant set is drawn from the configured active encounters, not the six background contacts. Mission validation checks required fields, consistent positive weights, five unique objectives, readable short labels, evidence-rule ranges, supported replay/scope and the separate disabled attacker model. Missing/invalid mission data produces a clear diagnostic and disables scoring, while the original tactical simulation/decisions remain available without invented zero scores.

`EncounterSession` emits a trusted internal resolution event only when actual deploy/hold/expiry resolution occurs. It includes the real deterministic result and existing observation/uncertainty; no scoring is added to movement or buttons. `MissionLedger` consumes the event, privately adjudicates the actual outcome and retains the first official resolution per participant. Its explicit public projection contains only known dispositions, existing observable effects, supported points, objectives and applicability reasons. `MissionUI` receives that projection, not private result codes or review fields. The command controller binds center/contact scope and coordinates display/navigation.

## Objectives

Defender mission objectives are data-driven:

1. Protect operational data centers.
2. Correctly resolve active encounters.
3. Avoid unnecessary defensive engagements.
4. Make decisions before applicable deadlines.
5. Maintain operational effectiveness.

Monitored count does not prove operational health. Official disposition count does not assert that every decision was correct. The scoreboard labels these distinctions; it does not silently fabricate damage, resources, staff efficiency or omniscient threat verification.

## Actual scoring formulas and applicability

Default proposed maximum: **1,000**, entirely configured in mission data. For N active participants (currently 3), each assessable event's category contribution is `weight * fraction / N`. Local contributions use the same divisor as the network, so they sum exactly to the network contribution before display rounding.

| Category | Weight | Implemented applicability |
| --- | --- | --- |
| Asset protection | 350 | Publicly unassessed: no complete operational-health/damage verification exists. No invented financial or permanent-loss calculation. |
| Threat resolution | 250 | Reviewed observable blocked attempt: fraction 1. Deliberate hold fire with passage/no observed interference: 1. Observed access disturbance: 0. Expired opportunity: 0, even with a favorable quiet passage. Uncertain or unreviewed effects: null/unassessed. |
| Decision quality | 200 | Publicly unassessed: existing evidence cannot independently verify identity/engagement necessity or sound reasoning. Private actual-outcome adjudication never becomes an automatic public correctness grade. |
| Resource management | 100 | Publicly unassessed: no validated resource costs, quantities, scheduling or personnel-efficiency system. |
| Command effectiveness | 100 | Actual timely deploy/hold disposition: fraction 1; expiry: 0. Explicitly limited to timeliness, not correctness or successful defense. No points from a click that does not resolve an encounter. |

Public totals separately show confirmed points, assessed capacity and unassessed capacity. Categories with no adequate evidence are null/Unassessed, not earned zero. The total is never rescaled to make a partial assessment look like a full 1,000-point judgment. An actual expired disposition is a supported zero for timeliness/resolution, while its asset health can still be unassessed.

With an observed block plus two deliberate quiet passages, the current fixtures can confirm **350 points of 350 assessed capacity**, with **650 unassessed**. Current evidence does not permit a fully confirmed 1,000-point result. A response with uncertain unintended effects contributes no confirmed defense/quality reward; only its known timely disposition can earn the limited command metric. The rendered mixed-outcome test yields about 266.7 confirmed, 266.7 assessed capacity, and 733.3 unassessed.

### Correct, harmful and lucky outcomes without truth leakage

The private review uses actual deterministic results, not public assessed severity/confidence. A high-confidence peaceful-contact deployment records an unnecessary-engagement penalty pending verification, rather than a defense-success bonus. The pending decision-quality penalty is `decision_quality_weight / N` (about 66.7 for one of three participants), represented as lost provisional quality credit, not a second subtraction from an already-zero quality contribution. Appropriate fixture response/restraint can carry private provisional outcome-match credit. These internal values are not independently established reasoning grades.

**Important limitation/interpretation:** the current neutral deployment observation says unintended interference is possible, not that innocent identity or engagement necessity has been independently proven. Therefore the private penalty and quality result remain **withheld/unassessed publicly even at mission completion**. Publishing them would reveal unconfirmed hidden truth. No new scenario fact is invented to justify disclosure. Asset/resource scoring is likewise withheld where unsupported. Owner approval of an independent verification/debrief policy is needed before public identity-dependent penalties or a full correctness grade can be added.

Public scoring rules match reviewed existing observation text; identical public observation/action/uncertainty yields identical public score regardless of private result/adjudication. The side-channel test explicitly changes private actual-result classification while holding all public facts fixed and verifies equal public output. Intentional quiet hold fire earns supported restraint-effect credit; quiet passage after expiry earns no timely-resolution credit, distinguishing fortunate effects from a deliberate decision without exposing affiliation.

## Event ledger and replay policy

- First actual resolution for each mission/center/contact slot is official. Investigating or navigating creates no scored event; repeated button actions and duplicate events cannot add points.
- After that first result, replay remains fully functional practice but cannot replace or increase the official score. Another center's state/score is unaffected.
- Before any official resolution, the existing explicit replay reset remains available; its first eventual actual resolution becomes official. Repeated resets/investigation earn nothing. No new global time/resource rule was introduced to change accepted replay behavior.
- The mission finalizes when all three participants have official dispositions, even if some categories remain unassessed. Later practice does not reopen the official scorecard. Live encounter/deadline counts may describe practice, while official counts remain fixed and labeled separately.
- Ledger state is in memory only. Restarting the application begins a new mission; no persistent high-score, account or save/load system exists.

## Future attacker architecture

A separate, disabled `attacker_future` configuration and master-design section describe reconnaissance, disruption, unauthorized control, designated-target damage, and resource preservation/stealth. Proposed attacker weights are mission objectives 400, target impact/control 250, stealth/deception 150, resource efficiency 100, coordination 100 (total 1,000).

No attacker ledger, controls, staffing, resources or interface are instantiated. A future role-specific ledger/adjudicator can reuse the same event/idempotency/public-projection pattern with separate role namespaces and knowledge boundaries; defender private records must not be forwarded across roles. These general future objectives do not expose actual contacts' hidden objectives in the defender UI.

## Files created and modified

| File | Change |
| --- | --- |
| data/mission.json | New configurable mission, objectives, weights, reviewed observable-effect rules and separate future attacker model |
| script/mission_data_loader.gd and .uid | New atomic mission validation and diagnostics |
| script/mission_ledger.gd and .uid | New official first-resolution ledger, private adjudication and explicit public projections |
| script/mission_ui.gd and .uid | New command-level selector, network/local confirmed display and bounded scorecard |
| script/command_center.gd | Connects mission events, coordinates role/modal presentation; moves/reduces center cards to fit scoreboard without shrinking nine-contact queue |
| script/encounter_session.gd | Adds internal resolution signal; existing deterministic outcomes/reset logic unchanged |
| tests/prototype7_test.gd and .uid | New model, privacy, data validation and rendered integration checks |
| Reports/Orbital_Defense_Command_Game_Concept.md | Updates implemented baseline through P6/P7; adds Sections 19-21 for hierarchy, scoring and future attacker architecture; preserves story, uncertainty, 2D/2.5D and learning roadmap |
| Reports/Prototype_7_Completion_Report_2026-10-24_144347_01.md | This uniquely timestamped report |

Pre-existing local `Reports/Prototype_6_Git_Checkpoint_Report_2026-10-24_133906_01.md` remains modified relative to Git because of its earlier addendum, but was not edited or incorporated into Prototype 7 work. All earlier tests and completion reports remain unchanged.

## Test commands and actual results

Godot 4.7.2 stable Mono on Windows; rendered Vulkan Forward+ / NVIDIA GeForce RTX 2070, reference viewport 1600 x 900.

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
& $godotExe --path . --script res://tests/prototype6_test.gd
& $godotExe --path . --script res://tests/prototype7_test.gd
& $godotExe --headless --editor --path . --quit
& $godotExe --headless --path . --quit-after 4
& $godotExe --headless --path . res://scene/game.tscn --quit-after 4
```

| Verification | Actual result |
| --- | --- |
| Prototype 3 | PASS, 0 failures, exit 0 |
| Prototype 4 | PASS, 12,984 checks, 0 failures, exit 0 |
| Prototype 5 | PASS, 992 checks, 0 failures, exit 0 |
| Prototype 6 | PASS, 229 checks, 0 failures, exit 0 |
| Prototype 7 final | PASS, 241 checks, 0 failures, exit 0 |
| Main command-center and standalone tactical startup | Both exit 0, no script/startup errors |
| Headless editor import | Exit 0; required new script/test UID files generated |
| Whitespace/document-link and file-preservation checks | Pass; normal Git line-ending notices only |

All legacy test files are byte-identical to the accepted checkpoint. Prototype 4's count varies with sampled render frames. Expected invalid/missing-data diagnostics occurred in negative tests; final runs had no script errors. Intermediate new-test runs exposed an overbroad privacy substring assertion matching a legitimate objective ID, an input-layout observation timing issue in the new test, and overflowing local text; these were corrected before final passing runs without changing legacy assertions or scenario truth.

Prototype 7 covers both levels, network/local aggregation, all H/N/N100 decisions and expiry, actual movement-driven expiration event delivery, deterministic actual adjudication, high-confidence peaceful interference, known zero versus unassessed, withheld penalties, no click/navigation rewards, repeat/replay isolation, finalization, mutated public-copy safety, public/private side-channel invariance, missing/malformed mission data, strategic pause/Challenge preservation, objective text sourced from data, panel/report scrolling and close/navigation access.

## Rendered visual verification and screenshots

Actually performed: rendered viewport mouse interaction and screenshot inspection at 1600 x 900. Operations status fits above three compact cards; all nine triage rows remain visible. Tactical local panel sits at x=16..316, outside the enlarged orbital hit area beginning at x=328 at the leftmost outer-ring position. Existing right console remains Rect2(1280,64,300,772); countdown, intelligence/SIGINT and all actions remain usable. Detailed scorecard is bounded with a fixed return control and scrollable categories/objectives/outcomes; wheel interaction was tested. No native manual desktop GUI testing is claimed.

Screenshots are outside the repository in `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/`:

- `prototype4_p7_operations_initial.png`
- `prototype4_p7_tactical_objectives.png`
- `prototype4_p7_operations_final.png`
- `prototype4_p7_scorecard.png`
- `prototype4_p7_scorecard_outcomes.png`

The prefix is inherited from existing capture helpers. Screenshots contain only the public observations/projections, not private fixture identities.

## Known limitations and owner decisions

- Only evidence-supported effects/timeliness are publicly scored. Asset protection, decision quality and resource management remain unassessed (650 of 1,000 at best with current fixtures); unused capacity is not secretly treated as zero or normalized away.
- Pending unnecessary-engagement penalties are internal only until independent verification/disclosure is approved. Timeliness credit can accompany an uncertain/harmful response and must not be read as a successful-defense or sound-reasoning score. Future epistemic decision-quality criteria require review.
- First-resolution-official replay semantics deliberately preserve original score after practice. Owner should review whether this is the desired mission policy before checkpointing. Persistence/new mission controls are not implemented.
- Operational health is unassessed despite three monitored centers; no downtime, money, resources, personnel efficiency or damage values were fabricated.
- Two command levels are single-player perspectives, not account permissions or delegation. Strategic Commander and attacker play remain future-only.
- Fixed 1600 x 900 layout was checked; long scorecards scroll. Short objective labels are limited to 32 characters by validation for this compact display. Large-scale networks/responsive layouts are not claimed.
- Learning providers, databases, full staffing and cloud infrastructure remain absent. Local data/debug inspection is a development boundary, not encryption or anti-cheat.

Ready for owner visual review. No publication or next-prototype work is authorized by this handoff.
