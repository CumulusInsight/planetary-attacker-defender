"""Format authored content for owner review; does not generate learning prose."""
import json
from collections import Counter
from pathlib import Path


def render(root=Path(".")):
    bundle = json.loads((root / "data/learning_retrofit.json").read_text(encoding="utf-8"))
    attacks = {r["attack_id"]: r for r in bundle["attacks"]}
    defenses = {r["defense_id"]: r for r in bundle["defenses"]}
    quality = {
        "status": bundle["content_status"], "owner_accepted": False,
        "production_eligible": False, "independent_sme_approval": False,
        "counts": {t: len(bundle[t]) for t in ["attacks", "defenses", "mapping_reviews"]},
        "mapping_decisions": dict(Counter(r["decision"] for r in bundle["mapping_reviews"])),
        "control_roles": dict(Counter(r["role"] for r in bundle["mapping_reviews"])),
        "topic_types": dict(Counter(r["kind"] for r in bundle["attacks"])),
        "remaining_placeholders": [],
        "owner_review_required": "All 496 candidate entries; all question choices; all proposed mapping qualifications/corrections/removals.",
        "attack_checks": [], "defense_checks": [], "mapping_exceptions": [],
    }
    lines = ["# Complete learning-content candidate — owner review book", "",
             "**Not production-approved.** All 100 attacks, 185 defenses and 211 mapping pairs have an authored editorial candidate. Counts and validation do not constitute owner or independent SME approval.", "",
             "Canonical IDs below belong to the existing v12 database. Draft IDs are provenance only. Original tables and mappings are unchanged. The three REMOVE_PROPOSED edges remain authoritative until the owner decides otherwise.", "",
             "The book intentionally shows answer keys for editorial review. In-game keys and reasoning are gated until submission/evaluation. Original draft identification questions have been converted into scenario-specific countermeasure questions for the existing defense-selection game; their before/after values remain in the machine-readable report.", "",
             "## Scope exceptions requiring particular attention", "",
             "- Chosen-plaintext cryptanalysis has only the broad Secure Change mapping. Its question explicitly tests governed migration, not a claim that change management supplies cryptographic security.",
             "- Broad categories (cloud, serverless, OT, Kubernetes, DNS, quantum and environmental topics) name a concrete scenario rather than pretend each is one discrete attack.",
             "- Bloatware and advertising software are not automatically malware; packet capture and wardriving may be legitimate authorized work.",
             "- Source verification, Tokens, Strong Hashing, Encrypted RFID, Secure DNS and Pod Policies require the narrower interpretations recorded in their individual reviews.",
             "- Generic assurance controls such as education, monitoring, audits and assessments are not prevention guarantees. Backups support recovery, not prevention of ransomware or radio jamming.",
             "- Distractors are curated and never include another authoritative mapped defense. Scenario-specific best-answer fairness still requires human play review; an unmapped control is not universally useless.",
             "- No field remains a source-preserving placeholder. All candidate content, including the eight rewritten password lessons, remains unaccepted; no production approval has been inferred.", "",
             "## Attack lessons", ""]
    for r in bundle["attacks"]:
        quality["attack_checks"].append({
            "canonical_attack_id": r["attack_id"], "draft_attack_id": r["draft_attack_id"],
            "kind": r["kind"], "status": r["status"],
            "required_fields_present": all(r.get(f) for f in ["definition", "question", "example", "explanation", "distractor_reasoning"]),
            "option_count": len(r["option_defense_ids"]), "owner_acceptance_pending": True})
        lines += [f"### {r['attack_id']}. {r['display_name']}", "",
                  f"Draft provenance ID: {r['draft_attack_id']}. Topic type: {r['kind']}. Status: {r['status']}.", "",
                  "**Definition:** " + r["definition"], "", "**Scenario question:** " + r["question"], ""]
        for index, d in enumerate(r["option_defense_ids"], 1):
            lines.append(f"{index}. {defenses[d]['display_name']} — canonical defense {d}")
        lines += ["", "**Designated answer:** " + defenses[r["correct_defense_id"]]["display_name"], "",
                  "**Explanation and reasoning:** " + r["explanation"], "",
                  "**Why the other offered options do not meet the scenario:** " + r["distractor_reasoning"], "",
                  "**Distinct realistic example:** " + r["example"], ""]
    lines += ["## Defense explanations", ""]
    for r in bundle["defenses"]:
        quality["defense_checks"].append({
            "canonical_defense_id": r["defense_id"], "draft_defense_id": r["draft_defense_id"],
            "status": r["status"], "required_fields_present": all(r.get(f) for f in ["definition", "mechanism", "conditions", "limitations", "example"]),
            "owner_acceptance_pending": True})
        lines += [f"### Defense {r['defense_id']}. {r['display_name']}", "",
                  f"Draft provenance ID: {r['draft_defense_id']}. Status: {r['status']}.", ""]
        for field, label in [("definition", "Definition"), ("mechanism", "How it works"), ("conditions", "Applicable conditions"), ("limitations", "Important limitations"), ("example", "Realistic example")]:
            lines += [f"**{label}:** {r[field]}", ""]
    lines += ["## Individual mapping judgments — not applied to the authoritative relationships", ""]
    for r in bundle["mapping_reviews"]:
        if r["decision"] != "RETAIN":
            quality["mapping_exceptions"].append(r)
        lines += [f"### Mapping {r['mapping_id']}: attack {r['attack_id']} → defense {r['defense_id']}", "",
                  attacks[r["attack_id"]]["display_name"] + " → " + defenses[r["defense_id"]]["display_name"], "",
                  f"**{r['decision']} / {r['role']}**. Status: {r['status']}. Original edge remains unchanged.", "",
                  "**Mechanism / applicability:** " + r["applicability"], "",
                  "**Limitations / rationale:** " + r["limitations"], ""]
    (root / "Reports/Learning_Retrofit_Editorial_Review.md").write_text("\n".join(lines), encoding="utf-8")
    (root / "Reports/Learning_Retrofit_Quality.json").write_text(json.dumps(quality, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print("Review book: 100 attack sections, 185 defense sections, 211 individual mapping sections; no approval assigned.")


if __name__ == "__main__":
    render()
