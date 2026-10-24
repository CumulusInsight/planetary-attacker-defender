# Prototype 5 Completion Report - Live Orbital Deadline Refinement

Created: 2026-10-24T11:56:26-07:00 - America/Los_Angeles, Pacific Daylight Time (UTC-07:00).

Status: implemented, tested, uncommitted; ready for owner review. Work remains on `feature/prototype5-intelligence-defense` at accepted Prototype 4 HEAD `16dc097421e4f2b1159ab3f5095db408e115b11e`. No Prototype 6 work, commit, merge, tag, push, or executable rebuild occurred.

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_5_Completion_Report_2026-10-24_115626_01.md`

## Required source review and preserved work

Read the existing concept, original Prototype 5 report, latest timestamped follow-up (`Prototype_5_Completion_Report_2026-10-24_111602_01.md`), report convention, and actual movement/controller/session/console implementation before editing. All earlier reports remain unchanged. Existing uncommitted Prototype 5 implementation and unrelated concept document are preserved. This report supersedes earlier no-countdown/no-motion-reset descriptions only for this explicitly authorized refinement.

## Authoritative progression formula

The accepted movement update uses travel = angular speed * delta, wraps orbit angle modulo 2*pi, adds absolute travel to orbit_progress, and subtracts 2*pi for each completed revolution, jumping inward one ring down to ring 0. Hover returns before all these updates; selection alone does not stop motion.

Before coding, the chosen relationship was documented in the task progress update:

- Add a cumulative total_orbit_travel counter S using exactly the same absolute travel as orbit_progress. It never wraps at a ring transition and does not run independently of movement.
- Capture initial travel S0, angle, within-orbit progress, and ring after contact initialization.
- Configure a budget B = 2*pi*R, where controller deadline_revolutions R defaults to 3.0.
- Remaining radians = max(0, B - (S-S0)). Remaining simulation seconds = remaining radians / abs(move_speed).
- Default C-001 speed remains 0.49 radians/second, giving 38.46848147 seconds from capture. Default outer-ring start jumps to middle after one revolution, inner after two; expiration occurs after the third, following one full inner revolution. Inner-ring arrival is not a collision or loss.

No second timer, wall-clock accumulator, or strategic clock exists. The controller observes after contact movement via process priority 10, while contacts retain priority 0. It also synchronizes before commands/selection so a late action cannot bypass expiration. Ring changes do not reset S or the deadline. Other speeds remain 0.63/0.77, and all original ring geometry/jump behavior is retained.

## Console and behavior

A dedicated TIME REMAINING TO ACT heading and high-contrast 32-point numerals now sit immediately below the console heading. HH:MM:SS updates each simulation frame using rounded-up remaining seconds; day values wrap onto two lines without widening the panel. Text states distinguish the normal window, approaching deadline (20 seconds or less), final 10-second urgency, recorded decision, and DEADLINE EXPIRED. Urgency does not depend on color alone.

Staff/workload remain visible and explicitly marked static demonstration values in smaller type. Estimated intelligence-analysis time remains a separate `Est. analysis` indicator, not a scheduler or completion timer. The previous static time-to-act value was removed from demonstration data and resource text; there is only one displayed authoritative deadline.

- Hovering active contact holds both movement and remaining time exactly; other contacts continue. Mouse exit advances only by subsequent deltas, without catch-up.
- Selecting/reselecting contacts does not recapture the deadline. Background contacts display --:--:-- and No active deadline, with no inherited analysis ETA or scenario actions. The active encounter still progresses while a background contact is selected.
- Investigation remains one authored follow-up and neither completes from the ETA nor resets/extends time. Movement continues while reports are read unless the active contact itself is hovered.
- Timely defense or explicit hold fire resolves as before. The display then retains the remaining time at decision with Decision recorded, rather than continuing an already-closed opportunity. All objects continue moving.
- At zero, EncounterSession records the separate internal decision `expired`. Timely investigation/defense/hold-fire controls disable; replay remains available. The deterministic late/no-intervention outcome deliberately reuses the fixture's authored hold_fire observation/result: H permits interference, N/N100 legitimate passage. The action/state is expiration, never an explicit hold_fire choice. Public text states Deadline expired (no timely intervention), without revealing private identity/profile. No financial loss or random outcome is calculated.
- Replay restores only the active contact's captured angle, progress, ring/radius, total travel, and full budget, while resetting session evidence/decisions. It preserves selection and the accepted hover input state; background motion is untouched. Same fixture/actions and simulated progression produce the same outcome. Ordinary selection cannot perform this reset.

## Files created/modified in this refinement

| File | Change |
| --- | --- |
| script/orbital_deadline.gd and .uid | New movement-derived deadline adapter, initial snapshot, controlled restore |
| script/enemy.gd | Cumulative absolute-travel telemetry added beside existing progress accumulation; no changed speed, geometry, freeze or selection logic |
| script/game.gd | Configurable budget, post-movement observation, pre-command expiration, public clock updates and active-only replay restoration |
| script/encounter_session.gd | Explicit expiration state and deterministic no-intervention resolution, distinct from hold fire |
| script/command_status.gd | Removes fabricated demo deadline; preserves staff/workload and separate demonstration analysis estimate |
| script/attack_info_panel.gd | Public countdown formatting and textual urgency/closed states |
| scene/attack_info_panel.tscn | Prominent clock; restrained spacing/title adjustments retain original console bounds and accessible controls |
| tests/prototype5_test.gd | Expanded progression/expiration/replay/rendered checks; updates intentionally superseded static-clock and no-motion-reset assertions |
| Reports/Prototype_5_Completion_Report_2026-10-24_115626_01.md | This new completion report |

Earlier Prototype 5 working-tree changes remain as documented in earlier reports. No scenario JSON, attack JSON/schema, artwork, executable, project settings, prior report, or accepted checkpoint was altered by this refinement.

## Actual testing

Godot 4.7.2 stable Mono, Windows, Vulkan Forward+, NVIDIA GeForce RTX 2070. Commands from repository root:

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
& $godotExe --headless --editor --path . --quit
```

| Check | Actual final result |
| --- | --- |
| Prototype 3 | PASS, 0 failures, exit 0 |
| Prototype 4 | PASS, 13,032 checks, 0 failures, exit 0 |
| Prototype 5 | PASS, 962 checks, 0 failures, exit 0 |
| Headless editor import | Exit 0, no script/import errors; new UID generated |
| git diff --check | Pass after removing an extra trailing blank line; line-ending normalization notices only |

An initial development run had a controller type-inference parse error; it was corrected and its misleading partial harness PASS was discarded. Final runs were inspected for script errors as well as assertion totals. Negative-data tests intentionally emit missing/invalid-data/unknown-ID diagnostics.

Tests cover continuous rendered countdown advance; exact formula across both ring jumps; inner arrival before expiration; hover freezes only active travel/time; resume without catch-up; repeated selection without reset; background motion and deadline isolation; investigation without extension; H/N/N100 expiration and hidden-truth privacy; rejected late defense; explicit hold fire versus expiration; active-only reset/replay and repeatable same elapsed progression; seconds/minutes/hours/days formatting; all controls within fixed bounds and reports with at least 120 pixels of scroll area. Existing JSON validation, outcomes, selection, movement and hover suites remain in place. Superseded static-demo-deadline and no-motion-reset assertions were updated to the newly authorized behavior, without weakening movement assertions.

## Rendered visual verification

Actually performed at 1600 x 900 using rendered Godot viewport input and screenshot inspection. Inspected normal active countdown, expired state, and two-day formatting. Numerals are large/readable, expiry is stated in text, reports remain scrollable, staff/ETA remain visible, all four controls fit, and the console retains Rect2(1280,64,300,772). No overlap with DATA or the orbital click area was observed. Native manual desktop GUI interaction was not performed.

Screenshots remain outside the repository under `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/`: `prototype4_p5_H_initial.png`, `prototype4_p5_H_expired.png`, and `prototype4_p5_clock_days.png`. The days capture deliberately injects a public display duration into the clock for layout testing; it is not a two-day gameplay fixture. Capture naming is inherited from earlier test helpers.

## Limitations and review points

- The default window is intentionally short (~38.47 simulation seconds); it is configurable in the controller, but speeds were not changed. Hover can hold it indefinitely by design. There is no separate reading pause or strategic clock.
- Three revolutions are a prototype decision-window rule, not a physical impact or financial model. Motion continues at the inner ring after expiration/decision.
- Scenario observations are reused for explicit restraint and expired non-intervention; their decision labels/internal states remain distinct. Separate authored late text could be proposed later.
- Analysis ETA and staff/workload are still static examples, even when the live deadline is shorter than the example ETA. No automatic scheduling, investigation completion, resources or penalties exist.
- Long reports require scrolling; the fixed 1600 x 900 layout was verified, responsive layouts were not.
- Local fixture truth remains developer-inspectable; the public projection prevents UI leakage, not source inspection.

Next step: owner review of clock prominence, urgency wording, and default revolution budget. No further prototype or timing changes are assumed authorized.
