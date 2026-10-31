# Command navigation and live incident continuity - Phase A

Status: inspection/design only. Awaiting owner approval; no Phase B implementation or gameplay edits.

## 1. Baseline and preservation

Branch: `feature/prototype13-datacenter-defense`. HEAD: `c6646b008657f98b500e019a71b6521f58a76509`. `project.godot` is modified and selects `res://scene/odc_entry.tscn`. P13/P14 source, scenes, data, tests, launchers and reports remain untracked, as in the completed wrap-up. No staged changes. Existing `new_projectV2/` generated executables and `tools/__pycache__/` remain untouched.

The 11 wrap-up implementation/test file hashes still match `Backups/P14_Wrapup_2026-10-29_171115/wrapup_source_freeze.json`. The pre-wrap-up ZIP in that directory remains intact: 365 files, SHA-256 `12456ee33ddd18f43cc738ba4f40dfa23851405e655389af3451ff009afe0de3`. That is a pre-wrap-up backup, not a backup of the completed current state. Earlier P13 and P12 publication backups also remain under `C:/Users/azwam/Projects/Backups`. A NEW verified current-state ZIP must be created before approved Phase B edits.

The latest runtime question-generation metadata was copied read-only to `Backups/ODC_Navigation_PhaseA_2026-10-29_203257/` with a source hash and timestamp. No Godot instance was launched or closed, and no tests were rerun during inspection: starting another learning scene would overwrite that useful metadata. No branches, references, catalogs or collaborator artwork were changed.

## 2. Actual dropdown and screen architecture

The current role dropdown is `role_select`, built in `script/sliding_command_ui.gd` and inherited by `visual_command_ui.gd`, `refined_command_ui.gd` and the direct-response adapter. It appears through the nested `scene/direct_command.tscn` inside `scene/prototype13_command.tscn`. `retrofit_learning_game.gd::arrange_toolbar()` moves it into the present toolbar.

Its literal current entries are **Tactical Officer** and **Operations Commander**. No literal **Strategic Officer** menu entry was found in current scripts/scenes. The owner may be referring to the higher-level operations/strategic function. Do not rename an assumed screen without recognizing this distinction.

- Tactical Officer sets `command.command_level="tactical"` and opens the existing Threat drawer. It does not select a new center or create a lieutenant.
- Operations Commander sets the level to `operations` and opens the Contacts drawer. The original mission UI also has a two-entry responsibility control; it is a legacy adapter, not a separate mission.
- Overview/Contacts, Threat Response, Evidence, History and Mission Scorecard all share the existing `CommandCenter` instance, tactical actors, public projections and official ledger. They are not separately initialized games.
- The separate top center selector is populated from `command.tactical_centers` (three canonical centers). The six-center learning selector below it uses `learning_contacts` and includes DC-04 through DC-06. These are not interchangeable registries.
- The learning wrapper connects original information/quick-action buttons to `leave_learning()`. That changes presentation context, not the learning-session instance. The role control itself only opens legacy drawers; it does not open First Watch or the P13 console.
- Command Desk is currently outside that system. It owns a resumable P14 instance until `change_scene_to_file(prototype13_command.tscn)` replaces the desk. Consequently its P14 instance is discarded when Orbital Command starts. The live game has no in-session route back to the retained desk/watch.

Changing menu text alone cannot preserve a mission or make the three-center tactical registry handle a fourth center.

## 3. Six-center inventory

| Center | Existing representation and identities | Available interfaces / assignment |
|---|---|---|
| DC-01 | Canonical tactical contacts 1,2,3 plus surveillance 10,11,12; P12 physical targets and learning display | Legacy tactical/response/evidence/history/scorecard; live read-only P13 Security Console; separate P14 Lieutenant exercise and three ranked crew |
| DC-02 | Canonical tactical contacts 4,5,6 plus surveillance 13,14,15; P12 learning display | Shared legacy tactical screens and learning controls; no distinct crew command scene or security console |
| DC-03 | Canonical tactical contacts 7,8,9 plus surveillance 16,17,18; P12 learning display | Same shared tactical/learning facilities; no distinct crew command scene or security console |
| DC-04 | P12 learning-only slots 401-406 and persistent physical target versions | Learning orbital tile, launches/status/warnings and Martian planning; no canonical P10 tactical actor or named officer |
| DC-05 | P12 learning-only slots 501-506 and physical target versions | Same learning-only facilities; no canonical tactical actor or named officer |
| DC-06 | P12 learning-only slots 601-606 and physical target versions | Same learning-only facilities; no canonical tactical actor or named officer |

Sources: `data/strategic_centers.json`, `data/orbital_intelligence.json`, `six_center_learning_game.gd`, `martian_learning_session.gd`. All six can own current P12 internal-arrival records. Only DC-01 currently has the new console. The fourteen competitor identities in P14 are simulated standings fixtures, not officer assignments in the live six-center model. DC-07 through DC-15 are planned company locations only; do not instantiate them.

## 4. Threat lifecycle and authority

1. `rich_learning_loader.gd` validates canonical v12 IDs/names/mappings against `cyber_catalog.json` and the additive editorial layer. A seed chooses 22 attacks across five rounds. Each learning question has a distinct learning ID and explicit center/contact binding. Full readable names come from `learning_retrofit.json`; original canonical names remain provenance. Editorial candidate status remains unchanged.
2. `martian_learning_session.gd` binds questions to stable physical IDs such as `DC-01/C-002/P01`. Surviving physical targets may be reused; destroyed targets cannot resurrect. Contact ID alone is not an incident identity.
3. `correct_only_learning_session.gd`, refined by `rich_learning_session.gd` and `player_fire_session.gd`, owns answer validation, partial submissions, authorization, WAIT and the 15-second launch queue. Incorrect combat answers produce NOT LAUNCHED; unanswered/manual-authorized/queued/airborne states produce no arrival.
4. Correct authorized missiles use the existing launch claim and 36-second flight. AUTO/PLAYER modes consume the same queue. Monte Carlo evasion uses its own deterministic stream. Each attempted evasion has its own stored roll.
5. The authoritative impact callback calls `session.finish_shot`. Correctness remains correct when physical outcome is EVADED. Failed/no evasion gives HIT. A current correct-only launched missile does not normally produce generic MISS: that remains a legacy incorrect-shot outcome. A visually observed miss must be checked against the completed source result, not translated into an arrival by appearance alone.
6. `player_fire_session.gd::_record_internal_arrival` creates first-arrival records keyed by physical ID. EVADED produces EVADED_INTERCEPTION; incorrect combat NOT LAUNCHED produces UNOPPOSED_ARRIVAL. HIT, pending/unanswered states and noncombat review do not. Duplicate callbacks cannot replace the first arrival.
7. The record contains physical/contact/learning IDs, center, canonical attack ID, captured attack name, outcome, cause, simulation arrival time, ARRIVED_INTERNAL and compromise_confirmed=false. It does not contain a mission UUID, real arrival date, network telemetry or proof of unauthorized access.
8. `orbital_security_console.gd` calls the SAME `session.internal_for_center("DC-01")`, lists copies and reads the corresponding attack lesson by canonical ID. It cannot resolve incidents. Its center strings are currently hardcoded to DC-01.
9. Round advancement preserves the internal registry. Explicit learning restart clears it along with learning physical/results state and increments generation; it does not reset the older P10 official mission ledger. Replacing the entire P13 scene or closing the process discards the live session. No live incident disk persistence exists.

These are facts from the runtime learning scenario, not real DNS telemetry or new canonical P10 compromise events.

## 5. Owner's DNS case: evidence and disconnect

The latest saved `user://prototype12_catalog_session.json`, modified locally at 2026-10-29 20:14:45, records seed **2949072717**, evasion seed **3935372809**, and first-round DC-01 question `R01/RETROFIT-V12-033`, contact 2, canonical attack ID **33**. Its canonical source name is **DNS POISON**; the full editorial display name used by the Report is **DNS cache poisoning**. Catalog ID 82 is a different entry, DNS ATTACK / DNS infrastructure abuse. They must not be conflated. ID 33 has authoritative mapping pairs to defenses 54 and 55; these remain unchanged.

This identifies the latest recorded question selection, but DOES NOT prove the owner's completed outcome. The metadata stores no grades, evasion result or arrival registry. Existing logs expose no matching completed arrival snapshot. The registry lives in the running process; it cannot be reconstructed from a seed alone because player choices/order/timing affect results. Therefore whether this particular observed encounter reached the arrival callback is **not recoverable from the available persisted evidence**. Do not claim that it was recorded or that the exact prior encounter has been reproduced.

If that correct-answer missile completed with authoritative EVADED, the current code should record its arrival and the existing DC-01 Security Console should show it. If it completed HIT, there should be no internal arrival. If visuals missed but the stored outcome disagrees or the callback never completed, that is a separate defect to report before changing evaluation rules. No available evidence establishes an unauthorized network session or confirmed compromise.

The First Watch disconnect is nevertheless definite: `data/p14/first_watch.json` fixes attack_id=53; `p14/command_session.gd::configure()` always loads **Default credential exploitation**. Its local jobs, clock, journal, simulated login and checklist never query P12/P13. Returning to the hosted watch resumes that exercise; recreating it starts that exercise again. It is not a live incident command view. Substituting DNS into its JSON would misrepresent invented credential telemetry as DNS evidence.

## 6. Recommended navigation and authority

Retain Command Desk as a persistent application host, rather than replacing it when starting Orbital Command. Instantiate the existing P13 scene once and retain it across ordinary view navigation. Retain First Watch independently as training.

Use a center-aware Command Navigation dropdown in the existing role-control location:

- Orbital Command - overall live mission view.
- DC-01 - Tactical Command (your assignment).
- DC-02 through DC-06 - Tactical Status (observer).
- Fleet Command - monitoring overview / no fleet appointment.
- The First Watch - Training (DC-01).
- Command Desk / current mission access.

No operational entries for DC-07 through DC-15. Show the future 1/5/15 career structure as information only. Do not grant career authority over competing centers. Existing six-center learning commands retain their current scenario permissions; the new observer views add no execution privileges. Preserve useful Operations Commander functionality as the existing legacy operations view reachable from Fleet monitoring, clearly distinguished from a promotion.

Implement the visible dropdown as an adapter in the P13 wrapper, leaving the hidden legacy two-entry role control intact. Several accepted controllers call `role_select.select(0/1)` directly; arbitrarily adding center items would break those assumptions. Preserve original drawers, confirmation paths, scorecard and center actors. Pass explicit center IDs through all new routes. Never call the three-center `command.focus_center` for DC-04/05/06 or fall back silently to DC-01.

Each Tactical Command/Status opens a compact live summary and incident list for that center, with access to its orbital view and a parameterized read-only Security Console. DC-01 keeps its existing console entry as well. Label investigation/containment as unavailable where unsupported. Provide a separate Training entry; operational arrivals never populate the credential-exercise checklist.

## 7. Minimal live handoff and lifecycle contract

Add a read-only projection over the existing session, NOT another incident registry. It joins a first-arrival row to `all_results[row.learning_id]`, validating physical and center IDs. Never look up a historical arrival by the latest question in a reused contact slot.

Projection fields: application mission/epoch ID, physical/learning/contact/center IDs, canonical attack ID and source name, full editorial display name, recorded answer/defense ID and correctness when available, physical outcome/cause, simulation arrival time, source=orbital_learning_session, ARRIVED_INTERNAL, and compromise-confirmation flag. Missing facts stay unavailable. Separate educational definitions from recorded operational evidence. Do not fabricate real timestamps or use metadata file modification time as arrival time.

Attach a session-only identity using an application run ID plus mission sequence and learning generation. It must not consume the evasion/question RNG. Preserve the original registry schema and first-arrival semantics; projection metadata is not a replacement source of truth.

Rules:

- Ordinary center/view navigation retains the SAME live session and does not pause, reset, fire or grade anything. Existing strategic pause/Active Challenge rules continue.
- Switching centers filters by exact center ID and invalidates an incompatible incident selection.
- Multiple physical arrivals remain independent. Repeated refreshes do not append records. Reusing a survivor in a later question does not overwrite its first recorded arrival.
- Completed rounds/engagement history are not automatically resolved internal incidents. All current arrivals remain unresolved; no close/resolve mechanic exists or is proposed. HIT is a completed engagement with no new arrival, not a resolved intrusion.
- Add an explicit confirmed New Mission action at Command Desk, replacing only the live P13 instance and selecting a fresh seed through the existing initialization. Old incident selections are cleared. No previous-mission records remain presented as current.
- Keep existing Restart Learning semantics intact: it clears learning arrivals and changes the projection epoch, while the P10 official ledger retains its existing behavior. Display that distinction.
- Exiting the application discards live/training state. No disk persistence or previous-mission archive is added.

Training safety proposal requiring approval: entering/resuming First Watch during an active live mission is allowed only in Learning Mode, with strategic pause explicitly selected by the player and no pending launches/flights/effects. Active Challenge cannot enter training mid-mission. Do not silently pause or run hidden missiles during training. The training watch retains its own clock/pause state; returning leaves live strategic pause as selected until the player resumes it. First Watch remains freely available before live mission initialization. The host must handle CanvasLayer visibility and input ownership without disabling the live authoritative processors or allowing UI clicks to fire.

## 8. Proposed exact file scope

Modify:

- `script/odc_entry.gd` - persistent host, resume/current/new mission and training entry policy.
- `script/prototype13_command.gd` - navigation adapter, explicit selected-center routing, external-view input guard and live summary access.
- `script/orbital_security_console.gd` - configurable center (DC-01 default), full-name projection and registry-bound details.
- `script/p14/command_experience.gd` - unmistakable training badge and hosted return route; no live incident substitution.
- `tests/prototype13_security_console_test.gd` - retain DC-01 cases and add center isolation/configurable title coverage.
- `tests/prototype14_wrapup_test.gd` - update the obsolete destructive scene-replacement expectation to same-instance live/training navigation.

Add, with Godot UID sidecars:

- `script/command_navigation.gd` - visible menu adapter and explicit route metadata.
- `script/orbital_command_context.gd` - session ownership/mission-epoch metadata; no incident duplicate store.
- `script/live_incident_projection.gd` - read-only identity-safe joins.
- `script/orbital_tactical_console.gd` - center-aware live command/status panel.
- `tests/live_incident_projection_test.gd`.
- `tests/command_navigation_continuity_test.gd`.
- Timestamped Phase B completion report under `Reports/`.

Keep `project.godot`, existing scene assets, both launchers, P14 scenario/session/checklist, accepted command evaluators, catalog/editorial data, missile/evasion logic and collaborator artwork unchanged. Existing launchers continue pointing to the same entry scene. If inspection during implementation reveals that protected gameplay logic needs correction, report that separately instead of expanding scope.

## 9. Testable implementation milestones and risks

1. Verified current-state external ZIP and source/Git manifest; no branch/ref changes.
2. Persistent host and menu: launch from the batch file, initialize a mission, visit all six center views, return, and assert the identical session/clock/queue/results survive. Verify no new authority and no wrong-center fallback.
3. Read-only projection/console: preserve the captured metadata; reproducibly generate ID 33 at DC-01 using the recorded seed and actual mappings. Exercise correct answer plus authoritative successful evasion through rendered launch/passage, verify the same physical ID/full attack name/cause in Tactical Command and Security Console. Repeat with HIT (no arrival), incorrect/unopposed arrival and multiple centers. No fake DNS access logs.
4. Lifecycle: revisit DC-01 and another center, progress rounds, switch modes, inspect history, reset learning, initialize a fresh mission and verify no stale/cross-center records. Verify mission IDs do not change RNG outcomes.
5. Training: clearly separate badge/state, preserve both upgrade paths/checklist/ranks/story, test pause-gated entry and resume, no accidental missile firing through overlays. Preserve Active Challenge semantics.
6. Sequential P3-P14/relevant retrofit regressions, native rendered navigation and screenshots at common desktop resolutions; actual launcher test. Report exact files/results and any unresolved runtime discrepancy.

Risks: nested CanvasLayers and input guards; mixed canonical/learning center models; reused contact IDs; seed versus actual outcome ambiguity; legacy hardcoded role indices; accidental live reset from scene replacement; confusing pedagogical correctness with successful containment; editorial display names versus canonical short names. The proposed wrapper/projection approach confines these risks and does not rewrite P12/P13/P14 evaluators.

## 10. Owner approval requested

Approve the persistent-host/navigation approach, observer-only access for competing centers, read-only live incident command views distinct from First Watch Training, the explicit New Mission action, and the training entry safety gate above. No live SIEM, remediation, career progression or shared P14 simulated incident workflow is proposed.

The reported prior DNS arrival cannot be forensically confirmed from available persisted data. Phase B should reproduce the identified DNS scenario and verify the actual callback/registry in the running game, not claim to recover an unsaved historical outcome.

STOP: Phase A complete. No Phase B development started.
