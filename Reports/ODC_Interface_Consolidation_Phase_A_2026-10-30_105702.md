# ODC command interface - inventory and consolidation recommendations

PHASE A ONLY. Analysis, not an approved redesign. No gameplay, controls, scenes, data or images modified. The supplied assignment ends after the word "These" in section 5; this report covers the received scope and does not infer additional instructions.

## Main recommendation

Keep one orbital command workspace with **Overview, Assessment, Evidence and History**, plus a single center selector and a collapsible selected-threat panel. Put mission results, personnel/enterprise functions and application/session commands in secondary navigation. Keep First Watch training and adversary planning explicitly separate perspectives. Consolidate repeated views; do not combine their different authoritative evaluators, clocks or scores.

The current problem is partly presentation duplication and partly ambiguous context: "contact", "defense", "report", "mission" and "command" can refer to three different gameplay models. A cleaner layout needs explicit source and center identity, not just fewer buttons.

## Baseline and inspection limits

Current branch: `feature/prototype13-datacenter-defense`. HEAD: `c6646b008657f98b500e019a71b6521f58a76509`. Existing `project.godot` modification and untracked P13/P14/continuity work remain. No staged changes. The 12 continuity implementation/test file hashes match the prior verified delivery freeze. No Git refs changed.

This is a source-backed inventory of the current startup hierarchy and its inherited UI, checked against the existing rendered evidence from the latest delivery. No new game session or regression run was started: doing so can overwrite runtime question-generation metadata. Historical compatibility scenes are identified separately from controls actually exposed by the main entry.

## 1. Source map and authoritative models

Default launch: `Launch_Orbital_Defense_Command.bat` -> `scene/odc_entry.tscn` / `script/odc_entry.gd`. Persistent live instance: `scene/prototype13_command.tscn` / `script/prototype13_command.gd`, extending `retrofit_learning_game.gd` -> `correct_only_learning_game.gd` -> `six_center_learning_game.gd` -> inherited learning components. Its nested `scene/direct_command.tscn` inherits refined/visual/sliding/decision/cyber/operational command scenes.

| Model | Authority | Meaning and boundaries |
|---|---|---|
| Original operational scenario | `command_center.gd`, `strategic_registry.gd`, tactical `game.gd`/intelligence, `operations_session.gd`, `cyber_session.gd`, `mission_ledger.gd` | Three canonical centers, 18 monitored contacts with public reports, accepted command/confirmation rules and official mission score. |
| Current six-center learning mission | `rich_learning_loader.gd`, `player_fire_session.gd` and inherited learning session classes | Six centers, 22 questions, partial submissions, authorized/staggered missiles, physical targets, evasion and learning scores. DC-04-06 are learning-only extensions. |
| Internal arrivals | SAME learning session's `internal_threats`; `live_incident_projection.gd` reads it | First arrival per physical target. Correctness and physical HIT/EVADED are distinct. Arrival does not establish compromise. |
| First Watch training | `data/p14/first_watch.json`, `script/p14/command_session.gd` | Separate credential exercise, crew, jobs, checklist, watch score, journal and simulated standings. Not live incident telemetry. |
| Martian planning | `martian_war_room.gd::planned_attacks` | Separate mockup planning state; no real reconnaissance or attack execution. |

A shared center/contact label does not make these models the same encounter. Stable context should include mission/generation, center, physical target, question or operational contact ID, and source domain.

## 2. Interface comparison and recommendations

Legend: duplication judgments concern the current build. KEEP preserves a distinct purpose; MERGE means share a presentation destination, not merge databases or command evaluators.

| Screen/control family and actual source | Information shown | Actions | Data source | Overlap / necessary? | Recommendation |
|---|---|---|---|---|---|
| Command Desk (`odc_entry.gd`, `odc_entry.tscn`) | Current mission, run/pause notice, training access | Open/resume mission, training, confirmed New Mission | Persistent host/context | Mission access repeated in dropdown; start/resume entry is useful | KEEP as session entry; RELOCATE in-play return to application menu |
| Command Navigation dropdown (`command_navigation.gd`, P13 wrapper) | Orbital, six center routes, Fleet, training, desk | Route without replacing session | `orbital_command_context.gd` | Repeats two center selectors and top Overview | MERGE into one location/center selector plus secondary workspace menu |
| Orbital Command (`prototype13_command.tscn`, `six_center_display.gd`, `pursuit_display.gd`) | Orbital tiles, targets, projectiles, warnings/statuses | Pick targets/centers, view reset | Learning physical registry plus original visual actors | Essential situational view, not a replacement incident list | KEEP as main canvas |
| Top O / Command Overview (`visual_command_ui.gd`) | Counts of contacts, attention, investigations, escalations, centers, deadlines | Open filtered contact list | Original operational public state | Repeats Contacts counts/Fleet; useful overview/list drill-down | MERGE with group Overview, retaining filtered links |
| Top C / Contacts pipeline (`refined_command_ui.gd`) | Seven sortable/filterable columns | Select original contact; open Threat | Original 18-contact registry/operations | List necessary, separate permanent O/C destinations unnecessary | MERGE under Overview as list view |
| Canonical top center selector (`sliding_command_ui.gd`) | DC-01-03 | Focus original center/contact | `command.tactical_centers` | Competes with six-center selector and command dropdown; different source coverage | MERGE presentation through typed center adapter; retain original actor model |
| Learning center selector, 6 CENTERS, RESET TO 1 DATA CENTER (`six_center_learning_game.gd`, inherited learning game) | Six-center/group versus individual layout | Select view, manual/deferred reset | Learning center/physical state | Some redundant selection, but view scale is a distinct action | KEEP group/individual toggle; MERGE center selection; RENAME reset to a clear view action if approved |
| DC-01 Tactical Command (`orbital_tactical_console.gd`) | Current arrivals, selected facts, full name, source ID/outcome, uncertainty | Select incident, Security Console, training, legacy tools, return | Read-only live projection | Most incident facts repeat Security Console | MERGE as center workspace overview with one incident inspector |
| DC-02-06 Tactical Status (same script) | Same per-center arrivals and observer assignment | Inspect only; legacy tactical tools disabled | Same projection filtered by center | Same UI is appropriate reuse, not duplicated data | KEEP observer permission distinction in shared center workspace |
| Security Console (`orbital_security_console.gd`) | Counts/list/details, definition, arrival causes, no-compromise caveat | Select incident; return; disabled Defend/Resolve | Same authoritative internal registry/projection | Duplicates Tactical Command's entire incident detail; no extra investigation engine exists | MERGE inspector with Tactical Command; KEEP explicit source facts and unavailable-action reasons |
| SECURITY CONSOLE tile entry (P13 wrapper) | DC-01 shortcut | Open same console | Same registry | Useful shortcut to same destination, not another screen | KEEP contextual shortcut pointing to shared inspector |
| Fleet Command / Operations Commander route (`prototype13_command.gd`) | Existing Contacts/operations view, no appointment notice | Open existing higher-level view | Original operations model | New label opens existing view; not a new fleet simulator | RENAME to Group Overview for six-center observation; retain legacy operations tools in a labeled subsection |
| Top T / Threat Response (`direct_response_ui.gd`) | Original contact public assessment, three suspected attacks, availability, latest command receipt | Cyber, physical, investigate, monitor/hold, escalation, accepted signal defense | Original intelligence, operations and cyber scenario evaluator | Bottom quick actions reopen these same sections; necessary shortcut if one owner | KEEP as Assessment/Response for the original operational source; no parallel executor |
| Threat subviews: Cyber Defense, Investigate, Monitor, Physical (`visual_command_ui.gd`) | Mapped controls, queue, monitoring state, physical availability | Existing validated requests/reviews; catalog-only choices stay non-executable | Original scenario + catalog + operations | Evidence links repeat E; control availability must remain discoverable | MERGE into one contextual response inspector with evidence deep-links |
| Operational Commands modal (`operations_ui.gd`, `contact_operations.gd`) | Accountability, escalation/investigation queue, state, reasons/receipts | Existing permitted operational actions and escalation confirmation | `operations_session.gd` | Repeats Threat state/commands but contains genuine rules and audit detail | RELOCATE within Response; preserve the sole existing execution/authorization path |
| Original Cyber response modal (`cyber_command.gd`) | Evidence, validated three scenario choices, limitations, containment receipt | Respond, escalate, monitor, hold | `cyber_session.gd` + operations | Overlaps catalog cards and Threat; some legacy routes still reach it | MERGE presentation into Response only after complete capability parity; never substitute arbitrary mapped defenses |
| Bottom quick bar: Investigate, Monitor, Cyber Defense, Physical Defense, Commands (visual/direct adapters) | Contextual shortcuts/status | Open/review same command paths | Same original owners | Necessary accessibility shortcut; not a second menu of reports | KEEP only executable/relevant contextual actions; do not merge Monitor and Hold Fire semantics |
| Command confirmation / escalation reason (`command_confirmation.gd`, direct/operations UI) | Target, proposed action, authority, deadline, reason | Explicit confirm/cancel | Existing authoritative command owner | Necessary safeguard, unlike redundant explanatory modals | KEEP; do not remove as visual duplication |
| Top E / Evidence, drawer Evidence tab (`visual_command_ui.gd`, `refined_command_ui.gd`) | Source reports, receipt/simulation times, current/superseded status, full detail | Filter/expand report | `intelligence_session.gd` history | Also quoted in Threat; report list/detail is useful | KEEP one Evidence destination; reference from inspector rather than copy full reports |
| Top H / Decision Timeline, drawer History tab (same adapters) | Chronological events, contact/center/type/time filters | Filter and expand | `command.cyber.journal` | Timeline and Evidence serve different questions; retain both | KEEP as History; add explicit source scopes rather than pretend it includes learning/P14 history already |
| Network after-action history (`cyber_command.gd`) | Full command/event text | Return/read | SAME `command.cyber.journal` | Duplicated presentation of Timeline's source | MERGE into History; preserve full event details and original records |
| Top M / Mission Scorecard (`mission_ui.gd`, refined scorecard) | Official categories/objectives, confirmed and unassessed values | Close, expand scoring details | `mission_ledger.gd` | Not the learning percentage or P14 watch rating | KEEP under Results / Official Mission; do not combine scores |
| Urgent indicator, original deadline table, learning deadline table (`direct_response_ui.gd`, refined/six-center adapters) | Urgent contacts and remaining times | Sort/select and open relevant context | Original deadlines versus authored learning deadlines | Similar layout, different deadline owners | MERGE visual list with source/owner filter; never copy deadlines across contacts |
| A / Analyze popup (`learning_game.gd`, six-center override) | Analyze all-centers question | Yes analyzes current round; No/Close does not | Learning loader/session | Entry ceremony not the assessment itself | RENAME to Prepare learning encounters or place as context action; preserve explicit initialization semantics |
| R / Report (`learning_game.gd`, `retrofit_learning_game.gd`) | Nine sortable columns, choices/results, current/history rounds | Select, explain, partial Submit, Close, Next Round, Restart | Learning questions, answers, results/history | Resembles contacts/incident report but is a distinct selection workflow | RELOCATE as Assessment > Learning Encounters; preserve partial submission, locks and history |
| D / Decide, WAIT, cancel and shot countdown (learning/retrofit scripts) | Selected eligible targets, authorization/launch timing | Fire/authorize now, wait 1/5/10 minutes, cancel pending queue | Authoritative learning queue / `player_fire_session.gd` | Submit Answers is another entry to same request API; confusing duplicated firing ceremony | MERGE destination into a submit/timing control group; preserve D shortcut and one submission owner |
| AUTO-FIRE/PLAYER FIRE, authorized target picker/launcher (retrofit and `learning_weapon_overlay.gd`) | Mode, authorized target, readiness | Mode change, select target, left-click authorized missile | Same correct-only queue | Mode and authorization are distinct from grade | KEEP in contextual bottom action area; never silently fire on mode/nav changes |
| Learning detail / QUESTION & LESSON / book icons (`learning_detail_panel.gd`, answer controls) | Attack scenario, definitions/examples, selected defense mechanism/conditions/limitations and post-evaluation reasons | Read; select where permitted; close to original report | Canonical-ID editorial layer + learning state | Global lesson button and per-option book open the same component | KEEP one reusable scrollable lesson panel; shortcuts may remain; do not duplicate full text on board |
| Result cells, correct/incorrect labels, tile status, score summary, feedback/Why (learning/retrofit/live display scripts) | Selected answer, grade, missile status, percentage, elapsed time | Inspect feedback/details | Same learning results/metrics | At-a-glance result plus detail is useful; repeated full paragraphs are not | KEEP terse board/tile feedback; RELOCATE explanations to lesson; retain separate answer/physical outcome fields |
| Completion prompt and missed-question review (`correct_only_learning_game.gd`, `rich_review_panel.gd`) | Original score, missed-only retry and separate review performance | Review/Finish Session, retry, Finish Review | Learning `all_results` + separate review model | Not the official scorecard; separate no-combat phase is necessary | KEEP under Results > Learning; make review identity/noncombat status explicit |
| Martian incoming defense (`monte_carlo_panel.gd`, `martian_defense_panel.gd`) | Incoming count, warning, attempts, physical results | EVADE ALL, Mute; Close only when resolved | Active projectiles and authoritative evasion outcomes | Not a human incident response console | KEEP contextual adversary overlay; do not merge into Earth response commands |
| Martian War Room planning (`martian_war_room.gd`) | Six perceived exposures, selected catalog attacks, draft plans, details | Select single/multiple/all, Apply Plan, details/back | Mockup `planned_attacks`, catalog | Same six IDs, but hypothetical adversary perspective; no live intelligence | RELOCATE under explicit Adversary Planning perspective; preserve no-execution boundary |
| First Watch Training (`prototype14_commanders_experience.tscn`, `p14/command_experience.gd`) | Station, crew, jobs, simulated incident, objective and messages | Crew dialogue, upgrade, operations, pause, return | Independent P14 session | Must not be mistaken for center live command | KEEP as named training experience, not another live command home |
| First Watch station modules / crew panels (same script) | Operations, identity/network evidence, three full-rank crew and concerns | Checks, audit/trace, credential retirement, session revocation, route isolate/restore, recovery verification; delegate/personal | P14 jobs and authored scenario | Relevant in-context actions, not duplicate P12 controls | KEEP; share visual components only, never their state/evaluator |
| Watch Officer's Checklist / next move / job status (`p14/watch_checklist.gd`, P14 UI) | Mandatory/optional, actual pending/blocked/verified state | Navigate procedures; cannot check off manually | P14 real state projection | Objective and checklist are complementary if compact | KEEP one compact next requirement plus expandable checklist |
| Watch journal, Watch report, Company/15 (`p14/command_experience.gd`) | Local events, performance bars, fourteen simulated competitors | File handover, compare standings, restart training | P14 session events/metrics and simulated fixtures | Repeated company links useful shortcuts; watch rating not official mission score | KEEP training report/journal; RELOCATE standings to Personnel/Enterprise with simulation badge |
| P14 optional attack lesson and post-watch adversary debrief (same script) | Credential lesson; gated adversary objective/Lumen intrigue | Read/back; debrief after completion only | P14 lesson/catalog and authored story | Planning mockup and story debrief are not interchangeable | KEEP lesson link; RENAME debrief to Training adversary debrief; preserve spoiler gate |
| Application/game control families | Close/Back/Escape; Pin/Unpin; Learning Mode/Active Challenge; PAUSE; New Mission/Restart | Navigation, timing and deliberate reset | Host and respective sessions | Inconsistent destinations and overlapping reset wording | STANDARDIZE Close versus Back and badges; KEEP separate pause/reset owners and confirmations |

### Historical/hidden UI is not another currently visible screen

`sliding_command_ui.gd::clean_legacy()` hides the old mission level selector/scorecard opener, operations opener/local panel and original cyber canvas; refined guards also suppress floating legacy HUDs. Their objects still adapt accepted commands. `scene/game.tscn` / `attack_info_panel.tscn` remains independently runnable with Investigate, Deploy, Hold Fire, Replay, mode and reading-pause controls. Earlier `learning_command`, `martian_learning_command`, `six_center_learning_command` and other checkpoint scenes are compatibility/test entry points, not items that should all appear in the new normal navigation. RETIRE duplicate visible entry paths only after routing all capabilities to the shared destination; preserve accepted scenes/tests/data until separately authorized.

## 3. What should and should not be merged

**Highest-value presentation merges:** Tactical Command + Security Console incident inspector; three center selectors; Overview + Contacts + the overlapping Fleet/Operations list; Timeline + raw after-action history; Report submission + Decide timing presentation. Keep contextual shortcuts when they open the same component and preserve selection.

**Necessary separation:** current evidence versus chronological history; original official score versus learning grade versus training performance; cybersecurity answer versus missile outcome; unresolved arrival versus confirmed compromise; live incident facts versus catalog lessons; human uncertainty versus Martian planning/spoilers. The current journals/registries are distinct, not accidental duplicate databases.

Learning detail currently uses an attack-level `distractor_reasoning` field in more than one post-evaluation section. Repeating it for different selected controls does not make it answer-specific. Show genuinely shared comparison reasoning once; preserve each defense's own definition/mechanism/limitations. More specific per-option reasons would require verified authored content, not generic generated filler.

## 4. Proposed information architecture

Application/workspace menu: Command Desk/session controls; Orbital Command; Training; Enterprise/Personnel; explicitly labeled Adversary perspective. Keep New Mission and Restart Training separate and confirmed as appropriate.

Within Orbital Command:

1. Top status strip: selected six-center group, selected center, actual incident/urgent counts, correct clock/pause state. Only measured values. No invented aggregate confidence or readiness percentage.
2. One center selector: Group overview or DC-01-06, visibly showing assignment/observer access. Keep location separate from rank and mode.
3. Left primary navigation: Overview, Assessment, Evidence, History, matching the inspected reference's overall composition.
4. Main orbital view stays visible. A compact right inspector shows selected source, center, full attack name, identity and current outcome; expand for detail.
5. Bottom contextual actions invoke the existing owner: original operational response OR learning submission/authorization, never an ambiguous generic Deploy that changes meaning unnoticed. Preserve necessary confirmation, WAIT, cancellation, player-fire readiness and pause.
6. Results secondary panel: distinct Official Mission, Learning Mission and First Watch Training sections. Preserve unassessed official values as unassessed. Keep chronological logs source-scoped and link rather than duplicate full evidence.

Select group -> select center -> select physical incident -> inspect facts/evidence/history. Retain this context on Back. Use a qualified identity, not visual row number or bare contact slot. Cross-domain links should explicitly say that another source/scenario is being opened. Do not silently equate operational intelligence with a learning question's attack.

## 5. Six-center Tactical Command Group

A six-center group view fits `six_center_display.gd` and existing route metadata. It does NOT mean six fully equivalent tactical simulations: DC-01-03 have canonical actors; DC-04-06 are learning-only extensions. A group adapter can present all six while keeping their existing records and capabilities distinct.

Recommended now: **group oversight as a viewing scope**, with Lieutenant assigned to DC-01 and observer access to the other five. A persistent group breadcrumb and center highlight let the player drill into one center and return to the 3x2 overview without changing mission or losing incident selection. Group counts should derive from qualified records; never add canonical contact counts and reused learning slots as if they were distinct real contacts.

This conflicts with assigning a Lieutenant actual command of all six. Earlier career design says Lieutenant=one center, Commander=five, Fleet Commander=fifteen. Six is neither one career unit nor one third of fifteen. Keep the six-center group as the prototype's current operational viewing set; do not silently change rank or supervision. If the owner wants actual six-center authority, explicitly approve an acting coordinator assignment and the effect on the five-center career model first. Planned DC-07-15 remain non-operational; do not fabricate stations or officers to fill menus.

## 6. Player identity recommendation

Offer an optional one-time session-name entry at Command Desk, editable later from Personnel. Store `player_name`, rank identifier/display name, duty, assigned center and any group appointment as separate session fields. Rank must not be embedded in the typed name or automatically grant permissions.

Trim outer whitespace, reject control characters and use a reasonable length limit; support normal Unicode names. Allow Skip with an honest "name not set" fallback. Display, for example, "Lieutenant Alex Morgan" with "DC-01 Commanding Officer" separately. Carry the same session identity into headers, personnel and reports. Do not implement accounts, passwords, a profile database or disk saves in this step. A later persistence design needs owner approval and must not use player-name edits to reset missions or alter random seeds.

## 7. Enterprise Staff Roster and future training

Place **Enterprise > Personnel > Staff Roster** in secondary navigation, reachable from Command Desk/workspace menu. Keep local DC-01 crew inside its center view, linked to their existing names/ranks/duties. Enterprise posts are not local watch crew and should not be inserted into the Tactical Center selector.

Candidate roster fields: position, person (or Vacant/Planned), rank where applicable, duty, organizational scope and availability. Preserve the distinction between military rank and civilian/program role. Supply Officer, Training Officer and Personnel Officer are duty assignments; Program Manager and Project Manager need not be military ranks. Do not invent appointees, resources or active staff powers.

Training Officer can eventually link to lesson library, First Watch and training/review results; Personnel Officer to assignments/development; Supply Officer to future logistics; Program/Project Managers to future initiatives. These are navigation recommendations only, not approved simulation systems. Keep the fourteen simulated competitor profiles clearly marked; do not turn their fixture names into verified enterprise staffing records. Remaining section-5 instructions were not received.

## 8. Visual references and StarSink artwork

The exact requested `Orbital Defense Command Interface(2).png` was not found in the repository or located image folders during inspection. The available `C:/Users/azwam/Downloads/Game Images/Orbital Defense Command Interface.png` was inspected as a related reference, not assumed to be the approved (2) revision. It supports a restrained top status bar, collapsible left navigation/right inspector, visible orbital canvas and contextual bottom actions. Its sample counts, confidences, defenses and timelines are illustrative, not authoritative game data. Its "slider" annotation should not turn display-only confidence bars into input controls or imply new game-speed rules.

Two identical StarSink copies were found:

- `C:/Users/azwam/Downloads/Game Images/Ships/StarSink.png`
- `C:/Users/azwam/Downloads/Art Ships/StarSink.png`

Both are 600x600 RGBA PNGs, SHA-256 `d543aab3db6fba1ed52c4f4e221a35a7928cf1cfe30e87330c4685746ff2cd4c`. They were viewed, not modified. The related interface reference is 1536x1024, SHA-256 `48e6296cb2e52689b024ca3138caa039134f4aa92b9ead0136575696703069c2`.

The obsolete target/value has multiple presentation paths:

- `scene/datacenter.tscn`: `images/data.png`, DATA label and literal `$1,000,000` ValueLabel.
- `script/learning_orbital_display.gd`: draws the old texture/DATA/value again in its earlier presentation.
- `script/six_center_display.gd`: current six-center center icon is a drawn gold DATA marker, not the same dollar-label scene.
- P13 station schematic and P14 station illustration already use separate artwork; do not replace those globally by accident.

Recommend a presentation-only StarSink center renderer, scaled for one/two/three/six-center views, retaining exact orbital origin, picking regions, projectile origin, relative motion and physical identities. Replace visible mortgage/value decoration with center ID/name; do not invent a replacement economic value. Preserve original assets and inspect transparency/edge readability at small tile sizes before acceptance. Some legacy tests explicitly assert the dollar label, so artwork-only acceptance requires intentional presentation-test updates, not silently changing scoring or dropping tests. No art imports, retouching, substitutions or value-label changes were performed.

## 9. Safe consolidation order and decisions

1. Confirm the complete assignment and exact (2) image. Approve the workspace map and six-center authority interpretation.
2. Consolidate center navigation and the shared incident inspector first; keep existing evaluators and registry contracts. Test same DNS identity across views, no cross-center contamination, first-arrival persistence, HIT exclusion and reset epochs.
3. Consolidate Overview/Contacts and History/after-action presentation with source filters. Preserve all records and real/simulation timestamp distinctions.
4. Consolidate learning submit/timing UI without changing partial submissions, locks, queue spacing, manual authorization, review grades or canonical command confirmations.
5. Apply reference styling and StarSink through isolated presentation components. Test picking, missile origins, pause, resizing and legacy compatibility. Keep the established P14 experience recognizable.
6. Add optional session player identity and a read-only enterprise-roster destination only after separate approval; no staffing/training engine or save system.

Owner decisions still required: complete section 5/any later instructions; exact reference (2); whether the six-center group is observational or actual new authority; acceptance of four primary destinations; where to expose source/workspace distinctions; artwork/value-label retirement scope; whether player naming remains session-only. No implementation is authorized by this analysis report.

Preservation: game source/data/UI files and images remain unchanged. This report is the only new project artifact for this assignment. No commits, tags, pushes, merges, resets, stashes, cleanup or branch changes.
