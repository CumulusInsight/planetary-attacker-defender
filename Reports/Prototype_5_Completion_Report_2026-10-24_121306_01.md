# Prototype 5 Completion Report - Five-Minute Window and Learning Mode

Created: 2026-10-24T12:13:06-07:00 - America/Los_Angeles, Pacific Daylight Time, UTC-07:00.

Status: implemented and tested; uncommitted on `feature/prototype5-intelligence-defense`, ready for owner review. No Prototype 6, commit, merge, tag, push, or executable rebuild.

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_5_Completion_Report_2026-10-24_121306_01.md`

## Current behavior verified

Reviewed the latest preceding report (`Prototype_5_Completion_Report_2026-10-24_115626_01.md`) and actual controller, deadline, movement, console, and test code. C-001 (first configured attack ID, currently 1) alone owns the active encounter and decision deadline. C-002 and C-003 are intentionally selectable moving background contacts, without fabricated deadlines or hidden encounter outcomes. This is Prototype 5's one-active-contact scope, not a timer defect. Neither background contact was promoted into another encounter.

The previous three-revolution budget at 0.49 radians/second yielded only about 38.47 seconds. This refinement replaces that configuration with a five-minute active-simulation window. Earlier reports are retained unchanged as history.

## Timing model

Controller inspector setting `decision_window_seconds` defaults to 300.0 seconds and accepts positive configurable durations. At initialization, capture active contact angle, ring, within-orbit progress, total cumulative orbital travel S0, and angular speed w. Set the progression budget B = abs(w) * configured_seconds. With unchanged w = 0.49, B = 147 radians, approximately 23.396 revolutions.

Remaining time = max(0, B - (S-S0)) / abs(w), where S is the existing cumulative actual orbital travel. This is the same authoritative movement-derived model as before; there is no independent timer integrating elapsed wall time. Changing the configured duration changes the travel budget, not movement speed. The setting applies on scene initialization; replay restores that captured budget/state rather than reconfiguring it.

Each full revolution still produces the accepted discrete inward jump, with radii 400/280/160 and speeds 0.49/0.63/0.77 unchanged. After reaching the innermost ring, the active contact continues orbiting there for the remaining budget. Ring transitions do not reset or extend the clock. Inner-ring arrival does not mean collision, financial loss, or expiration.

Selection/reselection does not recapture time. Investigation neither extends the budget nor automatically completes from the demonstration ETA. Explicit defense/hold fire close the window and retain the time-at-decision display; movement continues. Expiration remains the distinct `expired` decision, using the deterministic no-intervention branch (hostile interference, neutral legitimate passage), without disclosing hidden identity. Late timely actions remain disabled. Replay clears the decision/follow-up, reading pause, and restores only the active contact's captured movement/progression/full budget; backgrounds are untouched.

## Learning Mode and how to use it

The console defaults to **Learning Mode**. Select C-001, then enable **Read reports (pause)** before reading intelligence/SIGINT. This explicit designated reading state holds the active contact and its deadline together, shows `READING: contact paused`, and leaves both background objects moving. Disable the toggle to resume exactly where it stopped, with no catch-up.

Selecting a contact alone does not pause it. Learning Mode enables the explicit reading toggle; it does not silently pause all simulation. Switching to **Active Challenge Mode** clears/disables the reading pause; normal progression and countdown resume. Accepted hover-freeze remains available in either mode. Movement returns early if either hover or reading pause is active, so exiting reading while still hovered does not bypass hover-freeze.

Selecting a background contact exits the reading state and shows no active deadline or inherited analysis ETA. Returning to C-001 shows its current remaining time, not a restart. Resolving or replaying also clears reading state. Mode choice persists within the current scene/replay, not across application launches. There is no SceneTree/global pause and no external learning-service integration.

## Console

The large countdown stays at the top. Player-facing contact ID and unidentified status remain visible; private affiliation is never used as its identity. Added progress text shows ring number/name (1 inner, 2 middle, 3 outer), percentage through the current orbit, and percentage of the decision travel budget used. The counter continues displaying days/HH:MM:SS as appropriate.

Staff/workload and estimated analysis time remain clearly labeled static demonstration values. The analysis ETA does not drive scheduling or investigation completion. Reports scroll beneath the fixed status area; investigation, defense, hold fire, and replay remain accessible. Mode selector and reading toggle add two separate UI controls.

## Files modified in this refinement

| File | Change |
| --- | --- |
| script/orbital_deadline.gd | Converts configured seconds into authoritative travel budget at capture |
| script/enemy.gd | Adds explicit per-contact learning pause alongside hover early return |
| script/game.gd | 300-second default, mode/reading coordination, pause cleanup, public ring/orbit/budget progress |
| script/attack_info_panel.gd | Mode/reading signals, public progress and reading-state presentation |
| scene/attack_info_panel.tscn | Mode selector, reading toggle and progress label; constrained selector sizing and compact spacing |
| tests/prototype4_test.gd | Updates control-count assertion from four to six; retains existing movement/selection/layout assertions |
| tests/prototype5_test.gd | Five-minute/custom budget, rendered reading toggle, exact pause/resume, challenge and progress regressions |
| Reports/Prototype_5_Completion_Report_2026-10-24_121306_01.md | This new report |

All earlier uncommitted Prototype 5 changes remain. No attack/scenario JSON, project settings, artwork, earlier report, executable, or existing checkpoint was modified by this refinement.

## Test commands and actual final results

Godot 4.7.2 stable Mono on Windows; Vulkan Forward+ / NVIDIA GeForce RTX 2070. From project root:

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
& $godotExe --headless --editor --path . --quit
```

| Verification | Actual result |
| --- | --- |
| Prototype 3 | PASS, 0 failures, exit 0 |
| Prototype 4 final | PASS, 13,040 checks, 0 failures, exit 0 |
| Prototype 5 final | PASS, 992 checks, 0 failures, exit 0 |
| Editor import | Exit 0, no script/import errors |
| git diff --check | Pass; normalization notices only |

Coverage includes configurable default 300 seconds and alternate 600-second budget; movement/time equivalence across ring transitions; continuous innermost motion before expiry; actual rendered reading-toggle pause while backgrounds move; exact resume without catch-up; Active Challenge progression; accepted hover-freeze; selection without extension; background isolation; deterministic expiration and replay for H/N/N100; explicit hold fire versus expiry; all existing actions and hidden-truth privacy; seconds/minutes/hours/days formatting; accessible reports/buttons.

Tests advance controlled movement deltas to exercise five-minute expiration without waiting five wall-clock minutes. Separate rendered waits verify the countdown advances in normal simulation. Missing/invalid-data diagnostics are expected negative-path checks. Intermediate runs caught a mode-selector minimum-width regression; its sizing was corrected and final suites rerun without relaxing console-bound assertions.

## Rendered visual verification

Actually performed: rendered 1600 x 900 viewport input, screenshot generation, and inspection of both Learning Mode paused and Active Challenge views. The console remains Rect2(1280,64,300,772), with no DATA/orbital overlap; the reading state is visible, challenge text is readable, the large countdown remains prominent, and reports/actions fit. Days-format bounds also pass. Native manual desktop GUI testing was not performed.

Screenshots outside the repository: `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/prototype4_p5_learning.png` and `prototype4_p5_active_challenge.png` (inherited capture prefix). Screenshots show controlled test progression already at the inner ring, demonstrating substantial remaining decision time after inward jumps.

## Limitations and owner review

- Reading pause is explicit: choose Learning Mode and turn on Read reports (pause). Merely choosing Learning Mode or selecting C-001 leaves simulation running until that toggle is enabled.
- The budget is five minutes of active contact movement, not wall time. Hover or reading may hold it indefinitely by design; other contacts keep moving.
- Only one active encounter exists. No staffing scheduler, external learning assistant, simultaneous threats, scoring, finances, or diplomacy was added.
- Analysis ETA/staff counts remain static examples. Local fixtures remain developer-readable; public projection protects UI disclosure, not source inspection.
- Long reports require scrolling. Fixed 1600 x 900 was verified; responsive layouts remain outside this refinement.

Recommended next step: owner review of the reading-toggle workflow and five-minute pacing before checkpointing or further development.
