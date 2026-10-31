# Prototype 14 - Phase A proposal: The First Watch

STATUS: DESIGN PROPOSAL ONLY. Owner approval is required before Phase B. No Prototype 14 scene, script, asset, gameplay, startup change, branch change or publication has been implemented.

## Inspection and preservation

- Current branch: feature/prototype13-datacenter-defense.
- HEAD: c6646b008657f98b500e019a71b6521f58a76509, matching planetary-prototype12-complete-v1.
- Main scene remains res://scene/prototype13_command.tscn. Godot configuration targets 1600 x 900 and Forward Plus; project uses Godot 4.7.2 Mono.
- Working tree matches the prior Prototype 13 report: project.godot points at the additive P13 scene; its console scripts, station schematic, space.jpg, UID/import sidecars, focused test and completion report remain untracked. The unrelated new_projectV2 executable and Python caches remain on disk.
- Comparing the prior baseline manifest confirms project.godot is the only changed pre-existing accepted file. P13 source and report were included in the new backup. No material unexpected source changes were found.
- No AGENTS.md was found in the project tree.
- Current code: P13 extends retrofit_learning_game.gd, which retains the P12 learning flow and existing direct command scene. The read-only console queries player_fire_session.internal_for_center("DC-01"). Accepted internal arrivals distinguish EVADED_INTERCEPTION and UNOPPOSED_ARRIVAL; neither confirms compromise. P14 must not write into that registry or reuse its grading/launch methods for the new incident.

## Proposed experience

Working title: THE FIRST WATCH. The human is the new lieutenant of Orbital Data Center 01 in a company with fifteen orbital installations. The mission is to commission one security improvement and protect a maintenance window without unnecessarily interrupting customer service.

Target duration: approximately seven minutes on a first play, tuned through complete playthroughs to stay near five to ten minutes. This is a target, not a measured duration yet. Events advance through actions and short background jobs; no seven-minute compulsory timer or repeated quiz interruptions.

| Approximate time | Player activity | Visible consequence |
| --- | --- | --- |
| 0:00-1:00 | Arrive above Earth; inspect power, identity gateway and communications modules by clicking the station. Check a compact maintenance objective. | Animated work lights, small service craft, moving Earth limb and readable module status. |
| 1:00-2:00 | Speak with operations specialist Mara Voss and security officer Imani Rao. Mara wants a quiet maintenance window; Imani wants visibility into old service accounts. Junior officer Eli Chen mentions someone asking about crew cover during upcoming leave on an entertainment world. | A concise crew note records the concern without declaring it hostile. No pop-up interrogation or forced questionnaire. |
| 2:00-3:00 | Install Identity Security or Network Monitoring using one available upgrade allocation. Delegate commissioning to Mara, or handle the two short verification steps personally. | The relevant station module visibly changes. Delegating frees attention for the crew conversation; personal verification supplies a clearer baseline. Both routes are viable and record a leadership consequence. |
| 3:00-4:00 | During commissioning, monitor normal maintenance activity and a developing remote-service anomaly. Inspect a small evidence card when desired. | Identity upgrade identifies the legacy account earlier; network upgrade identifies the source/service path earlier. Neither automatically fixes the problem. |
| 4:00-6:00 | Investigate the account and connection; use identity controls to retire/rotate the default credential, or restrict the remote-maintenance route while preparing that fix. Reopen the legitimate route after verification if it was isolated. | Credential rotation closes this attack path. Route isolation buys time but delays maintenance. Ignoring the evidence permits a specifically simulated unauthorized session; the player can still revoke it and recover. |
| 6:00-7:00 | Verify service restoration, hear a brief crew response, review performance and standings. | A compact debrief explains actions and service/security tradeoffs. The player sees fourteen simulated competing lieutenants and future responsibilities. |

All timings are provisional pacing, not changes to P12 deadlines. Players remain free to inspect the orbital environment during background work. Dialogue is two or three short lines per interaction and remains revisitable. No mandatory question rounds, four-answer test, or percentage-correct mechanic.

## Visual proposal

- Keep the station and Earth visible for most play. Minimal top identity strip, small objective/crew notification rail and contextual module controls; expand details only on demand.
- Build an isometric/layered 2.5D station: separate habitat/core, solar wings, identity gateway and monitoring dish, with restrained emissive windows, shadows, slow orbital drift and a maintenance craft. Clickable native Godot hit areas identify actual operational modules.
- Reuse original images/space.jpg as a subdued deep-space layer, leaving it unchanged. It contains stylized planets rather than an identifiable Earth, so add a separate blue/ocean/cloud Earth limb using native layered geometry and a lightweight atmosphere shader. Do not call one of the existing colored planets Earth.
- Reuse the P13 schematic's composition as a guide, not modify its script. Existing images/data.png is a gold network globe; datacenter.png is a brightly colored tower. Neither is a detailed orbital station and neither should be stretched into one.
- Missing artwork: detailed orbital station modules, recognizably Earth-like backdrop, crew portraits and service craft. Use new Godot-native vector/layered assets with distinct crew initials/portraits as achievable baseline; no paid assets, external dependency or large 3D modeling effort. A visual checkpoint of the station at all three resolutions precedes further polish. Do not claim photorealism or cinematic quality.
- Native containers and responsive margins; body type stays readable. Cyan identifies structure, amber uncertainty and red observed danger. No permanent spreadsheet or oversized dialogue panel.

## Security scenario and consequence model

Reuse canonical attack ID 53. Its authoritative short catalog label is DEF PASS; the existing Report obtains the full label from learning_retrofit.json: "Default credential exploitation". Use that full existing display label, without abbreviation, in every P14 incident list/detail. Do not edit either catalog to change capitalization or content.

Scenario: an old vendor maintenance endpoint still accepts a factory credential. This is an explicitly authored P14 training scenario, not evidence extracted from P12. An outsider's questions about leave coverage provide an ambiguous human-intelligence thread; the lieutenant is not told that the conversation caused the network activity.

Keep separate facts/states:
1. External approach/physical arrival, if referenced, is not an access result; no new combat sequence is required.
2. Suspicious attempts: simulated failed logins or unusual remote-service connections.
3. Unauthorized access: only when the scripted service actually accepts the unchanged credential.
4. Confirmed compromise: not automatically inferred from arrival or login; the small demo need not claim data theft, persistence or widespread compromise.

Operational interaction is object-based: inspect the account/connection, retire the default account or rotate its credential, quarantine/unquarantine the specific maintenance route, then verify the service. These are capabilities with state and costs, not mutually exclusive answer choices. Restricting a route does not repair credentials. Credential rotation does not prove that every potential incident is resolved. Inaction or incomplete mitigation produces a recoverable service/security consequence and crew feedback, not an immediate game over.

Every invented evidence view is visibly labeled SIMULATED EXERCISE EVIDENCE. No fabricated data is inserted into the P12 canonical ledger or P13 arrival registry. Rich educational definitions remain optional, using the existing canonical-ID content; its editorial approval flags stay unchanged.

## Martian purpose and information boundaries

Author one small adversary objective: learn maintenance coverage and identify unattended remote access during the leave rotation. The War Room planning record marks assumptions as perceived intelligence, not confirmed facts. It is not an autonomous AI system.

Proposed presentation: retain uncertainty during the human mission; make a clearly labeled optional adversary debrief available after the outcome. This supplies the corresponding War Room objective without giving the lieutenant omniscient knowledge before decisions. Existing P12 War Room screens and plans remain unchanged. No entertainment-planet map, romance, attack execution engine or additional campaign system.

## Performance and ambitions

A small standings drawer shows all fifteen installations: the player's event-derived result plus fourteen fixed, clearly labeled simulated competitor profiles. No fifteen-station simulation.

Five simple, documented demonstration measures: operational readiness, security effectiveness, infrastructure development, resource stewardship and leadership/personnel development. Changes come from commissioning, service continuity, response and delegation/verification events. A small bounded deterministic event-delta table drives the debrief; no quiz points, hidden random ranking or modifications to existing official scores.

Company ambitions: Lieutenant = command one installation; Commander = future oversight of five; Fleet Commander = future oversight of fifteen. Higher positions are initially unfilled. No promotion engine or fleet authority is awarded in this prototype.

## Proposed isolated files

- scene/prototype14_commanders_experience.tscn: standalone launch scene; does not extend the P12 quiz/command controller or instantiate a hidden second accepted simulation.
- script/p14/command_experience.gd: new scene orchestration, module interactions and navigation.
- script/p14/command_session.gd: small deterministic local scenario state, commissioning jobs, evidence stages and performance events.
- script/p14/station_view.gd and new local visual resources: layered station, Earth atmosphere, module feedback and subtle activity.
- script/p14/crew_interaction.gd: three characters, short exchanges and delegate/personal commissioning task.
- script/p14/operations_panel.gd: contextual account/route actions and read-only evidence.
- script/p14/command_debrief.gd: outcomes, standings, optional adversary debrief and responsibility descriptions.
- data/p14/first_watch.json: one authored scenario, dialogue, explicit simulation labels, competitor fixtures and deterministic performance deltas; canonical attack ID reference only.
- tests/prototype14_command_session_test.gd and prototype14_command_ui_test.gd, with Godot UID sidecars.
- A Phase B/C completion report and rendered evidence outside the source tree.

This is a proposed file boundary, not a requirement to create a framework. Combine tiny presentation components if that keeps the implementation smaller. Reuse visual conventions, native controls, read-only canonical-ID content and existing test helpers; do not couple P14 to old grading, deadlines, projectile queues, internal-arrival writes or scoring.

Launch manually in the editor with F6 on the new scene, or via Godot --path . res://scene/prototype14_commanders_experience.tscn. The current default remains res://scene/prototype13_command.tscn until separate owner approval, even after P14 verification. No new branch or Git publication is included in this plan.

## Verification after implementation approval

- Run catalog/editorial validation and existing P3-P13 regressions sequentially. P13's 27-assertion rendered suite and prior 48-job runner provide an existing foundation; they have been inspected, not rerun during Phase A.
- Focused model tests: both upgrades useful and distinct; task delegation/personal completion; evidence/access distinctions; route restriction versus credential repair; recovery; deterministic five-category performance; fourteen simulated competitors; no accepted-registry/score writes; reset only the new local scenario.
- Focused rendered tests: module actions, crew interactions, no quiz gating, full attack labels/wrapping, outcome feedback, keyboard/mouse, clean return/restart, optional adversary debrief gated until outcome.
- Capture and inspect 1600 x 900, 1280 x 720 and 1920 x 1080: station, crew dialogue, each installed upgrade, developing incident/action, debrief and standings. Check readable controls and the orbital environment remaining visible.
- Exercise one entire successful route and one recoverable delayed/ineffective route using available UI tools; report measured duration, actual inputs and limitations. Do not call scripted viewport tests a manual desktop playthrough.
- Compare protected source/data hashes, current main-scene setting, six-center gameplay, P13 arrivals/console and existing tags after implementation.

## Risks and proposed controls

- Artwork is the largest risk: approve an actual station screenshot early; native layered art is the fallback, not a promise of production-quality assets.
- Scope creep: one watch, one installation, one infrastructure allocation and one security situation only.
- A new incident model could accidentally alter accepted scoring: use a separate P14 session and event list, with no inheritance from accepted command evaluators.
- Fifteen-center fiction could be mistaken for an expansion of P12's six: P14 standings are local fictional fixtures; do not add canonical P12 centers.
- A text-heavy control panel could recreate the original problem: station-first interactions and optional detail, with short dialogue rather than mandatory reports.
- Pacing may be too short or feel like waiting: measured first-play timing and concurrent commissioning/crew activity are required before claiming a five-to-ten-minute experience.

## Approval boundary

Phase A only is complete. Request owner approval for this small "First Watch" scenario, its isolated presentation/state, and the proposed visual approach before writing gameplay code. No default-startup change is proposed for automatic approval.

## Verified external backup

- ZIP: `C:\Users\azwam\Projects\Backups\P14_Phase_A_2026-10-29_120305\Orbital_Defense_Command_Pre_Prototype14.zip`
- File count: 347
- Size: 5944111 bytes
- SHA-256: `fef11699f0c764073e4376f79fe7e82f35f198e357e862fa92a528bfbbf50408`
- CRC passed; inventory matched; every archive entry SHA-256 matched its source. Backup includes all intended modified/untracked P13 source and reports. Git metadata, reproducible caches, temporary logs and unrelated generated executables were excluded and left on disk. Manifest: `C:\Users\azwam\Projects\Backups\P14_Phase_A_2026-10-29_120305\backup_manifest.json`.

Only this planning report was added during Phase A. No source or configuration file changed; no regression result is claimed for this inspection-only phase.
