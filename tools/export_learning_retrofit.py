"""Deterministic additive editorial export. SQLite inputs are opened read-only.

Nothing here writes either database, the accepted catalog, or original mappings.
The source PSV files deliberately use a named draft-ID column for authoring;
exported runtime records use canonical v12 IDs and retain draft IDs as provenance.
"""
import argparse
import hashlib
import json
import sqlite3
from collections import Counter
from pathlib import Path

from export_cyber_catalog import export as export_catalog

STATUS = "EDITORIAL_CANDIDATE_OWNER_REVIEW_REQUIRED"
ALIASES = {
    "Exec Training": "Executive Training", "Web Filter": "Web Filtering",
    "Firewall": "Firewalls", "Allow Listing": "Allowlisting",
    "Sink Holing": "Sinkholing", "Disable NT LAN Manager": "Disable NTLM",
}


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rows(path, width):
    result = []
    for number, line in enumerate(Path(path).read_text(encoding="utf-8").splitlines(), 1):
        if not line or line.startswith("#"):
            continue
        fields = line.split("|")
        if len(fields) != width or any(not x.strip() for x in fields):
            raise ValueError(f"{path}:{number}: expected {width} nonempty fields")
        result.append(fields)
    return result


def read_draft(path):
    path = Path(path).resolve()
    with sqlite3.connect(path.as_uri() + "?mode=ro", uri=True) as db:
        db.row_factory = sqlite3.Row
        if db.execute("pragma integrity_check").fetchone()[0] != "ok":
            raise ValueError("Editorial SQLite integrity failure")
        return {t: [dict(r) for r in db.execute(f"select * from {t} order by 1")]
                for t in ["attacks", "defenses", "attack_defenses", "learning_attacks",
                          "learning_defenses", "learning_mapping_reviews", "learning_release_notes"]}


def reconcile(draft, canonical):
    maps, provenance = {}, {}
    for table, field in [("attacks", "attack_name"), ("defenses", "defense_name")]:
        lookup = {r[field]: r["ID"] for r in canonical[table]}
        if len(lookup) != len(canonical[table]):
            raise ValueError("Ambiguous canonical names")
        mapping, evidence = {}, []
        for r in draft[table]:
            name = ALIASES.get(r[field], r[field]) if table == "defenses" else r[field]
            if name not in lookup:
                raise ValueError(f"Unresolved {table} name: {r[field]}")
            mapping[r["ID"]] = lookup[name]
            evidence.append({"draft_id": r["ID"], "canonical_id": lookup[name],
                             "draft_name": r[field], "canonical_name": name,
                             "basis": "owner-authorized alias" if name != r[field] else "exact name"})
        if len(mapping) != len(canonical[table]) or len(set(mapping.values())) != len(mapping):
            raise ValueError("Non-bijective ID reconciliation")
        maps[table], provenance[table] = mapping, evidence
    original = {(r["attack_id"], r["defense_id"]): r["ID"] for r in canonical["attack_defenses"]}
    pairs = {(maps["attacks"][r["attack_id"]], maps["defenses"][r["defense_id"]])
             for r in draft["attack_defenses"]}
    if len(original) != 211 or pairs != set(original):
        raise ValueError("Original 211 pair correspondences do not match after reconciliation")
    provenance["mappings"] = [
        {"draft_mapping_id": r["ID"], "canonical_mapping_id": original[
            maps["attacks"][r["attack_id"]], maps["defenses"][r["defense_id"]]]}
        for r in draft["attack_defenses"]]
    return maps, provenance, original


def validate(bundle, production=False):
    attacks, defenses, reviews = bundle["attacks"], bundle["defenses"], bundle["mapping_reviews"]
    if [len(attacks), len(defenses), len(reviews)] != [100, 185, 211]:
        raise ValueError("Expected 100 attacks, 185 defenses and 211 mapping reviews")
    ai = {r["attack_id"] for r in attacks}
    di = {r["defense_id"] for r in defenses}
    if len(ai) != 100 or len(di) != 185:
        raise ValueError("Duplicate canonical ID")
    for table, field, provenance_field in [(attacks, "attack_id", "draft_attack_id"), (defenses, "defense_id", "draft_defense_id")]:
        evidence = bundle["reconciliation"]["attacks" if field == "attack_id" else "defenses"]
        crosswalk = {r["draft_id"]: r["canonical_id"] for r in evidence}
        if len(crosswalk) != len(table) or len(set(crosswalk.values())) != len(table):
            raise ValueError("Ambiguous provenance crosswalk")
        if any(crosswalk.get(r[provenance_field]) != r[field] for r in table):
            raise ValueError("Wrong-ID numeric join instead of name reconciliation")
    pairs = {(r["attack_id"], r["defense_id"]) for r in reviews}
    if len(pairs) != 211 or any(a not in ai or d not in di for a, d in pairs):
        raise ValueError("Invalid mapping reference or duplicate")
    for r in attacks:
        for field in ["display_name", "kind", "definition", "question", "explanation", "example", "distractor_reasoning"]:
            if not isinstance(r.get(field), str) or not r[field].strip():
                raise ValueError("Missing attack field: " + field)
        choices, correct = r["option_defense_ids"], r["correct_defense_id"]
        if len(choices) != 4 or len(set(choices)) != 4 or correct not in choices:
            raise ValueError("Question must have four distinct choices and one designated answer")
        if any(d not in di for d in choices) or (r["attack_id"], correct) not in pairs:
            raise ValueError("Invalid answer reference")
        if any((r["attack_id"], d) in pairs for d in choices if d != correct):
            raise ValueError("A mapped defense cannot be an incorrect distractor")
        if next(m for m in reviews if (m["attack_id"], m["defense_id"]) == (r["attack_id"], correct))["decision"] == "REMOVE_PROPOSED":
            raise ValueError("A proposed removed mapping cannot be a designated learning answer")
    for r in defenses:
        for field in ["display_name", "definition", "mechanism", "conditions", "limitations", "example"]:
            if not isinstance(r.get(field), str) or not r[field].strip():
                raise ValueError("Missing defense field: " + field)
    for r in reviews:
        if r["decision"] not in ["RETAIN", "QUALIFY", "CORRECT", "REMOVE_PROPOSED"]:
            raise ValueError("Invalid mapping review decision")
        if r["role"] not in ["DIRECT", "PARTIAL", "DETECTION", "INDIRECT_SUPPORT"]:
            raise ValueError("Invalid control role")
        if not r["applicability"] or not r["limitations"]:
            raise ValueError("Missing mapping rationale")
    serialized = json.dumps([attacks, defenses, reviews]).lower()
    for marker in ["which cybersecurity threat or technique best matches this scenario", "source_based_expansion_pending", "\ufffd", "placeholder", "todo"]:
        if marker in serialized:
            raise ValueError("Unresolved editorial marker: " + marker)
    if production and (not bundle.get("owner_accepted") or any(r["status"] != "OWNER_ACCEPTED" for r in attacks + defenses + reviews)):
        raise ValueError("Production release blocked: owner acceptance is absent")


def build(source, draft_path, editorial):
    source, draft_path, editorial = Path(source), Path(draft_path), Path(editorial)
    original_hashes = [digest(source), digest(draft_path)]
    canonical, draft = export_catalog(source), read_draft(draft_path)
    maps, provenance, pairs = reconcile(draft, canonical)
    attack_rows, defense_rows, review_rows = rows(editorial / "attacks.psv", 10), rows(editorial / "defenses.psv", 7), rows(editorial / "mappings.psv", 6)
    if len({int(r[0]) for r in attack_rows}) != 100 or len({int(r[0]) for r in defense_rows}) != 185:
        raise ValueError("Editorial source count/identity failure")
    attacks, defenses, reviews = [], [], []
    for r in attack_rows:
        old = int(r[0]); choices = [int(r[5])] + [int(v) for v in r[6].split(",")]
        attacks.append(dict(attack_id=maps["attacks"][old], draft_attack_id=old,
                            display_name=r[1], kind=r[2], definition=r[3], question=r[4],
                            correct_defense_id=maps["defenses"][int(r[5])],
                            option_defense_ids=[maps["defenses"][d] for d in choices],
                            explanation=r[7], example=r[8], distractor_reasoning=r[9], status=STATUS))
    for r in defense_rows:
        old = int(r[0])
        defenses.append(dict(defense_id=maps["defenses"][old], draft_defense_id=old,
                             display_name=r[1], definition=r[2], mechanism=r[3],
                             conditions=r[4], limitations=r[5], example=r[6], status=STATUS))
    for r in review_rows:
        a, d = maps["attacks"][int(r[0])], maps["defenses"][int(r[1])]
        if (a, d) not in pairs:
            raise ValueError("Editorial mapping not present in authoritative database")
        reviews.append(dict(mapping_id=pairs[a, d], attack_id=a, defense_id=d,
                            draft_attack_id=int(r[0]), draft_defense_id=int(r[1]),
                            decision=r[2], role=r[3], applicability=r[4], limitations=r[5],
                            status=STATUS, applied_to_authoritative_mapping=False))
    result = dict(schema_version=1, owner_accepted=False, production_eligible=False,
                  content_status=STATUS, canonical_source_sha256=original_hashes[0],
                  editorial_draft_sha256=original_hashes[1],
                  editorial_source_sha256={p.name: digest(p) for p in sorted(editorial.glob("*.psv"))},
                  reconciliation=provenance,
                  attacks=sorted(attacks, key=lambda r: r["attack_id"]),
                  defenses=sorted(defenses, key=lambda r: r["defense_id"]),
                  mapping_reviews=sorted(reviews, key=lambda r: r["mapping_id"]))
    validate(result)
    if original_hashes != [digest(source), digest(draft_path)]:
        raise ValueError("An input database changed during read-only export")
    return result, draft


def changes(bundle, draft):
    old_a = {r["attack_id"]: r for r in draft["learning_attacks"]}
    old_d = {r["defense_id"]: r for r in draft["learning_defenses"]}
    old_m = {(r["attack_id"], r["defense_id"]): r for r in draft["learning_mapping_reviews"]}
    return dict(schema_version=1, approved=False,
                attacks=[dict(canonical_id=r["attack_id"], before=old_a[r["draft_attack_id"]], after=r) for r in bundle["attacks"]],
                defenses=[dict(canonical_id=r["defense_id"], before=old_d[r["draft_defense_id"]], after=r) for r in bundle["defenses"]],
                mappings=[dict(canonical_id=r["mapping_id"], before=old_m[r["draft_attack_id"], r["draft_defense_id"]], after=r) for r in bundle["mapping_reviews"]])


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True)
    parser.add_argument("--draft", required=True)
    parser.add_argument("--editorial", default="editorial")
    parser.add_argument("--output", default="data/learning_retrofit.json")
    parser.add_argument("--changes", default="Reports/Learning_Retrofit_Before_After.json")
    args = parser.parse_args()
    bundle, draft = build(args.source, args.draft, args.editorial)
    for name, data in [(args.output, bundle), (args.changes, changes(bundle, draft))]:
        Path(name).write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("Validated candidate export: 100 attacks, 185 defenses, 211 individually reviewed original pairs.")
    print("Owner approval absent; production release blocked. Decisions:", dict(Counter(r["decision"] for r in bundle["mapping_reviews"])))
