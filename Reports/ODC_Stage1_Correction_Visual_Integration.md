**HOW TO START THE GAME**

Double-click the existing permanent launcher:

`C:\Users\azwam\Projects\planetary-attacker-defender\Launch_Orbital_Defense_Command.bat`

[Launch Orbital Defense Command](C:/Users/azwam/Projects/planetary-attacker-defender/Launch_Orbital_Defense_Command.bat)

It now opens the live Tactical Group Command workspace directly. COMMAND ? Command Desk retains the previous entry/session screen. The launcher itself was not changed, renamed or replaced. It was actually launched from Windows TEMP: exit 0, responsive visible game window, normal close of only the test instance.

# Stage 1 correction ? visual and command integration

Delivered 2026-10-30 for owner visual/gameplay review. **The previous Stage 1 was not accepted. This corrective delivery is not accepted merely because its tests pass.** No Stage 2 or Git publication performed.

## What changed

The normal command workspace now visibly follows the approved composition:

- **Top:** persistent COMMAND, OPERATIONS, PERSONNEL, TRAINING and REPORTS menus, Martian War Room and PAUSE. Real mission status appears beneath: six existing centers, current round, arrival/airborne counts, simulation time, firing mode, learning results/accuracy and elapsed time. Reference illustration values were not copied.
- **Left:** native vector icons and labels for Overview, Assessment, Evidence and History.
- **Center:** existing orbital operations over a subdued space backdrop and procedural Earth, with six labeled subordinate assets or the selected center enlarged.
- **Right:** current center, encounter picker, full suspected attack name, authentic countdown, existing authored scenario, selected decision and recorded status. Lesson access remains separate. The context can be hidden. During incoming fire, the existing Martian warning/evasion panel takes this region; after resolution, the existing group receipt is labeled and scrollable. Controls are not left clickable beneath it.
- **Bottom:** Analyze, Review Report, Decide / Authorize, Inspect Incident, Legacy Tactical Tools and Group View. In legacy operational context this changes to the original Investigate, Monitor, Cyber Defense, Physical Defense and Commands controls, plus return to Group View.

All buttons call their established handlers. Original A/R/D controls and legacy quick controls are reparented, preserving their signals. The Report, partial submission, WAIT, cancellation, launch authorization, manual firing and review engines were not reimplemented.

The shared Tactical/Security incident inspector remains one instance and uses the same read-only projection and session registry. It was not replaced with a duplicate. Full educational lessons, original legacy drawers and detailed report screens remain available.

## Before / after navigation

| Rejected Stage 1 | Corrective workspace |
|---|---|
| COMMAND FUNCTIONS mixed with center dropdown and compact letter controls | Five labeled top-level command categories with clear destinations |
| Six centers looked like separate destinations | TACTICAL GROUP COMMAND heading, six subordinate identities, selectable asset headers and one COMMAND center-selection menu |
| Bottom operational controls hidden in learning context | Persistent contextual action bar; original operational controls return in legacy context |
| No coherent left/center/right workspace | Four-view left rail, orbital center, selected decision inspector and bottom actions visible together |
| Learning context separate from tactical presentation | Assessment identifies center/contact/full attack/scenario before linking to existing Report and decision handlers |
| Separate startup Desk was the landing page | Live command workspace opens directly; Desk remains reachable without destroying the mission |

### Menu destinations

- **COMMAND:** group overview, DC-01?DC-06, Command Desk and confirmed New Mission. This is the only visible global center-selection menu. Tile headers are shortcuts into the same selection route.
- **OPERATIONS:** Analyze, Report, Decide/WAIT, shared incidents, selected-center legacy tactical tools, existing Operations Commander contacts and Martian War Room.
- **PERSONNEL:** read-only names/ranks/duties from the existing First Watch JSON. Enterprise roster is explicitly unavailable. No invented enterprise staff or portraits.
- **TRAINING:** First Watch under the original Learning Mode / explicit PAUSE / no queued-flight-effect safety gate.
- **REPORTS:** current/historical group learning Report; original operational Evidence, Decision Timeline and official Mission Scorecard; selected-center arrivals; separately gated First Watch training report. Their scores and evidence sources remain distinct.

Original operational Evidence/History is explicitly restricted to supported legacy actors. Selecting DC-04?DC-06 never silently selects DC-01. The left Evidence/History views show that selected center's learning arrival/engagement facts, including when no current-round question exists. Full original reports remain under REPORTS.

## Six-center authority and gameplay preservation

The player is the Tactical Group Commander of the six-center learning mission. All six centers support analysis, questions, partial answers, permitted missile authorizations and outcomes through the existing session. DC-01?DC-03 additionally retain the original tactical actors and commands. DC-04?DC-06 do not gain fabricated legacy actors; controls explain their unavailable capabilities.

No other groups or centers were invented. No rank/profile/promotion system was added. First Watch remains a separate lieutenant training exercise with the same crew ranks, checklist, score, standings, Lumen intrigue and narrative. Personnel reads existing crew fields without starting or modifying the exercise.

The central orbital presentation uses an affine view transform only. Original actor positions, paths, projectile bounds and 36-second pursuit calculations remain in their existing coordinates. Mouse positions are mapped back before calling the original player-fire handler. Ordinary navigation retains the same mission, registry, current answers, score and clocks; view changes still defer while flights/effects are active. New Mission remains an explicit confirmation.

The host Control now ignores empty-space mouse input so actual orbital clicks reach the existing authorization handler. UI buttons and modals still consume their own input. Genuine dialogs are ordered in front for GUI picking, not just visual z-order; legacy drawers/confirmations and official reports use presentation layers above the workspace. No evaluator, authorization rule or session owner changed.

A correct answer is not equated with HIT. The real DNS cache poisoning test (canonical ID 33) produces EVADED_INTERCEPTION through the actual passage callback, and the same physical/mission identity appears in DC-01's shared inspector. Incorrect answers create their established unopposed-arrival records without launching. HIT never creates an internal arrival. No compromise is inferred from arrival alone.

## Verification

**57 validation/regression/import/startup jobs have final passing results**, plus the actual Windows launcher test. Complete commands, logs and summaries: [checks/results.json](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/checks/results.json).

| Verification | Final result |
|---|---|
| New graphical workspace, rendered native input | 92 checks, 0 failures |
| Same focused suite, headless | 92 checks, 0 failures |
| Six-center Stage 1 preservation | 94 checks, 0 failures |
| Live mission/navigation/DNS continuity | 51 checks, 0 failures |
| Shared Security Console | 32 checks, 0 failures |
| P14 wrap-up/checklist/training | 38 checks, 0 failures |
| P14 session and rendered gameplay | 30 and 70 checks, 0 failures |
| Live incident projection | 19 checks, 0 failures |
| P3?P12, all P10 stages, learning retrofit, partial submissions, mode transfer, arrivals | PASS |
| Catalog/editorial validation | PASS; 100 attacks / 185 defenses / 211 mappings; production approval remains blocked |
| Editor import, main/compatibility scene startups and whitespace check | PASS |
| Permanent batch launcher from TEMP | Exit 0, visible responsive window, normal close |

Focused tests open all five real menus, select all six centers, preserve mission/answers, exercise partial CLOSE/SUBMIT and genuine player-fire input, reject duplicate firing, retain 36-second impact timing and strategic pause, order warnings/results safely, verify DNS identity/outcome and cross-center isolation, reach original reports/scorecard, and return from safe training to the same live instance. Existing regressions cover automatic 15-second spacing, WAIT schedules, mode transitions, evasion, HIT, five-round history, scores and the canonical ledger.

The final focused test asserts that official mission scoring and the canonical operational event ledger remain unchanged. Canonical data, editorial approval state, all session/evaluator/missile scripts and First Watch sources match the pre-edit hashes.

Initial diagnostic runs exposed dialog input ordering, the host's empty-space input interception, and obsolete test navigation. Those issues were corrected within presentation/test scope. A test-adapter call used the host instead of the live wrapper; its failure log is retained. New test type annotations were corrected. No gameplay tests were weakened to conceal failures. Initial and final logs are preserved separately.

Testing used automated native Godot controls, rendered input and controlled simulation stepping. It was not an owner acceptance test or a claimed manual five-to-ten-minute playthrough. The launcher process was actually started separately. Screenshots were visually inspected at all three resolutions, not judged solely by successful clicks.

## Visual comparison with the approved reference

The owner authorized the uploaded image after the initial missing-path check. The exact local `Design References/Orbital Defense Command Interface(3).png` was subsequently confirmed, viewed and verified unchanged from the pre-edit backup. The upload and local PNG share the same visible composition; both originals are preserved externally. No older substitute was used as a game interface, and neither PNG is rendered as a flattened dashboard in the game.

[Open side-by-side reference and before/after comparison](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/comparison.html)

| Reference region | Observed implementation | Remaining difference |
|---|---|---|
| Persistent command/status bar | Five discoverable command menus plus actual live status and PAUSE | Uses real learning/mission metrics, not illustrative contact/confidence/defense totals |
| Left primary navigation | Four native drawn icons with readable labels and selected state | Fixed rail; not a full animated collapsible replica |
| Central Earth and orbiting assets | Subdued procedural Earth, existing contacts and six-center grid; enlarged single-center view | Stylized Earth and retained sprites, not photographic reference artwork; grid preserves center ownership |
| Collapsible right quick inspector | Center/encounter/scenario/outcome, lesson access, warning takeover and labeled result receipt | Long text scrolls; legacy/full report detail remains in existing windows |
| Bottom operational controls | Contextual, labeled operational actions visible with the orbital view | Uses discoverable labels rather than unexplained bottom icons |

The new composition is visibly closer in organization: all five regions coexist and functions are placed deliberately. This is not a claim of cinematic art or pixel equivalence. Final visual acceptance belongs to the owner.

### Screenshots

- [Before: rejected Stage 1, 1600?900](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/before_stage1_1600x900.png)
- [Initial graphical command workspace](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_default.png)
- [Enlarged-center assessment and existing scenario](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_assessment.png)
- [Report with preserved choices](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_report.png)
- [Actual incoming missile / Martian defense](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_incoming.png)
- [Same DNS incident in shared inspector](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_inspector.png)
- [Workspace at 1280?720](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_workspace_1280x720.png)
- [Workspace at 1600?900](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_workspace_1600x900.png)
- [Workspace at 1920?1080](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_workspace_1920x1080.png)
- [Full incident detail at 1280?720](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/evidence/prototype4_correction_detail_1280x720.png)

## Exact project files changed

Modified existing working files:

1. `script/tactical_group_ui.gd` ? five-region workspace, menus, contextual actions/inspection, hierarchy, styling, fit transform and modal input ordering.
2. `script/prototype13_command.gd` ? graphical orbital renderer selection, presentation-coordinate input adapter, selected-center context and personnel-modal gate.
3. `script/odc_entry.gd` ? direct command landing; empty-space input passthrough. Persistent host/session ownership retained.
4. `tests/command_navigation_continuity_test.gd` ? current menu/landing routes; original continuity assertions retained.
5. `tests/prototype13_security_console_test.gd` ? shared inspector entry remains the explicit inspection action rather than asset selection.
6. `tests/prototype14_wrapup_test.gd` ? explicit safe pause now that the command mission initializes at startup; same training verification retained.
7. `tests/six_center_interface_stage1_test.gd` ? new left/bottom routes and asset-to-context interaction expectations.

Added source/resources/tests:

- `script/command_nav_icon.gd` and `.gd.uid` ? native vector navigation icon drawing.
- `script/command_orbital_display.gd` and `.gd.uid` ? draw-only orbital surfaces; inherited geometry/state retained.
- `script/command_workspace_globe.gdshader` and `.gdshader.uid` ? procedural Earth adapted from the existing owned P14 shader.
- `tests/command_workspace_correction_test.gd` and `.gd.uid`.
- `Reports/ODC_Stage1_Correction_Visual_Integration.md`.

Godot also generated `Design References/Orbital Defense Command Interface(3).png.import` during import. This is resource-import metadata, not an edit of the PNG and not an in-game dashboard asset. It is left untracked with the existing work.

No scene, project configuration, catalog, database, missile/evaluator source, original shader, original image, launcher or character artwork was edited. The pre-existing `project.godot` modification remains preserved.

## Backup and preservation

ZIP: `C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/ODC_Pre_Correction.zip`

- 398 files, 8,028,853 bytes.
- SHA-256: `16f31c0bb6e02ccd386cb4fc96839a1175f4f0485df42db9992fd63b624d147d`.
- Archive CRC, membership and every archived/source SHA-256 compared before editing. ZIP checksum/CRC reverified after implementation.
- Seven intended baseline files changed; the other 391 archived files remain byte-identical. No baseline file is missing.
- Exact local reference PNG SHA-256: `48e6296cb2e52689b024ca3138caa039134f4aa92b9ead0136575696703069c2`.
- Source manifests, Git snapshots, reference verification, launcher evidence and logs are under `C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938`.
- Git metadata, reproducible `.godot`/Python caches, logs and unrelated generated executable `new_projectV2/new_project_v2.exe` were excluded from the ZIP and not deleted. Earlier backups remain intact.

## Remaining limitations

- Original contact captions are small in the six-center overview, particularly at 1280?720. Enlarge a center or use the right/shared inspector for readable identity/detail. Inherited persistent arrival banners still cover part of their tiles; their content, identity and behavior were preserved.
- The encounter selector clips long captions to fit; the full attack name is shown immediately below and in the lesson/incident detail. No catalog name is abbreviated or modified.
- SIEM, containment, threat resolution, enterprise roster, new command groups and promotions remain unavailable. No new simulation metrics or incidents were invented.
- First Watch remains separate training; it does not replace the current DNS arrival with its credential scenario. Training is blocked until the live mission is at the existing safe, explicitly paused Learning Mode boundary.
- No portraits or empty portrait placeholders were added. Existing approved rank/name/duty fields remain unchanged. StarSink was not integrated.
- The layout is a native working interpretation of the reference, not its finished artwork or complete animated drawer redesign. Existing reports can cover the orbital workspace while open; the main workspace retains the required regions together.

## Owner manual review

1. Start using the permanent launcher at the top of this report. The graphical group workspace should open directly.
2. Open COMMAND and review the six subordinate centers. Select DC-01 through DC-06 and return to Tactical Group Overview. Confirm the same mission continues.
3. Use bottom ANALYZE ? YES. Select one or more defenses; CLOSE without submission and reopen REVIEW REPORT to verify selections persist. SUBMIT ANSWERS uses the existing immediate/partial workflow. D retains WAIT and authorization behavior.
4. Choose a center and Assessment to read its attack/scenario before deciding. Use Lesson for detailed content. Review the actual arrival, grade and physical outcome separately.
5. Test AUTO-FIRE and PLAYER FIRE as before. In PLAYER FIRE, use the existing target authorization/picker, aim and click orbital space. UI clicks must not fire; one authorization must launch once.
6. After an arrival, use INSPECT INCIDENT for the shared inspector. Compare the same physical identity and center. A HIT must not appear as an arrival.
7. Open OPERATIONS/REPORTS for original tactical/evidence/history/official scorecard functions. DC-04?DC-06 must clearly report unsupported legacy capabilities instead of showing DC-01.
8. Try TRAINING while unsafe and read the plain blocker. When safe, select Learning Mode and explicitly PAUSE; enter First Watch and return. Verify its independent crew/checklist/story and retained live mission.
9. Inspect all three desktop resolutions and use the comparison page to judge the intended visual direction. Provide visual/gameplay acceptance or refinements before any further stage.

Reproducible focused rendered test:

```powershell
& 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe' --path 'C:/Users/azwam/Projects/planetary-attacker-defender' --script res://tests/command_workspace_correction_test.gd -- --odc-learning-seed=2949072717
```

## Final Git status

Branch remains `feature/prototype13-datacenter-defense`; HEAD remains `c6646b008657f98b500e019a71b6521f58a76509`. All Git refs match the pre-edit snapshot. Nothing staged. No commits, tags, pushes, merges, resets, stashes or cleanup. Accepted checkpoints, main and collaborator branches remain untouched. Existing uncommitted work is preserved.

[Final working-tree status](C:/Users/azwam/Projects/Backups/ODC_Stage1_Correction_2026-10-30_133938/final_git_status.txt)

**Stop here for owner visual/gameplay acceptance.**
