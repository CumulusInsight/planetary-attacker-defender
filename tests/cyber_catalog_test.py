import sys
sys.dont_write_bytecode = True
import importlib.util, json, hashlib, sqlite3
from pathlib import Path
module_spec=importlib.util.spec_from_file_location("exporter",Path(__file__).parents[1]/"tools/export_cyber_catalog.py")
module=importlib.util.module_from_spec(module_spec); module_spec.loader.exec_module(module)
source=Path("C:/Users/azwam/Projects/cyber_defensev12/data/cyber.db")
before=hashlib.sha256(source.read_bytes()).hexdigest()
actual=module.export(source)
assert actual==json.loads(Path("data/cyber_catalog.json").read_text(encoding="utf-8"))
assert before==hashlib.sha256(source.read_bytes()).hexdigest()
assert [len(actual[t]) for t in ["attacks","defenses","attack_defenses"]]==[100,185,211]
assert all(not v["foreign_keys"] for v in actual["source_schema"].values())
print("CYBER CATALOG: PASS; reproducible exact export, declared schema, manual mappings and unchanged source hash verified")
