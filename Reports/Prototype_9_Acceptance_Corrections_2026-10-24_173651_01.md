# Prototype 9 Acceptance Corrections - Defensive Feedback and Header Sorting

Created: 2026-10-24T17:36:51-07:00 - America/Los_Angeles, Pacific Daylight Time, UTC offset -0700.

Full path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_9_Acceptance_Corrections_2026-10-24_173651_01.md`

Status: implemented and locally verified; awaiting owner review. No commit, tag, push, merge, release or Prototype 10 work.

## Repository and preserved work

Branch: `feature/prototype9-contact-escalation`.
Accepted HEAD/tag target remains Prototype 8 `a532946cfc2a22a503263eaf07cd2825590615c2`, tag `planetary-prototype8-orbital-intelligence-v1` (annotated object `bcfbae6d2a6b1ecb8ef381367979ff7ec47b72ce`). All pre-existing uncommitted Prototype 9 work is retained. The earlier completion report `Prototype_9_Completion_Report_2026-10-24_163400_01.md` is preserved as history and superseded only for these corrections.

The known pre-existing `Reports/Prototype_8_Git_Checkpoint_Report_2026-10-24_154943_01.md` addendum remains byte-identical, SHA256 `2d3891b85f20285440ba2953bff5115ccea9ef0b7be98f8bdb96668096755431`. No staging or Git checkpoint/publication occurred.

## Investigation and root cause

The two paths were inspected separately:

1. **Original encounters C-001/C-004/C-007:** `game.gd` synchronizes the existing movement-derived deadline before calling `EncounterSession.act`. A successful defense resolves once using the existing deterministic fixture and emits the existing resolution signal. Further motion cannot expire an already resolved session. Expiry at/beyond zero runs first, so a late deployment is rejected.
2. **P9 elliptical escalations:** `OperationsSession` records separate command-issued, action-executed, observation and resolution events. Shipped new contacts have no operational deadline. Deployment remains an abstract acknowledgment with unverified effect, not an original tactical defense or confirmed destruction.

A controlled **pre-change** headless probe advanced actual authoritative orbital travel and invoked the existing original handler. Results:

| Remaining time at request | Recorded decision | Resolution signals | Later progression |
| --- | --- | --- | --- |
| +0.001 seconds | deploy | 1 | Decision recorded; no later expiry |
| Exactly 0 | expired | 1 | DEADLINE EXPIRED; deployment not accepted |
| -0.001 seconds | expired | 1 | DEADLINE EXPIRED; deployment not accepted |

This verifies the controlled state-model boundary, **not the owner's exact manual click**. No original incident recording existed to retrospectively identify whether that particular click was timely, late or unreceived. The code did not show a valid pre-expiry decision being lost in the controlled reproduction.

The observed feedback weakness is supported by source inspection: original rejected commands had no acknowledgment (`_on_command_requested` handled only success); observable results lived in long scrollable intelligence text; there was no persistent per-center public after-action receipt history. Strategic pause also replaced a resolved countdown caption with the generic pause notice. P9 had an event ledger, but its immediate message was only a generic recorded-action string. Corrections address visibility and audit context while preserving authoritative outcome/deadline rules.

## Correction A - exact changes

### Original active encounter feedback

- Subscribe to the **existing** `resolution_recorded` signal and retain an explicit public receipt projection. No second resolution or scoring signal is emitted; no private outcome code/identity is copied into UI receipts.
- Fixed lower-left summary card and persistent footer banner show contact ID, COMMAND ACCEPTED / COMMAND REJECTED / DEADLINE EXPIRED, remaining time, executed or rejected action, current disposition and existing public observation. The summary sits below objectives, outside orbital input space.
- A persistent **After-action history** button opens all per-center receipts with attempt/receipt identifiers and public uncertainty. History survives contact selection, navigation and tactical replay during the session. Replay clears stale current-result display while retaining prior attempts.
- Identical repeated rejection receipts are coalesced. Accepted outcomes remain single-emission authoritative session resolutions. A repeated/late request cannot overwrite a previous valid result or farm official score.
- Closed positive countdowns are labeled **TIME AT ACCEPTANCE**. They retain Decision recorded while movement continues beyond the deadline and while Learning strategic pause is enabled. Actual expiry retains DEADLINE EXPIRED. No countdown, orbital speed, progress budget or fixture truth was changed.
- Public receipts are also included in the scrollable right console, but accepted Prototype 5 outcome auto-scroll is retained. Immediate feedback no longer depends on the scroll position. Long observations can scroll inside the summary/history.
- Times use the existing remaining-travel calculation. Display includes conventional HH:MM:SS rounded up plus millisecond text; raw receipt data retains the authoritative float.

### P9 abstract deployment feedback

- Reuse the existing operational event ledger; command-issued/rejected events gain public acceptance status and applicable configured remaining time.
- Immediate operations receipt includes contact ID, acceptance/rejection, configured time at acceptance/rejection or No confirmed deadline, current disposition, abstract execution and an explicit **OUTCOME UNVERIFIED** statement.
- Existing command/execution/observation and after-action event history remain inspectable in the same operations console. No duplicate operational resolution ledger or point system was added.
- Abstract interception is not guaranteed success, neutralization, destruction or damage. The existing authored uncertainty remains unchanged.

The exact-zero rule remains: expiration wins at zero, while positive remaining time permits the original valid command. The same behavior is tested for explicitly configured P9 operational windows; no window was added to shipped contact data.

## Correction B - main strategic table sorting

All seven required headers are clickable: Contact, Center, Public intelligence assessment, Confidence, Severity, Time to act and Operational state/status. First click sorts ascending; a second click on that header reverses. Active header ^ / v markers and a textual ascending/descending heading are visible. The preset selector identifies header mode; selecting a preset restores its accepted mode.

Comparison rules:

- Contact IDs: numeric.
- Center/assessment/state: case-insensitive public text.
- Severity: ordinal 0..3, never alphabetical.
- Confidence and deadlines: numeric values, not formatted strings.
- Missing/null confidence and no-deadline values: **last in both directions**.
- Equal sort keys: ascending numeric Contact ID, independent of direction.

Sorting reads only released public assessments, public operational state and applicable configured deadlines. No hidden affiliation, outcome or combined threat score enters the comparator. Existing TreeItem objects are reordered in place when the population is unchanged, preserving native selection, scroll position and row navigation across intelligence updates. All eighteen contacts remain readable/scroll-accessible at the existing font size and viewport. The dedicated operations queue retains its filters and priority semantics.

## Files modified by these corrections

- `script/game.gd`
- `script/attack_info_panel.gd`
- `script/command_center.gd`
- `script/contact_operations.gd`
- `script/operations_session.gd`
- `script/operations_ui.gd`
- `Reports/Orbital_Defense_Command_Game_Concept.md`

## Files created by these corrections

- `script/action_feedback.gd`
- `script/action_feedback.gd.uid`
- `script/contact_table_sort.gd`
- `script/contact_table_sort.gd.uid`
- `tests/prototype9_corrections_test.gd`
- `tests/prototype9_corrections_test.gd.uid`
- `Reports/Prototype_9_Acceptance_Corrections_2026-10-24_173651_01.md`

Other unstaged/untracked Prototype 9 implementation files were already present and are preserved. No earlier completion report, gameplay fixture, artwork, executable or accepted test was overwritten.

## Actual tests and results

Godot 4.7.2 stable Mono, Windows; rendered Vulkan Forward+ on NVIDIA GeForce RTX 2070; reference viewport 1600 x 900.

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
& $godotExe --path . --script res://tests/prototype6_test.gd
& $godotExe --path . --script res://tests/prototype7_test.gd
& $godotExe --path . --script res://tests/prototype8_test.gd
& $godotExe --path . --script res://tests/prototype9_test.gd
& $godotExe --path . --script res://tests/prototype9_corrections_test.gd
& $godotExe --headless --editor --path . --quit
& $godotExe --headless --path . --quit-after 4
& $godotExe --headless --path . res://scene/game.tscn --quit-after 4
git diff --check
```

| Verification | Actual final result |
| --- | --- |
| Prototype 3 unchanged | PASS, 0 failures, exit 0 |
| Prototype 4 unchanged | PASS, 13,048 checks, 0 failures, exit 0 |
| Prototype 5 unchanged | PASS, 992 checks, 0 failures, exit 0 |
| Prototype 6 unchanged | PASS, 229 checks, 0 failures, exit 0 |
| Prototype 7 unchanged | PASS, 241 checks, 0 failures, exit 0 |
| Prototype 8 unchanged | PASS, 1,748 checks, 0 failures, exit 0 |
| Prototype 9 unchanged | PASS, 311 checks, 0 failures, exit 0 |
| New P9 corrections suite | PASS, 266 checks, 0 failures, exit 0 |
| Main and standalone tactical startup | Both exit 0, no script/startup errors |
| Godot editor import | Exit 0; new UID files generated |
| Whitespace/integrity checks | PASS; normal line-ending notices only |

Coverage includes H/N/N100 requests at +0.001/0/-0.001 seconds, unchanged deterministic public outcomes, subsequent progression without contradictory expiry, rejection feedback, accepted-signal counts, official score invariance, rejection coalescing, history mouse access/replay retention, default abstract unverified/no-deadline receipts, configured operational-window boundaries and token idempotency, all actual header clicks in both directions, numeric/ordinal values, absent/null confidence/deadline placement, stable Contact ID ties, selected row/scroll retention during updates and navigation after sorting, and private-truth exclusion.

The full Prototype 3-9 run passed after retaining existing outcome auto-scroll. An intermediate attempt to force reports to the top conflicted with six accepted Prototype 5 outcome-scroll assertions; that change was removed, and separate fixed feedback provides the requested visibility. No legacy assertion was weakened. An intermediate new check caught missing explicit UNVERIFIED wording; it is now present. An initial Tree scroll-setter experiment was replaced with in-place native item reordering before final passing runs.

Expected invalid/missing-data diagnostics occur in negative tests. New test logs and repeated P5-9 verification logs are outside the repository at `%TEMP%/odc_p9_acceptance_checks/`. The pre-change boundary probe script is also external in `%TEMP%/odc_p9_feedback_probe.gd`.

## Rendered verification and screenshots

Actually performed: rendered viewport mouse input and screenshot inspection at 1600 x 900. Accepted original action shows TIME AT ACCEPTANCE, resolved disposition, observed result in its fixed summary, and persistent history control. The original console retains its accepted auto-scroll and controls. Abstract operation shows COMMAND ACCEPTED and OUTCOME UNVERIFIED, and the header sort marker/direction is visible. All table rows remain accessible; actions and navigation remain readable. No native manual desktop GUI testing or reproduction of the owner's exact manual incident is claimed.

Screenshots outside the repository: `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/`:

- `prototype4_p9_fix_countdown_resolved.png`
- `prototype4_p9_fix_original_history.png`
- `prototype4_p9_fix_abstract_receipt.png`
- `prototype4_p9_fix_header_sort.png`

The prefix comes from the unchanged rendered capture helper. No generated screenshot/cache is staged or tracked.

## Known limitations

- These are explicit public receipts, not a new defense animation or combat simulation. Original outcomes use accepted fixtures; new interceptions remain abstract/unverified.
- Histories are in memory and original receipts are scoped per tactical center. Returning to that center restores access; no persistent disk export or network-wide original receipt archive was added.
- Long outcomes/history scroll within fixed bounds. Opening history does not auto-pause simulation; use Learning strategic pause when needed. No new reading penalty exists.
- Header sorting is local-session UI state; presets and dedicated operations queue remain separately defined. Text sorts are case-insensitive lexical order, not a new assessment-severity inference.
- The owner's exact near-expiry click cannot be retrospectively classified without its original input/state capture. Controlled probes and rendered tests establish current boundary behavior and visibility.

## Git status

All pre-existing Prototype 9 work plus these corrections remain unstaged/uncommitted on `feature/prototype9-contact-escalation`. The pre-existing Prototype 8 report addendum is intact. HEAD and accepted Prototype 8 tag remain unchanged. No commit, tag, push, merge, release or Prototype 10 work occurred. Await owner review.
