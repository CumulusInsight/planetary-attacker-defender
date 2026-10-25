"""Read-only, deterministic export of the owner-approved SQLite catalog. No runtime SQLite dependency."""
import argparse, hashlib, json, sqlite3
from pathlib import Path

def export(source):
    source = Path(source).resolve()
    before = hashlib.sha256(source.read_bytes()).hexdigest()
    with sqlite3.connect(source.as_uri() + "?mode=ro", uri=True) as db:
        if db.execute("PRAGMA quick_check").fetchone()[0] != "ok": raise ValueError("SQLite integrity check failed")
        schema = {}
        result = {"schema_version": 1, "source_sha256": before}
        for table, count, columns in [("attacks",100,["ID","attack_name","definition","difficulty","severity","priority_rank"]),("defenses",185,["ID","defense_name","definition"]),("attack_defenses",211,["ID","attack_id","defense_id"])]:
            info = list(db.execute(f"PRAGMA table_info({table})"))
            if [r[1] for r in info] != columns or info[0][5] != 1: raise ValueError(f"Unexpected {table} schema/primary key")
            schema[table] = {"columns":[dict(zip(["cid","name","type","notnull","default","pk"],r)) for r in info],"foreign_keys":list(db.execute(f"PRAGMA foreign_key_list({table})"))}
            rows = [dict(zip(columns,r)) for r in db.execute(f"SELECT * FROM {table} ORDER BY ID")]
            if len(rows) != count: raise ValueError(f"{table}: expected {count}, got {len(rows)}")
            if len({r["ID"] for r in rows}) != count: raise ValueError("Duplicate primary key")
            if any(not isinstance(r["ID"],int) or r["ID"] <= 0 for r in rows): raise ValueError("Invalid ID")
            for row in rows:
                for key,value in row.items():
                    if key.endswith("name") or key in ["definition","difficulty","severity"]:
                        if not isinstance(value,str) or not value.strip(): raise ValueError(f"Empty {table}.{key}")
            result[table] = rows
        attacks = {r["ID"] for r in result["attacks"]}; defenses = {r["ID"] for r in result["defenses"]}
        pairs = set()
        for row in result["attack_defenses"]:
            pair = (row["attack_id"],row["defense_id"])
            if pair[0] not in attacks or pair[1] not in defenses: raise ValueError("Broken attack-defense mapping")
            if pair in pairs: raise ValueError("Duplicate mapping pair")
            pairs.add(pair)
        if {p[0] for p in pairs} != attacks: raise ValueError("Attack without mapped defenses")
        result["source_schema"] = schema
    if hashlib.sha256(source.read_bytes()).hexdigest() != before: raise ValueError("Source changed during export")
    return result

if __name__ == "__main__":
    parser=argparse.ArgumentParser(); parser.add_argument("--source",required=True); parser.add_argument("--output",required=True)
    args=parser.parse_args(); data=export(args.source)
    Path(args.output).write_text(json.dumps(data,indent=2,ensure_ascii=False)+"\n",encoding="utf-8")
    print("Validated 100 attacks, 185 defenses, 211 mappings; source SHA256",data["source_sha256"])
