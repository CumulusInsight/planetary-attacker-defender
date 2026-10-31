# Prototype 14 Wrap-Up — Phase A inspection and proposed integration

Date: 2026-10-29
Status: PLAN ONLY — Phase B requires owner approval.

## Inspected baseline

- Branch: `feature/prototype13-datacenter-defense`.
- HEAD: `c6646b008657f98b500e019a71b6521f58a76509`.
- Existing uncommitted P13/P14 source, scenes, reports and direct launcher remain intact. No staged files. `project.godot` already selects `res://scene/prototype13_command.tscn`.
- `new_projectV2/` and `tools/__pycache__/` are unrelated generated artifacts; preserve them without incorporating them into this implementation.
- P14 implementation files match their previous delivery manifest. No gameplay changes were made during Phase A. Previous P14 delivery evidence records 51 passing verification jobs; these are historical results, not a fresh wrap-up verification run.
- The existing `Launch_Prototype_14.bat` launches the standalone scene. No general Orbital Defense Command launcher currently exists.

## Actual system boundaries

P12/P13 use the persistent learning-session internal-threat registry. `internal_for_center(center_id)` supplies the DC-01 Security Console with first-arrival records keyed by physical identity. Incorrect combat answers produce UNOPPOSED_ARRIVAL; authoritative evasion produces EVADED_INTERCEPTION; HIT does not create an arrival. The console is read-only.

P14 uses its own `command_session.gd`, local simulation clock, simulated vendor-account evidence, local performance metrics and journal. It does not use the live P12 registry. Its infrastructure commissioning, credential retirement, session revocation, route restoration and recovery verification are real actions within that isolated demonstration. Its fourteen competitor profiles are simulated.

Merely hiding P13 while entering P14 is unsafe: its operational clock, deadlines and launch queue may continue. Freezing it instead would introduce a new pause policy. Neither should be introduced implicitly.

## Recommended minimal integration

Add a small native Command Desk entry scene offering **The First Watch — DC-01 command exercise** and **Orbital Command — existing six-center game and Security Console**. Do not run the live P13 scene behind P14.

Flow:

1. The new general Windows launcher opens Command Desk.
2. First Watch opens the existing P14 experience through the entry host.
3. Return to Command Desk preserves the local P14 instance and pauses only its isolated exercise clock while it is outside play; Resume First Watch restores it. This does not change P12 timing.
4. Entering Orbital Command starts the existing P13 scene normally. Explain that this opens the separate live scenario; it does not import the watch's simulated incident. If an unfinished watch would be discarded when leaving the host, require an explicit concise confirmation.
5. Do not add a P13-to-P14 hot-switch in this pass. Once Orbital Command is running, changing experiences requires returning through a new application launch. An in-session round trip needs separately approved clock/session lifecycle rules.

Propose making Command Desk the default scene only as part of approved Phase B, after verification. Retain the direct P14 launcher and all original scenes. No incident conversion, registry mutation or simulated evidence inserted into P13.

## Checklist and operational feedback

Add a compact collapsible Watch Officer's Checklist, with navigation links to existing tasks rather than editable completion boxes. A pure state projection supplies Pending, In Progress, Verified, and Blocked plus a short reason. Use one shared handover-requirements helper for the checklist and report-filing availability.

- Briefing: watch accepted.
- Crew responsibilities: all three crew introductions reviewed. Follow-up conversation/private crew briefing remains optional leadership activity.
- Readiness: core inspected and existing power/cooling check completed, not merely clicked.
- Infrastructure: commissioning actually finished; selecting an upgrade is insufficient.
- Investigation: relevant evidence reviewed; distinguish upgrade-provided detection from investigation. Record a small P14-only evidence-review flag where needed.
- Corrective actions: credential retirement completed; revoke an established unauthorized session separately when applicable. Isolation is a temporary option, not automatically mandatory.
- Recovery: route restored and existing verification job completed after required corrections.
- Handover: report actually filed. Filing itself is excluded from pre-filing readiness to avoid a circular prerequisite.

**Proposed narrow P14 rule adjustment for approval:** the current handover guard does not require the optional health check or an explicit evidence-review flag. Make those actual procedure completions required for handover, with clear reasons. Keep existing durations, score deltas and operational outcomes unchanged. Other optional activities stay optional. No artificial requirement to perform every action or follow one fixed order.

Keep the station visible; expand the checklist in the existing contextual area rather than adding a large permanent dashboard. Explain unavailable commands inline. Credential rotation must never stand in for session revocation. Keep the full catalog attack name, Lumen uncertainty and post-watch-only adversary debrief.

## Personnel

Use structured rank/name/duty fields and a shared display formatter throughout P14:

- Chief Petty Officer Mara Voss — Operations.
- Lieutenant Junior Grade Imani Rao — Security.
- Ensign Eli Chen — Junior Watch Officer.

These ranks do not conflict with the current characterization. The player Lieutenant retains command; Mara's technical commissioning responsibility is delegated authority. Wrap/reflow crew cards for readable full names and ranks. Update P14 speaker labels, task messages, journal entries and handover text consistently. Do not globally rename historical prototypes or canonical content.

## Proposed exact file scope

Modify:

- `project.godot` — approved Command Desk startup path only.
- `data/p14/first_watch.json` — ranks/duties and consistent personnel references, preserving story and attack ID.
- `script/p14/command_session.gd` — checklist state/requirements, evidence-review tracking, rank-aware event labels and blocked reasons.
- `script/p14/command_experience.gd` — collapsible checklist, readable personnel cards, feedback and return navigation.
- `tests/prototype14_command_session_test.gd` — state/prerequisite coverage.
- `tests/prototype14_command_ui_test.gd` — checklist/personnel/complete-watch UI coverage.

Add:

- `scene/odc_entry.tscn`.
- `script/odc_entry.gd` and Godot UID sidecar.
- `script/p14/watch_checklist.gd` and UID sidecar.
- `tests/prototype14_wrapup_test.gd` and UID sidecar.
- `Launch_Orbital_Defense_Command.bat`.
- Timestamped completion report under `Reports/`.

Retain `Launch_Prototype_14.bat` unchanged unless testing identifies a launcher-specific necessity. No planned edits to P12/P13 scripts/scenes, catalog/editorial files, question banks or collaborator artwork.

## Phase B preservation and verification

Before source edits, create a NEW external timestamped ZIP containing all intended current project files, including untracked P13/P14 work. Verify CRC, source/archive individual SHA-256 hashes, count and archive SHA-256. Keep earlier backups; exclude reproducible caches, Git metadata and unrelated generated executables.

Then test checklist projection and unfulfilled prerequisites; both upgrade branches; delayed unauthorized-session revocation; complete report filing; ranks throughout UI; entry/resume/exit without unintended session effects; P12/P13 registry and console behavior; existing relevant regression suites. Actually launch the new batch file from a different working folder. Render and inspect 1600x900, 1280x720 and 1920x1080. Report historical versus newly run checks distinctly.

## Limitations and approval decisions

- This is entry-point integration, not shared incident/campaign state. P14 exercise results will not alter P12 scoring or P13 incidents.
- A live P12/P13 session will not support an in-place First Watch detour in this pass.
- Approval includes the Command Desk startup proposal, isolated P14 pause/resume outside play, and the explicit readiness/evidence handover requirements above.
- No commits, tags, pushes, merges or cleanup are proposed.

Phase A stops here. No Phase B implementation has begun.
