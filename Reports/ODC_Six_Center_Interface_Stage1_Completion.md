# ODC Six-Center Interface ? Stage 1 Completion

Completed 2026-10-30. Ready for owner gameplay review. No Stage 2 work or Git publication performed.

## Consolidated interface

The player is visibly the **Tactical Group Commander** of the existing six-center learning mission. One selector offers Tactical Group Overview (all six) and DC-01 through DC-06. The overview is available before analysis, with actual center/arrival counts and an explicit prompt to analyze. After analysis, each selectable tile header shows unresolved arrivals and pending current-round learning encounters. Existing status bands retain actual queue, launch and physical outcomes. No readiness percentages or fabricated incidents were added.

Choose a center for its orbital view. Click its tile header, INSPECT CENTER INCIDENTS, or T for the shared center-aware inspector. O and the group entry return to all six. A/R/D remain available from the toolbar and inspector. A analyzes; R reopens the existing Report; D retains authorization/WAIT. Existing partial submission, review, scoring, evidence, confirmation and History functionality remains intact.

Tactical Command and Security Console now reference **one inspector instance**, subclassing the existing Security Console presentation. Both entry methods use the existing read-only incident projection. There is no second registry. Multiple arrivals remain selectable by physical identity. The inspector shows full educational attack name, canonical ID/source name, physical and learning identities, center, mission, answer grade, recorded missile outcome, arrival cause/time, internal state, evidence limits and compromise status. The outcome and uncertainty appear first; the long educational definition is collapsed behind one expansion control. Additional learning details remain in their existing lesson panel.

The inspector records arrivals only. HIT is not fabricated as an arrival: its learning result is available through Report and the live status band. Correct answer and EVADED remain distinct facts; arrival does not prove compromise. SIEM, containment and resolution remain unavailable.

## Navigation before / after

| Before | Stage 1 |
|---|---|
| Mixed command dropdown containing centers, observer status, Fleet, Training and Desk | One seven-entry center selector; separate COMMAND FUNCTIONS menu |
| Canonical DC-01?03 selector plus learning DC-01?06 selector and 6 CENTERS button | Original adapters retained but hidden; group option provides the overview |
| Separate Tactical Command summary followed by duplicate Security Console | T, tile headers, inspect shortcut and Security Console entry method open the same inspector |
| Full repeated attack descriptions | Concise arrival facts; one expandable definition in the inspector |
| Legacy operational quick bar shown under the learning environment with a potentially unrelated contact | Hidden in learning context; original actions remain available through Legacy Tactical Tools |
| DC-02?06 labeled observer-only | All six are under learning-mission command; legacy capability is explicitly distinguished |

The separate manual RESET TO 1 DATA CENTER behavior remains. Navigation changes are deferred while flights/effects are active, with a visible explanation; target geometry and flight timing are preserved. A later manual reset supersedes an earlier deferred layout request. Navigation does not restart, analyze, submit, grade, pause, or create a mission. Current selections, pending authorizations, clocks and historical results remain owned by the original session.

COMMAND FUNCTIONS retains Group operations / legacy Contacts (existing Operations Commander), separately gated First Watch TRAINING, and Command Desk. Legacy role indices/registries remain intact. Ordinary center navigation closes presentation drawers without clearing their data. New Mission remains the existing explicit confirmed action.

## Authority and capability boundary

DC-01?DC-06 support the current learning mission, questions, authorized missiles, outcomes and arrival inspection. DC-01?DC-03 also have original legacy tactical actors. Legacy Tactical Tools selects the exact supported center and uses existing intelligence, confirmation and command rules. DC-04?DC-06 show a disabled legacy-tools control and an explicit NOT IMPLEMENTED capability message, while A/R/D remain available. Unsupported calls do not select DC-01 as a fallback.

This is a group duty assignment, not a new rank/profile/promotion system. No competing groups or additional centers were simulated. First Watch remains a separate DC-01 lieutenant training exercise with its existing ranks, crew, checklist, standings and Lumen narrative. Training safety/pause rules and New Mission lifecycle are unchanged.

## Exact files changed

Modified existing working files:

- `script/command_navigation.gd` ? seven-entry center selector.
- `script/prototype13_command.gd` ? shared inspector, center/group routes, legacy capability guards, presentation-only view deferral/reset integration.
- `tests/command_navigation_continuity_test.gd` ? replaces obsolete ten-entry/observer/duplicate-screen expectations with current routes and canvas-aware bounds; preserves DNS callback, mission, training and ledger assertions.
- `tests/prototype13_security_console_test.gd` ? uses the shared tile entry, explicit definition expansion and canvas-aware bounds; preserves all 32 registry/state assertions.

Added:

- `script/group_incident_inspector.gd`
- `script/group_incident_inspector.gd.uid`
- `script/tactical_group_ui.gd`
- `script/tactical_group_ui.gd.uid`
- `tests/six_center_interface_stage1_test.gd`
- `tests/six_center_interface_stage1_test.gd.uid`
- `Reports/ODC_Six_Center_Interface_Stage1_Completion.md`

No scenes or project configuration changed during this stage. The existing `project.godot` modification predates this work and remains preserved. Original security/tactical presentation scripts remain available for compatibility, without duplicate live instances. Evaluators, missile mechanics, catalog/editorial records, question fixtures, launchers, P14 source and artwork remain byte-identical to the pre-edit backup.

## Verification

All **58 final validation/regression/import/startup jobs pass**, plus the actual Windows launcher check. Full commands, summaries, timings and logs: [results.json](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/checks/results.json).

| Focused verification | Result |
|---|---|
| Stage 1 rendered, including native scaled clicks at all three sizes | 94 checks, 0 failures |
| Stage 1 headless | 94 checks, 0 failures |
| Current command/navigation continuity | 51 checks, 0 failures |
| Shared Security Console/registry behavior | 32 checks, 0 failures |
| Live incident projection | 19 checks, 0 failures |
| P14 session / UI / wrap-up | 30 / 70 / 38 checks, 0 failures |
| Canonical catalog and rich editorial validation | PASS; 100 attacks / 185 defenses / 211 mappings; approval status unchanged |
| P3?P12 suites, retrofit core/UI/partial submission, mode transfer, arrivals | PASS |
| Godot import; main and compatibility-scene startups; Git diff check | PASS |
| Existing Windows batch launcher from TEMP | Exit 0; responsive visible game; normal close |

The focused suite reproduces actual canonical attack 33, DNS cache poisoning, using seed `2949072717`: normal partial submission creates a 36-second missile; the real evasion/passage callback records EVADED_INTERCEPTION; DC-01's shared inspector shows the same physical identity and uncertainty. It tests all six centers, unsupported legacy guards, zero cross-center contamination, answers across navigation, deferred geometry changes, partial resubmission, a later HIT producing no arrival, and physical/scoring preservation. Existing suites cover 15-second staggering, mode switching, confirmation, five rounds, missed-question review, persistent targets, training, mission restart and official ledger isolation.

Testing used automated rendered input and controlled simulation stepping, not a claimed manual real-time playthrough. Screenshots were inspected at 1280?720, 1600?900 and 1920?1080. The live presentation scales its existing 1600?900 composition uniformly; it does not rewrite the established orbital paths.

Implementation/test iterations are retained in the evidence directory. An initial new-script syntax error and a retained legacy drawer were corrected. The first Prototype 3 run used 0,500 and failed four motion assertions; the unchanged suite passed at its previously verified 1900,900 position. Initial synthetic scaled clicks omitted awaiting the asynchronous click helper; the corrected input test passes without relaxing its assertions. Final hover styles were made opaque and the stale legacy contact strip was hidden in learning mode. Deliberate invalid-data diagnostics in older negative-test fixtures remain expected. No old gameplay tests/evaluators were weakened.

Git diff check passes; Git reports its pre-existing CRLF-to-LF advisory for `project.godot`. That file's bytes were not changed by this stage.

## Rendered evidence

Before references are preserved screenshots from the prior continuity delivery, not newly recreated baseline sessions:

- [Earlier Tactical screen](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/before_prototype4_continuity_dns_tactical.png)
- [Earlier duplicate Security screen](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/before_prototype4_continuity_dns_security.png)

Stage 1:

- [Six-center overview, 1280?720](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/prototype4_stage1_group_1280x720.png)
- [Six-center overview, 1600?900](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/prototype4_stage1_group_1600x900.png)
- [Six-center overview, 1920?1080](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/prototype4_stage1_group_1920x1080.png)
- [Shared DNS inspector, 1600?900](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/prototype4_stage1_inspector_1600x900.png)
- [Inspector, 1280?720](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/prototype4_stage1_inspector_1280x720.png)
- [Inspector, 1920?1080](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/prototype4_stage1_inspector_1920x1080.png)
- [Overview after partial submissions](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/evidence/prototype4_stage1_group_after_partial.png)

## Backup and preservation

Verified pre-edit ZIP: `C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/ODC_Pre_Stage1.zip`

- 390 archived files; 6,041,209 bytes.
- SHA-256: `a000f940dca05add96a71e45a59e8f09d928b5d917d10b8e736aeb0425001220`.
- CRC, exact archive membership and every archived/source SHA-256 compared before editing. ZIP checksum/CRC rechecked after implementation.
- Source manifests and baseline Git references/status: `C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738`.
- Four intended baseline files modified; other 386 baseline files unchanged; none removed. New source/test/UID/report files are additive.
- Git metadata, `.godot`, Python caches, temporary logs and unrelated generated executable `new_projectV2/new_project_v2.exe` excluded from ZIP and left untouched locally. Earlier backups remain intact.

## Portrait preparation and limitations

No portrait placeholder or artwork was added. `script/p14/command_experience.gd::render_crew` and its existing 456-wide detail panel can accommodate an optional 96?128 portrait in the crew-detail header, beside full rank/name with duty separate, followed by normal-width dialogue. Proposed future filenames: `images/personnel/meridian/mara_voss.png`, `imani_rao.png`, `eli_chen.png`; source artwork can be 192?256 or larger at the same ratio. Missing art should collapse the slot entirely. Chief Petty Officer Mara Voss, Lieutenant Junior Grade Imani Rao and Ensign Eli Chen remain unchanged. This is an assessment only; implementation awaits approved original Meridian uniforms/portraits.

The exact `Orbital Defense Command Interface(2).png` was not available in the prior local inspection; no older image was silently substituted for a redesign. StarSink was not integrated or edited. No general visual redesign, personnel simulation, new incidents, campaign, resolution or disk persistence was introduced.

Original contact labels remain dense in small six-center tiles, and inherited arrival banners can obscure part of their orbital content. These accepted presentation elements were not redesigned in Stage 1; larger single-center views and the inspector remain available. Normal live time continues during inspection according to existing pause rules; there is no new pause rule. Legacy operational evidence/history, learning outcomes and training events intentionally remain distinct authorities.

## Owner review instructions

1. Double-click [Launch_Orbital_Defense_Command.bat](C:/Users/azwam/Projects/planetary-attacker-defender/Launch_Orbital_Defense_Command.bat), then Open / Resume Orbital Command.
2. Review all six tiles. Choose DC-01 through DC-06 using the sole center selector; choose Tactical Group Overview to return. During active flight, expect a deferred-view explanation rather than a moved projectile path.
3. Use A ? YES, select one or more answers in R and submit. Reopen R to continue the same round; D retains WAIT and manual authorization behavior.
4. Click a tile header, INSPECT or T. Inspect recorded outcomes; expand the definition if wanted. Return to the same live orbital view.
5. Compare DC-01?DC-03's Legacy Tactical Tools with the explicit unavailable state at DC-04?DC-06. Use COMMAND FUNCTIONS for existing Operations Commander contacts, Command Desk or safe/gated First Watch training.
6. Check DNS/other arrivals stay at their original centers, and HIT does not create an arrival. Only use NEW MISSION or RESTART LEARNING SESSION when deliberately resetting the corresponding state.

Reproduce the new rendered suite with Godot 4.7.2 Mono:

```powershell
& 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe' --path 'C:/Users/azwam/Projects/planetary-attacker-defender' --script res://tests/six_center_interface_stage1_test.gd -- --odc-learning-seed=2949072717
```

## Final Git state

Branch: `feature/prototype13-datacenter-defense`. HEAD: `c6646b008657f98b500e019a71b6521f58a76509`. All references match the pre-edit snapshot; main, accepted checkpoints and collaborator branches were not modified. Nothing staged or published. Existing uncommitted P13/P14/continuity work, report copy, executable and caches remain. Full final status: [final_git_status.txt](C:/Users/azwam/Projects/Backups/ODC_Six_Center_Stage1_2026-10-30_114738/final_git_status.txt).

Stage 1 stops here for owner gameplay approval.
