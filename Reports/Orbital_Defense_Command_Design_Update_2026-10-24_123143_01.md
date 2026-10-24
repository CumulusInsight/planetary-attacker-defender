# Orbital Defense Command - Master Design Requirements Update

Created: 2026-10-24T12:31:43-07:00 - America/Los_Angeles, Pacific Daylight Time (UTC-07:00).

Status: documentation complete, ready for owner review. No new gameplay or Prototype 6 work authorized or implemented.

Full report path: `C:\Users\azwam\Projects\planetary-attacker-defender\Reports\Orbital_Defense_Command_Design_Update_2026-10-24_123143_01.md`

## Files changed

1. `Reports/Orbital_Defense_Command_Game_Concept.md` - updated master design in place.
2. `Reports/Orbital_Defense_Command_Design_Update_2026-10-24_123143_01.md` - this new uniquely timestamped change report, created exclusively without overwriting an existing report.

The existing uncommitted Prototype 5 working tree is preserved. No scripts, scenes, tests, attack/scenario data, assets, project settings, earlier completion reports, or tags were changed. No commit, merge, tag, push or executable rebuild was performed.

## Sources reviewed

- `Orbital_Defense_Command_Game_Concept.md` and `README.md`.
- Original `Prototype_5_Completion_Report.md`.
- All three timestamped Prototype 5 reports: `2026-10-24_111602_01`, `2026-10-24_115626_01`, and `2026-10-24_121306_01`.

The report sequence documents progression from an untimed encounter through static demonstration indicators and an initial short deadline to the reviewed five-minute/explicit-reading-state implementation. Older reports remain historical; they were not rewritten to match later behavior.

## Sections added or revised

| Master section | Change |
| --- | --- |
| Status and Section 3 | Distinguishes implemented features, approved long-term design requirements, and future proposals; records reviewed Prototype 5 versus accepted Prototype 4 Git checkpoint; links all four reports. |
| Sections 4, 6, 7 and 10 | Reconciles stale future-only Prototype 5 descriptions with implemented assessed-contact console, deterministic fixtures/decisions, one-follow-up rule and timing. Keeps original encounter/probability examples and B-F roadmap. |
| Sections 11-13 | Preserves architectural boundaries; updates open decisions/planning-document recommendations to recognize reviewed Prototype 5 without editing those other documents. |
| New Section 14 | Strategic overview/tactical focus, scalable centralized contact registry, separate evolving assessments, applicable deadlines, triage, severity versus urgency, and resource-allocation requirements. |
| New Section 15 | Five intelligence production functions, personnel/report visibility, and four distinct timing concepts. |
| New Section 16 | Dedicated Educational Learning Architecture: four potential providers, reusable registry/adapter boundaries, targeted sessions, conceptual IDs, persistence/failure/offline requirements and content/certification review. |
| New Section 17 | Accurate current Learning/Active Challenge behavior versus future provider-session pause/return policies. |
| New Section 18 | Five proposed phased requirements/proof-of-concept gates and additional open design questions. |

## New approved design requirements, not implemented features

- Ultimately support a network of centers and a data-driven number of contacts. Fifteen centers with about three contacts each (roughly 45 total) is illustrative, not a hardcoded count or a presumption of hostile intent.
- Centralize observed-contact records, separate versioned assessments/evidence, and applicable individual deadlines. Sort triage by deadline, assessed severity, confidence and reviewed priorities without conflating urgency, severity or hostility.
- Separate collection, signal identification/decoding/interpretation, analysis, standardized report production/dissemination, and command decisions. Make assignments, available personnel, workload and report state visible. Distinguish collection windows, report deadlines, command deadlines and analysis estimates.
- Make optional learning modular and reusable across games/subjects. Recognize Smart Stack, Max IQ Ace, Smart Space and Space Gurus, while requiring inspection of each project's actual interfaces, storage/content structures and capabilities before an adapter contract.
- Use many-to-many concept mappings with stable IDs and versioned provider/content references. Example `ODC-DEC-014` to `CYBER-C2-001` is illustrative, not a claim that matching provider content exists.
- Offer around five targeted questions/exercises outside normal command gameplay, then safely restore/reconcile the original decision context. No conventional multiple-choice requirement in normal gameplay, no hardcoded question sets, and no hidden encounter answers in learning links/payloads.
- Prefer a database-backed registry direction without selecting or implementing a database technology. Define state persistence, optional practice/mastery history, content updates, missing/unavailable-provider handling and local/offline feasibility.
- Begin with cybersecurity; allow later intelligence analysis, PMP-related/project management, risk, communications/decision-making and other academic/certification tracks. Verify versioned published exam objectives before any certification-coverage claim.

## Existing requirements and status preserved

The science-fiction Mars/human-expansion story, Martian planetary-defense perspective, mixed harmless/neutral/unknown traffic and Star Fink working name remain. The six-layer separation of hidden identity/intent, officer assessment, SIGINT observation/interpretation, capability estimate, decision and actual outcome remains mandatory. A peaceful contact stays peaceful even when an officer expresses 100% hostile confidence. Identification probability remains distinct from defense-effectiveness probability; the conditional one-in-three example remains intact.

Godot 2D/2.5D remains the initial strategy; true 3D is optional later. Existing artwork handoff and limited-connectivity guidance, accepted prototype history, core architecture and future multi-center roadmap remain.

Current reviewed Prototype 5 is described accurately: one active C-001 encounter plus two background contacts; configurable five-minute movement-derived window; prominent countdown/progress; explicit Read reports (pause) in Learning Mode; Active Challenge Mode; independent hover-freeze/selection; authored intelligence/SIGINT/follow-up and deterministic decisions/expiration/replay; static demo staffing/workload/ETA. No strategic triage, scalable threat registry, real staffing, external learning integration, database mapping or certification tracking is claimed to exist.

## Phases proposed, without implementation authorization

1. Design multi-contact registry and triage with mixed traffic and scale/navigation tests.
2. Specify staffing/reporting, four time concepts and pause scope before scheduler code.
3. Inspect all four providers and specify registry/adapters/continuation contracts.
4. After approval, prove one decision-to-concept-to-provider session of about five items and safe return, including cancellation/failure paths.
5. Expand providers, subjects and reviewed certification mappings incrementally.

These are not automatically numbered as Prototype 6 or authorization to begin a new prototype.

## Open questions

Registry lifecycle/cross-center association, severity/triage policies, staff skills/capacity/reassignment, report templates and deadline consequences need detailed approval. For learning, choose whether a session pauses one contact, one tactical center or all strategic simulation; pausing one must not silently pause 44 others. Also resolve mode-specific assistance restrictions, continued-simulation return reconciliation, provider capability/rights differences, ID/difficulty/version governance, persistence/database topology, practice-history privacy/retention, optional mastery model and authoritative certification-review process. No database or provider interface was chosen here.

## Consistency and preservation checks

- Programmatic required-term/identifier checks passed for illustrative scale, four provider names, all conceptual mapping fields, sample IDs, short-session size, current timing, uncertainty/probability and 2D/2.5D guidance.
- All relative Markdown document links resolve; 18 numbered top-level sections present; no stale 'no implementation has begun' or 'Proposed Prototype 5' current-state claim remains.
- Whitespace checks passed for the master document. `git diff --check` covers existing tracked changes; the updated master and this report are untracked, so their content/preservation checks were performed directly.
- SHA-256 snapshot comparison verifies only the master document changed among pre-existing workspace files; the new file is this report. Earlier completion reports, gameplay files and unrelated work remain byte-for-byte unchanged.
- Godot/regression suites were not rerun for this documentation-only task. Section 3 cites the latest report's prior passing results explicitly as historical, not new test evidence. No gameplay or native GUI test is claimed.

Stop for owner review before any implementation or checkpoint action.
