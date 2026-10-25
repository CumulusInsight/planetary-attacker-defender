# Prototype 9 ? Command Decision Interface & Multi-Threat Assessment

Created: 2026-10-24T19:35:41-07:00 ? America/Los_Angeles, Pacific Daylight Time, UTC offset -0700.

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Prototype_9_Decision_Interface_Refinement_2026-10-24_193541_01.md`

Status: **implemented locally, verified, awaiting owner visual acceptance**. No commit, tag, push, merge, release or Prototype 10 work.

## Repository and preserved baseline

Branch: `feature/prototype9-contact-escalation`. HEAD and accepted Prototype 8 tag target remain `a532946cfc2a22a503263eaf07cd2825590615c2`. All preceding local Prototype 9 work and historical reports remain present. The pre-existing P8 checkpoint-report addendum is byte-identical: SHA256 `2d3891b85f20285440ba2953bff5115ccea9ef0b7be98f8bdb96668096755431`.

Before editing, an external hash manifest recorded existing modified/untracked files. Comparison confirms `data/cyber_catalog.json`, `data/cyber_scenarios.json`, the original cyber evaluator and P8 addendum were preserved. Original circular/elliptical movement scripts, private fixture truth, official mission ledger and scoring configuration were not changed. No legacy regression assertions were edited.

The authoritative v12 source remains `C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db`, SHA256 `22867011a01db80a8766e7320d58aece09373f783a06700a97197c254eb6a871`. The Python read-only export verification passed again. No database content was modified or re-exported during this interface task.

## Files created

- `data/decision_assessments.json`: validated public-only physical/cyber hypotheses and recommendations for all eighteen contacts.
- `scene/decision_command.tscn`: thin inherited cyber command scene enabling the presentation extension.
- `script/decision_assessment.gd` and `.gd.uid`: validates public contacts/centers/confidence/attack references and joins v12 defense mappings.
- `script/decision_pages.gd` and `.gd.uid`: four-page navigation, summaries, report/history filters, explicit response inspection and delegation to existing command owners.
- `script/command_confirmation.gd` and `.gd.uid`: readable in-viewport confirmation/proposal overlay, avoiding an extra native desktop window.
- `script/report_presentation.gd` and `.gd.uid`: shared complete report/timestamp/supersession presentation.
- `tests/prototype9_decision_test.gd` and `.gd.uid`: rendered navigation, public-model, timestamp, availability and invariance checks.
- This new report, created exclusively rather than overwriting an earlier report.

## Files modified in this refinement

- `project.godot`: F5 opens `scene/decision_command.tscn`.
- `script/command_center.gd`: optional page component, timestamp configuration before tactical setup, and selected-row navigation into the decision page. Existing sort keys/comparator remain intact.
- `script/game.gd`: enables optional source-report receipt capture with an actual simulation-clock provider; movement, decisions and deadlines unchanged.
- `script/intelligence_session.gd`: public report-received signal and opt-in capture of real receipt metadata, preserving the existing report release schedule and private allowlist boundary.
- `script/attack_info_panel.gd`: displays timestamp metadata when present in the orbital console; legacy untimestamped content remains unchanged.
- `script/cyber_command.gd`: routes the existing tactical cyber entry to the new decision page when enabled; prior scene entries retain compatibility.
- `Reports/Orbital_Defense_Command_Game_Concept.md`: added section 25, preserving all prior sections.

Earlier P9 implementation files/reports remain uncommitted as before. No caches, screenshots, executables or temporary logs were intentionally added to the repository.

## Four-page navigation

### 1. Command Overview

Reuses the accepted eighteen-contact strategic table and native TreeItem identity. The seven original sort keys remain clickable ascending/descending, with numeric confidence/deadline and ordinal severity handling, missing values last and stable Contact ID ties. All eighteen rows remain scroll-accessible. A compact eighth **Attention priority** column uses public rules only: review a deadline at or below 60 seconds; otherwise review high assessed concern; otherwise routine monitoring. It is not a combined numerical risk score and does not classify hidden allegiance.

A selected row opens that contact's decision page. The persistent Assessment & Response navigation button is another clear route. Center cards still open orbital tactical view. No detailed reports are duplicated in the overview. Severity was widened after rendered inspection to prevent truncating Unassessed.

### 2. Threat Assessment & Response

A fixed page presents physical suspicion and confidence/evidence; three independent cyber hypotheses with exact v12 names/definitions, likelihood or Unknown, severity-if-present, supporting evidence and asset at risk; a public advisory recommendation; and four fixed action controls. The selected hypothesis opens database defense mechanisms in a single separate scroll region. Essential decisions, navigation and confirmation are outside long-report scrolling.

The controls distinguish physical review, cyber response, coordinated proposal, and monitoring/investigation. Existing operational escalation remains reachable through **Operational commands / escalate**. Original active encounters use a specifically labeled existing abstract signal-interference defense, preserving their accepted outcomes and deadline check. Orbital tactical view remains available without resetting selection or state.

### 3. Intelligence Analysis

Complete SIGINT, platform, trajectory and follow-up text remains available. Sources are grouped by type; receipt chronology is preserved within each group. A source filter changes presentation only. Original encounter/cyber briefs, old and current assessments, confidence, payload estimates, advisory options, supersession links and investigation status/evidence snapshots are retained. New source receipt timestamps are visible; missing historical times are not invented. Original immediate investigation follow-up time is taken from its existing action receipt.

### 4. After-Action & Decision History

Projects the existing canonical action journal plus public received-intelligence events and once-issued advisory recommendations. A filter selects the current contact or the full network. Entries remain chronological by append sequence and show actual local time/offset, simulation time, contact/center/path, command status, response and observed explanation. Report receipt entries include full timestamp/source/status metadata; supersession is annotated from current history without mutating the original event.

All pages retain the same selected Contact ID. The active page is identified by its heading and navigation marker. Top role, Learning/Challenge controls and mission scorecard remain accessible. The new pages cover the tactical presentation only while intentionally open; they are not permanent overlays over the orbit display. Existing operational controls remain an available subview rather than being discarded.

## Public multi-threat model and confidence provenance

`decision_assessments.json` contains only public assessment data. Validation requires exactly the registry's contacts, unique stable IDs, correct centers, one supported physical assessment state, three unique valid v12 attack IDs, confidence/likelihood in 0..100 or null, and authored evidence/source/recommendation strings.

| Contact | Physical public assessment / confidence | Three public cyber hypotheses / likelihood |
| --- | --- | --- |
| C-010 | Unknown / insufficient evidence / Unknown | VIRUS: 72%; WORM: 46%; RANSOM: 28% |
| C-011 | Suspected physical weapon / 55% | WORM: 60%; DDoS: 35%; VIRUS: Unknown |
| C-012 | No physical weapon currently suspected / 65% | RANSOM: 35%; VIRUS: Unknown; ROOTKIT: 20% |
| C-013 | Unknown / insufficient evidence / Unknown | ROOTKIT: 63%; RANSOM: 25%; VIRUS: Unknown |
| C-014 | Unknown / insufficient evidence / Unknown | DDoS: 68%; WORM: 30%; ROOTKIT: Unknown |

Other contacts receive three explicitly uncertain catalog hypotheses (VIRUS, WORM, DDoS), all with **Unknown** likelihood and an explicit lack-of-evidence statement. Their physical assessment/confidence is Unknown; no unknown contact is converted into a threat.

**Source of every new numerical estimate:** explicit authored public scenario values in `data/decision_assessments.json`, not an inference engine, database severity, private capability or observed frequency. C-010's initial 72% is carried into its public VIRUS hypothesis from the earlier authored cyber briefing; additional values are independent authored analyst estimates. Physical estimates are 55% for C-011's ambiguous instrument boom and 65% for C-012's current absence-of-identified-weapon assessment. Other physical confidence is Unknown. The five cyber-profile advisory recommendations have authored 60% confidence; other recommendations are Unknown. These are opinions, not calibrated statistics or confirmed possession.

Hypotheses can coexist. C-010's 72% + 46% + 28% totals 146% deliberately; they are not a mutually exclusive distribution. Severity is labeled **if present**, using the catalog's attack severity. It is not a likelihood or identity confidence.

No physical weapon or additional actual cyber payload was introduced. The five private cyber IDs, original effectiveness rules/conditions and P8 affiliations remain byte-identical. A peaceful probe can still be suspected of a physical or cyber threat; new public suspicions do not alter its actual identity.

## Defensive availability and consequence inspection

The model joins selected hypothesis attack IDs through the unchanged export's `attack_defenses` to exact defense IDs/names/purposes. Three attack hypotheses are **not** three defense choices.

- **INFORMATIONAL ONLY:** a mapped database defense without a previously validated response for this contact. Inspection is allowed; confirmation is disabled.
- **VALIDATED / requires escalation:** existing response rule exists, but the contact is not in its actionable state.
- **AVAILABLE / inspect and confirm:** validated, escalated, unused response; explicit confirmation delegates to the existing evaluator.
- **ALREADY ISSUED / unavailable:** cannot execute twice.

The confirmation states suspected attack addressed, purpose, limitations and possible result classes without revealing hidden effectiveness. Mapping alone never guarantees success. All fifteen existing validated choices remain reachable across the five contacts' hypotheses; ROOTKIT's less-effective Antivirus choice is reachable through that contact's public VIRUS alternative. No response rule was added or changed.

Physical interception executes only for non-cyber operational contacts where the earlier abstract interception model already allows it. It remains authorization/execution with unverified effect, not a confirmed kill. Physical defense for unsupported contacts and coordinated physical/cyber defense are clearly **UNAVAILABLE** proposals, with disabled confirmation. No new combat evaluator, physical trajectory, damage or scoring system exists.

Original active defense confirmation re-checks the authoritative deadline through the existing handler. The new page reads the actual receipt's acceptance status, rather than assuming a resolved encounter means a command was accepted; an exact-zero test verifies that expiry is shown as rejected. Existing hold-fire, release/de-escalation and replay controls remain in their accepted operational/orbital views.

## Intelligence timestamp correction

Root cause: previous after-action decisions were timestamped, but `intelligence_session.gd` stored only public content fields. Source reports lacked captured receipt metadata, so detailed intelligence remained undated.

In the new normal entry, source sessions capture receipt time at release/append:

- ISO local date/time with UTC offset, timezone and wall epoch from the host clock.
- Authoritative network simulation elapsed time (initial startup receipt uses simulation zero before the operations owner exists).
- Contact movement-derived progression time when actually available.
- Stable report-event sequence ID for receipt deduplication/replay episodes.
- Observation wall time only if supplied; otherwise **Timestamp unavailable**.

Receipt time is not labeled original authorship time. Historical static encounter/cyber briefs explicitly lack historical issue timestamps. Earlier untimestamped records retain authentic simulation metadata if available; missing values are displayed as unavailable. Old reports are not rewritten. Superseded ID/time and newer ID/time are shown separately.

A focused test deliberately copied an older report while simulation was strategically paused. It caught inherited receipt metadata; capture now overwrites receipt metadata with the current real instant for a newly received report. Observation metadata remains separate. The final test verifies that wall epoch advances while authoritative simulation time stays fixed. Existing autonomous release remains paused; explicit authored follow-up behavior remains accepted. Challenge continues across pages; no UI timer or catch-up clock was added.

Received reports emit from their session owner. The page subscribes and imports already-captured startup records, deduplicating by contact/report-event ID. Recommendations are timestamped once when issued from public authored configuration, including contacts without source reports. Page navigation emits no received-intelligence or recommendation events. Replay source episodes receive distinct sequence IDs without duplicating the official score.

## Actual testing and results

Godot `4.7.2.stable.mono.official.ed1daf0bf`, rendered Vulkan Forward+ on NVIDIA RTX 2070. Tests use an actual 1600 ? 900 SubViewport and viewport mouse input. No separate native desktop manual playthrough is claimed.

Commands from repository root:

```powershell
python tests/cyber_catalog_test.py
$godotExe = 'C:/Users/azwam/Projects/Godot_4.7/Godot_v4.7.2-stable_mono_win64/Godot_v4.7.2-stable_mono_win64_console.exe'
# Executed separately for N = 3,4,5,6,7,8,9:
& $godotExe --path . --script res://tests/prototypeN_test.gd
& $godotExe --path . --script res://tests/prototype9_corrections_test.gd
& $godotExe --path . --script res://tests/prototype9_cyber_test.gd
& $godotExe --path . --script res://tests/prototype9_decision_test.gd
& $godotExe --headless --path . --editor --import --quit
& $godotExe --path . --quit-after 120
& $godotExe --path . res://scene/game.tscn --quit-after 120
git diff --check
```

| Suite/check | Actual result |
| --- | --- |
| Read-only v12 catalog verification | PASS; reproducible export and unchanged source hash |
| Prototype 3 | PASS, 0 failures, exit 0 |
| Prototype 4 | PASS, 13,040 checks, exit 0 (frame-dependent count) |
| Prototype 5 | PASS, 992 checks, exit 0 |
| Prototype 6 | PASS, 229 checks, exit 0 |
| Prototype 7 | PASS, 241 checks, exit 0 |
| Prototype 8 | PASS, 1,748 checks, exit 0; repeated after timestamp presentation additions |
| Prototype 9 | PASS, 311 checks, exit 0 |
| Acceptance corrections | PASS, 266 checks, exit 0; repeated after presentation additions |
| Cybersecurity integration | PASS, 361 checks, exit 0; repeated after presentation additions |
| New decision-interface suite | PASS, 233 checks, exit 0 |
| Editor import | Exit 0, no script errors |
| Rendered main startup | Exit 0, no script errors |
| Rendered standalone tactical startup | Exit 0, no script errors |
| git diff --check | PASS |

New coverage includes all four pages and all eighteen stable IDs, actual header sorting and row navigation, nonexclusive hypotheses, physical evidence display, validated references, all fifteen existing responses reachable, informational versus executable confirmation, coordinated/unsupported physical proposals, existing cyber resolution with unchanged official score, report receipt timestamps, supersession, historical missing-time handling, wall time during Learning pause, Challenge progression, both history filters, navigation/event idempotency, scorecard visibility and original exact-deadline rejection feedback.

During development, new-script type annotations and a test assumption that the first database defense necessarily contains a threat were corrected. The test now selects the explicit existing containment defense ID; no effectiveness rule was changed. A popup implementation was changed to an in-viewport overlay after SubViewport native-window focus warnings. Final rendered run passes without those warnings. Legacy assertions remain unchanged.

External regression logs: `%TEMP%/odc_decision_verification/`. Existing negative-fixture diagnostics remain expected; no passing claim is based solely on headless execution.

## Screenshots and visual findings

All screenshots are outside the repository:

`C:/Users/azwam/AppData/Roaming/Godot/app_userdata/planetary-attacker-defender/`

- `prototype4_p9_decision_overview.png`
- `prototype4_p9_decision_multithreat.png` ? Page 2 and a simultaneous physical/cyber suspicion example.
- `prototype4_p9_decision_intelligence.png`
- `prototype4_p9_decision_history.png`

All four page captures were opened and inspected. At 1600 ? 900, fixed decisions remain visible, the long navigation label was shortened, severity width was increased and report/defense regions scroll individually without nested scroll containers. Physical suspicion and three cyber hypotheses are simultaneously readable; their controls do not imply confirmed payloads. The source-report and history captures visibly show local date-time offsets, simulation time and supersession references. Complete long evidence remains scroll-accessible, not deleted. The mission scorecard was opened/closed by actual mouse input without losing the selected decision page.

## Known limitations and owner decisions

- New multi-threat estimates/recommendations are authored public demonstrations, not statistical inference or private multi-payload simulation. Owner review of numbers, supporting evidence and wording is required before accepting them as design fixtures.
- These public hypothesis summaries do not automatically rewrite themselves from later source reports; the detailed analysis/history remains authoritative about changing public evidence. A future evidence-reconciliation policy requires approval.
- Recommendations are advisory and recorded once; they do not automatically authorize or reprioritize defenses.
- Only the existing five cyber evaluators and earlier abstract/original responses execute. Coordinated defense and unsupported physical actions remain proposals. No new hidden weapon/payload or effect was introduced.
- Some countermeasures need scrolling in the defense list; fixed command/navigation controls remain outside that scroll. Legacy operational escalation/hold-fire/replay remains a subview rather than being duplicated into every page.
- Observation and historical authorship times are unavailable where never recorded. Current receipt time cannot reconstruct those facts. Wall clock depends on host configuration.
- History remains in-session; no persistent save/reload/archive is added.
- Accepted Learning pause policy is preserved: original active progression and analyst clocks pause; background spacecraft movement may continue. A decision/report page itself does not implicitly pause Challenge.
- Earlier native tactical/command scenes remain usable and intentionally retain their legacy presentations for compatibility; F5 uses the new four-page entry.

Proposed next increment, requiring separate approval: review authored multi-threat briefs and decide how later contradictory intelligence should update concise hypotheses and recommendations. No Prototype 10 or new simulation evaluator is implemented.

## Git working-tree status

All work remains local and unstaged; no checkpoint/publication/history rewrite occurred. Status at report creation, with this report itself added as a new untracked file:

```text
 M Reports/Orbital_Defense_Command_Game_Concept.md
 M Reports/Prototype_8_Git_Checkpoint_Report_2026-10-24_154943_01.md
 M project.godot
 M script/attack_info_panel.gd
 M script/command_center.gd
 M script/game.gd
 M script/intelligence_session.gd
?? Reports/Prototype_9_Acceptance_Corrections_2026-10-24_173651_01.md
?? Reports/Prototype_9_Completion_Report_2026-10-24_163400_01.md
?? Reports/Prototype_9_Cybersecurity_Integration_Report_2026-10-24_181746_01.md
?? data/contact_operations.json
?? data/cyber_catalog.json
?? data/cyber_scenarios.json
?? data/decision_assessments.json
?? scene/cyber_command.tscn
?? scene/decision_command.tscn
?? scene/operational_command.tscn
?? script/action_feedback.gd
?? script/action_feedback.gd.uid
?? script/command_confirmation.gd
?? script/command_confirmation.gd.uid
?? script/contact_operations.gd
?? script/contact_operations.gd.uid
?? script/contact_table_sort.gd
?? script/contact_table_sort.gd.uid
?? script/cyber_command.gd
?? script/cyber_command.gd.uid
?? script/cyber_data.gd
?? script/cyber_data.gd.uid
?? script/cyber_session.gd
?? script/cyber_session.gd.uid
?? script/decision_assessment.gd
?? script/decision_assessment.gd.uid
?? script/decision_pages.gd
?? script/decision_pages.gd.uid
?? script/event_stamp.gd
?? script/event_stamp.gd.uid
?? script/operations_data_loader.gd
?? script/operations_data_loader.gd.uid
?? script/operations_session.gd
?? script/operations_session.gd.uid
?? script/operations_ui.gd
?? script/operations_ui.gd.uid
?? script/report_presentation.gd
?? script/report_presentation.gd.uid
?? tests/cyber_catalog_test.py
?? tests/prototype9_corrections_test.gd
?? tests/prototype9_corrections_test.gd.uid
?? tests/prototype9_cyber_test.gd
?? tests/prototype9_cyber_test.gd.uid
?? tests/prototype9_decision_test.gd
?? tests/prototype9_decision_test.gd.uid
?? tests/prototype9_test.gd
?? tests/prototype9_test.gd.uid
?? tools/
?? Reports/Prototype_9_Decision_Interface_Refinement_2026-10-24_193541_01.md
```
