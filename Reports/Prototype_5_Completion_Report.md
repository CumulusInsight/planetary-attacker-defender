# Prototype 5 Completion Report

Implemented 24 October 2026. Status: ready for owner review; not committed or published.

## Baseline and scope

Work is on `feature/prototype5-intelligence-defense`, created from accepted Prototype 4 commit `16dc097421e4f2b1159ab3f5095db408e115b11e`. The existing concept, Prototype 4 completion report, and programmer handoff informed this implementation.

Three moving contacts, three rings, central DATA/$1,000,000, artwork, interaction areas, selection highlight, and orbital speeds (0.49/0.63/0.77 radians per second) remain. Hover freezes only the hovered contact; leaving resumes its preserved movement state. Full-orbit inward jumps and innermost motion remain. No global pause, countdown, scoring, financial calculations, diplomacy, resources, random outcomes, network service, or additional encounter/data center was added.

## Playable encounter

- Click C-001 to access the active encounter. C-002 and C-003 remain selectable background contacts with disabled encounter commands.
- The fixed command console presents intelligence, SIGINT, and hypothetical capability estimates. Expressed confidence is explicitly distinguished from verified fact. Floating hover descriptions are disabled without removing hover-freeze.
- **Investigate further** reveals one authored follow-up, then becomes unavailable. It does not resolve the encounter; defense or hold fire remains available.
- **Deploy defense** and **Hold fire** deliberately resolve authored branches. The console separates the report, player decision, subsequent observations, and remaining uncertainty.
- **Replay encounter** clears encounter decisions/follow-up without restarting the application or resetting orbital motion. Returning from a background selection restores the active encounter's current state.
- All fixtures use the same contact artwork. Normal UI never names the fixture, reveals private identity/intent/objective, or prints the hidden capability profile/result code. Existing attack abbreviations are not presented as confirmed identities.

## Architecture and scenario data

`data/attacks.json` and its validation remain unchanged. The controller still supplies all existing attacker properties externally. Stable public contact identifiers derive from the attack IDs, rather than revealing attack abbreviations.

`data/encounters.json` contains local, deterministic H, N, and N100 fixtures. Each separates private truth, officer/SIGINT reports, a single follow-up, and deploy/hold outcomes:

| Fixture (developer only) | Hidden scenario | Deterministic branches |
| --- | --- | --- |
| H | Martian hostile with three possible capabilities and one predetermined attempted attack | Defense blocks interference; hold fire permits interference |
| N | Peaceful neutral scientific probe, no hostile objective | Defense causes unintended probe interference; hold fire permits legitimate passage |
| N100 | Same peaceful truth and outcomes as N; officer expresses 100% hostile confidence | Same outcomes as N, regardless of officer certainty |

`EncounterDataLoader` validates the complete fixture set atomically, including structure, confidence range/type, private capability constraints, required report text, outcome compatibility, and preservation of N's truth/outcomes in N100. Missing/invalid files or unknown fixture keys produce clear diagnostics and disable encounter commands; there is no substitute scenario. Existing attack-data failure handling remains intact.

`EncounterSession` owns investigation/decision/reset state and deterministic resolution independently of Godot nodes. Its explicit public projection supplies only player-appropriate information. `game.gd` coordinates selection, loading, commands, and replay. The console renders this projection; moving attackers neither read scenario files nor decide outcomes. Debug truth inspection is restricted to debug builds and is not wired into the player console.

Attack identification confidence and defense effectiveness are separate concepts: an officer's confidence does not alter truth or establish guaranteed effectiveness. This prototype uses fixed authored outcomes, not a probability engine or a one-in-three success calculation.

## Files created and modified

| File | Change |
| --- | --- |
| `data/encounters.json` | Three authored fixtures with private truth and public reports/outcomes |
| `script/encounter_data_loader.gd` and `.uid` | Atomic scenario loading and validation |
| `script/encounter_session.gd` and `.uid` | Independent deterministic decision state and public projection |
| `script/game.gd` | Scenario integration, stable contacts, developer fixture selection, command/replay routing |
| `script/enemy.gd` | Contact labels and suppression of floating descriptions; orbital/freeze code retained |
| `script/attack_info_panel.gd` | Stationary command-console presentation and action signals |
| `scene/attack_info_panel.tscn` | Scrollable reports and four command/replay controls inside existing panel bounds |
| `tests/prototype3_test.gd` | Updated superseded presentation expectations; retained data/movement assertions |
| `tests/prototype4_test.gd` | Updated console expectations; retained selection/freeze/geometry regressions and added no-timeout assertion |
| `tests/prototype5_test.gd` and `.uid` | Scenario, privacy, validation, decision, replay, rendered input/layout regressions |
| `Reports/Prototype_5_Completion_Report.md` | This report |

The pre-existing untracked concept document was preserved. Gameplay scenes, attack JSON/schema/loader, artwork, project settings, executable, accepted commits, and existing tags were not modified.

## Launch and fixture selection

Open `project.godot` in Godot 4.7.2 stable Mono and run the main scene. Default fixture is H. Select C-001; its identity initially remains unknown to the player.

For developer/test launches from PowerShell at the project root:

```powershell
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
& $godotExe --path . -- --fixture=H
& $godotExe --path . -- --fixture=N
& $godotExe --path . -- --fixture=N100
```

Run one launch at a time. The command-line override is accepted only in debug builds. The controller's inspector `developer_fixture` also permits fixture setup before running. There is no player-facing fixture selector. Use Replay encounter after a follow-up or resolved decision; switching fixtures requires a developer launch/setup change.

## Test commands and actual results

Godot 4.7.2 stable Mono, Windows, Vulkan Forward+, NVIDIA GeForce RTX 2070, 1600 × 900 rendered viewport:

```powershell
& $godotExe --path . --script res://tests/prototype3_test.gd
& $godotExe --path . --script res://tests/prototype4_test.gd
& $godotExe --path . --script res://tests/prototype5_test.gd
```

| Verification | Actual result |
| --- | --- |
| Prototype 3 regression | PASS, 0 failures, exit 0 |
| Prototype 4 final regression | PASS, 13,048 checks, 0 failures, exit 0 |
| Prototype 5 final regression | PASS, 803 checks, 0 failures, exit 0 |
| Developer launch H / N / N100 | All three selected the intended fixture, pass/exit 0 |
| Headless startup and editor import | Completed without script/import errors |

Negative-path suites intentionally emit diagnostics for invalid/missing data and unknown IDs/fixtures; these are expected assertions, not failed tests. Prototype 5 covers both identities and the incorrect-100%-confidence variant; every action, investigation limit, deterministic repeat/replay, hidden/public separation, defensive data copies, invalid-state clearing, background contacts, missing/invalid scenarios, disabled popups, hover-only freezing, continued independent motion, and visible outcome scrolling. Prototype 4 confirms completing orbits does not implicitly resolve the encounter or count as hold fire. Existing movement and selection assertions were retained.

### Visual verification

Rendered automated Godot viewport mouse input exercised selection and console buttons. Screenshots were inspected for H initial/follow-up/defense, N hold-fire, and N100 initial views. The console stays within its original right-side 300 × 772 bounds, does not overlap DATA or block orbital contact clicks, and keeps identity/actions fixed while reports scroll. Text uses the existing font; long reports require scrolling. A button minimum-width issue and post-action scroll settling issue were found and corrected before the final passing runs.

Generated screenshots remain outside the repository under `%APPDATA%/Godot/app_userdata/planetary-attacker-defender/`, for example `prototype4_p5_H_initial.png`, `prototype4_p5_H_followup.png`, `prototype4_p5_H_deploy.png`, `prototype4_p5_N_hold_fire.png`, and `prototype4_p5_N100_initial.png`. The `prototype4_` prefix comes from reused rendered-test capture helpers. No native desktop GUI/manual interaction test is claimed; owner visual review is still required.

## Limitations and next increment

- Local JSON and debug inspection are accessible to developers. The public projection prevents accidental console disclosure; it is not encryption or an anti-cheat boundary.
- One encounter is attached to the first configured contact. Outcomes are narrative observations; they do not alter orbital movement, remove objects, or implement a damage system.
- Reports load once per scene. Replay clears decisions, not the loaded fixture or orbital state. Invalid data requires correction and relaunch.
- The accepted 1600 × 900 layout is verified; adaptive layouts and accessibility options remain future review topics.
- No scope deviations requiring additional gameplay were introduced. Previous raw identity/hover presentation assertions were deliberately updated to the requested uncertain-contact console; movement/data validation assertions were preserved.

Recommended next increment, subject to owner approval: review the report language and decision/outcome clarity through playtesting, then specify one small extension to evidence presentation. Timing, scoring, diplomacy, defense catalog, additional data centers, and future prototype scope remain unapproved decisions.

## Checkpoint status

Implementation is uncommitted on the feature branch for owner review. No commit, merge, tag, push, history rewrite, or executable rebuild was performed. Accepted Prototype 4 and earlier checkpoint tags remain unchanged.
