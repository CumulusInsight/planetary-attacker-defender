# Canonical v12 learning retrofit — editorial candidate

This directory contains individually authored review candidates for **100 attacks,
185 defenses and 211 original mapping pairs**. No entry is owner-approved, and
no production release is authorized. The local full-mode scene is explicitly an
editorial review build, not a claim of production content acceptance.

## Source identity

`C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db` is authoritative.
`cyber_100_attacks_learning_draft.db` supplies editorial provenance and the eight
password benchmarks. Their numeric ID namespaces differ. The PSV authoring
columns explicitly name **draft IDs**; the exporter reconciles exact attack names
and the owner's six explicit defense aliases, then emits only canonical v12 IDs
for runtime identity. Draft IDs remain separately named provenance fields.

Neither SQLite input nor `data/cyber_catalog.json` is changed. The original
fixtures also remain untouched. No MySQL server or runtime SQLite dependency is
introduced.

## Reproduce and validate

From the project directory:

```powershell
python tools/export_learning_retrofit.py --source C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db --draft cyber_100_attacks_learning_draft.db
python tests/learning_retrofit_test.py
```

The default outputs are `data/learning_retrofit.json` and
`Reports/Learning_Retrofit_Before_After.json`. Exports contain no timestamps or
random editorial text, so identical inputs produce identical bytes. Session
selection and option-position shuffling are separately seeded in Godot.

## Question construction and grading

Each attack has a distinct contextual countermeasure question, four curated
catalog options and one designated mapped defense. **Every other defense mapped
to that attack is excluded from the distractors**, even if its relationship is
weak or marked REMOVE_PROPOSED. Unmapped does not automatically mean technically
wrong: the authored scenario and contrast explanation constrain the requested
mechanism. A question is a bounded teaching exercise, not a claim that only one
control could ever help in the real world.

Attack definitions and examples distinguish mechanisms from categories,
weaknesses, environmental events and legitimate security research. The original
database's difficulty, severity, identifiers and relationships are not rewritten.
The eight password benchmarks are retained in the before/after evidence; their
new countermeasure questions use the same conceptual distinctions in the full
defense-selection workflow.

## Mapping review meanings

- RETAIN: an appropriate stated relationship; limitations still apply.
- QUALIFY: useful only within the recorded scope or as a supporting layer.
- CORRECT: the existing label needs a specific interpretation or corrected
  explanation. This is a proposed editorial correction, **not a changed edge**.
- REMOVE_PROPOSED: do not teach this edge as effective protection without owner
  reconsideration. The authoritative edge remains present and excluded from
  incorrect choices.

Control roles are DIRECT, PARTIAL, DETECTION and INDIRECT_SUPPORT. A direct
control is direct for its stated mechanism, not guaranteed success. Detection is
not prevention; backups are recovery, not ransomware prevention. All proposals,
including changed wording, require owner review. There are no empty fields or
generic source-preserving defense placeholders in the candidate export.

## Acceptance and release boundary

All 496 entries carry `EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED` and the bundle
has `owner_accepted: false` and `production_eligible: false`. The Python production
validator and Godot production-mode loader reject this bundle. Owner acceptance
must be an explicit subsequent action; tests passing never promote content.
This editorial pass is not an independent external SME certification or an exam
coverage claim. See `REFERENCES.md` for targeted technical cross-checks and the
quality report for itemized exceptions.

Full question, definition, example, selected-control mechanism, conditions and
limitations are readable in a scrollable panel. Answer reasoning becomes visible
after authoritative submission/evaluation; selection alone never changes grades
or fires. The original submission, WAIT, deadline, scoring and evasion models
remain the command authority.
