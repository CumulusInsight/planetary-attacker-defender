"""Read-only editorial/ID/reproducibility checks; never changes source databases."""
import copy
import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
from export_learning_retrofit import build, validate, reconcile, STATUS, ALIASES

SOURCE = Path("C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db")
DRAFT = ROOT / "cyber_100_attacks_learning_draft.db"
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
checks = 0


def check(condition, message):
    global checks
    checks += 1
    if not condition:
        raise AssertionError(message)


def rejected(bundle, message, production=False):
    try:
        validate(bundle, production=production)
    except (ValueError, KeyError, StopIteration):
        check(True, message)
    else:
        raise AssertionError(message)


before = {str(p): sha(p) for p in [SOURCE, DRAFT, ROOT / "data/cyber_catalog.json"]}
bundle, original = build(SOURCE, DRAFT, ROOT / "editorial")
expected = json.dumps(bundle, indent=2, ensure_ascii=False) + "\n"
check(expected == (ROOT / "data/learning_retrofit.json").read_text(encoding="utf-8"), "Exact reproducible export")
check(bundle == build(SOURCE, DRAFT, ROOT / "editorial")[0], "Repeat build deterministic")
check(len(ALIASES) == 6, "Exactly six owner-authorized aliases")
check([len(bundle[t]) for t in ["attacks", "defenses", "mapping_reviews"]] == [100, 185, 211], "Complete counts")
check(all(r["status"] == STATUS for t in ["attacks", "defenses", "mapping_reviews"] for r in bundle[t]), "No unreviewed item labeled approved")
rejected(bundle, "Production must reject absent owner acceptance", production=True)
for field, identifier, count in [("attacks", "attack_id", 100), ("defenses", "defense_id", 185), ("mapping_reviews", "mapping_id", 211)]:
    check(len({r[identifier] for r in bundle[field]}) == count, "Unique canonical IDs")
attacks = {r["attack_id"]: r for r in bundle["attacks"]}
check(attacks[1]["draft_attack_id"] == 8 and "machine escape" in attacks[1]["display_name"], "ID 1 is VM escape, not draft DDoS")
check(attacks[21]["draft_attack_id"] == 20 and "Environmental" in attacks[21]["display_name"], "ID 21 is not draft offline cracking")
pairs = {(r["attack_id"], r["defense_id"]) for r in bundle["mapping_reviews"]}
for r in bundle["attacks"]:
    options = r["option_defense_ids"]
    check(len(set(options)) == 4, "Distinct option identities")
    check(sum((r["attack_id"], d) in pairs for d in options) == 1, "Only one mapped option; never reject another valid mapping")
    check(len(r["definition"].split()) >= 13 and len(r["explanation"].split()) >= 34, "Substantive attack explanation")
    check(r["question"].endswith("?"), "Scenario poses an actual question")
for r in bundle["defenses"]:
    check(all(len(r[f].split()) >= 8 for f in ["definition", "mechanism", "conditions", "limitations", "example"]), "Substantive defense mechanism, scope and limits")
for r in bundle["mapping_reviews"]:
    check(not r["applied_to_authoritative_mapping"] and len(r["limitations"].split()) >= 10, "Individual review without silent relationship modification")
for mutation in ["missing", "duplicate", "wrongid", "mapped", "unknown", "approved"]:
    candidate = copy.deepcopy(bundle)
    r = candidate["attacks"][0]
    if mutation == "missing":
        r["example"] = ""
    elif mutation == "duplicate":
        r["option_defense_ids"][1] = r["option_defense_ids"][0]
    elif mutation == "wrongid":
        r["attack_id"] = r["draft_attack_id"]
    elif mutation == "mapped":
        r = next(a for a in candidate["attacks"] if sum(x["attack_id"] == a["attack_id"] for x in candidate["mapping_reviews"]) > 1)
        other = next(d for a, d in pairs if a == r["attack_id"] and d != r["correct_defense_id"])
        r["option_defense_ids"][1] = other
    elif mutation == "unknown":
        r["option_defense_ids"][1] = 999999
    else:
        candidate["owner_accepted"] = True
    rejected(candidate, "Reject invalid " + mutation, production=mutation == "approved")
check(before == {str(p): sha(Path(p)) for p in before}, "All inputs and authoritative catalog unchanged")
print(f"LEARNING RETROFIT: PASS ({checks} checks); 100/185/211; production blocked pending owner acceptance")
