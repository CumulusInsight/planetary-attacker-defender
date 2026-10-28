extends "res://script/catalog_learning_loader.gd"
## Canonical-ID review content. No fixture bank participates in this mode.
var content: Dictionary={}
var rich_attacks: Dictionary={}
var rich_defenses: Dictionary={}
var rich_mappings: Dictionary={}
func load_questions(_public_model: RefCounted,_path: String="",catalog_path: String="res://data/cyber_catalog.json") -> String:
	var source: Dictionary=Data.read_json(catalog_path)
	if not source.error.is_empty():return source.error
	attacks.clear();defenses.clear();mappings.clear()
	for r in source.data.get("attacks",[]):attacks[int(r.ID)]=r
	for r in source.data.get("defenses",[]):defenses[int(r.ID)]=r
	for r in source.data.get("attack_defenses",[]):mappings["%d/%d" % [r.attack_id,r.defense_id]]=true
	if attacks.size()!=100 or defenses.size()!=185 or mappings.size()!=211:return "Canonical catalog counts invalid"
	var rich: Dictionary=Data.read_json("res://data/learning_retrofit.json")
	if not rich.error.is_empty():return rich.error
	return accept_content(rich.data,str(source.data.source_sha256),true)
func accept_content(bundle: Dictionary,fingerprint: String,review_mode: bool) -> String:
	if bundle.get("schema_version")!=1 or bundle.get("canonical_source_sha256")!=fingerprint:return "Learning source fingerprint mismatch"
	if not review_mode and not bundle.get("owner_accepted",false):return "Production blocked: editorial owner acceptance absent"
	if bundle.get("attacks",[]).size()!=100 or bundle.get("defenses",[]).size()!=185 or bundle.get("mapping_reviews",[]).size()!=211:return "Learning content count mismatch"
	for table in ["attacks","defenses"]:
		var evidence: Array=bundle.get("reconciliation",{}).get(table,[])
		if evidence.size()!=(100 if table=="attacks" else 185):return "Missing ID reconciliation"
		var canonical: Dictionary=attacks if table=="attacks" else defenses;var seen: Array=[]
		for row in evidence:
			var id:=int(row.get("canonical_id",-1));var field: String="attack_name" if table=="attacks" else "defense_name"
			if id in seen or not canonical.has(id) or canonical[id][field]!=row.get("canonical_name"):return "Wrong-ID name reconciliation"
			seen.append(id)
	rich_attacks.clear();rich_defenses.clear();rich_mappings.clear()
	for r in bundle.attacks:
		if not Data.integer(r.get("attack_id")):return "Noninteger rich attack ID"
		var id:=int(r.get("attack_id",-1))
		if not attacks.has(id) or rich_attacks.has(id):return "Invalid/duplicate rich attack ID"
		for field in ["display_name","definition","question","explanation","example","distractor_reasoning","status"]:
			if str(r.get(field,"")).strip_edges().is_empty():return "Missing learning attack field: "+field
		if not review_mode and r.status!="OWNER_ACCEPTED":return "Production blocked: unaccepted attack"
		rich_attacks[id]=r
	for r in bundle.defenses:
		if not Data.integer(r.get("defense_id")):return "Noninteger rich defense ID"
		var id:=int(r.get("defense_id",-1))
		if not defenses.has(id) or rich_defenses.has(id):return "Invalid/duplicate rich defense ID"
		for field in ["display_name","definition","mechanism","conditions","limitations","example","status"]:
			if str(r.get(field,"")).strip_edges().is_empty():return "Missing learning defense field: "+field
		if not review_mode and r.status!="OWNER_ACCEPTED":return "Production blocked: unaccepted defense"
		rich_defenses[id]=r
	for r in bundle.mapping_reviews:
		var key: String="%d/%d" % [r.attack_id,r.defense_id]
		if not mappings.has(key) or rich_mappings.has(key):return "Rich mapping does not match canonical pair"
		if not review_mode and r.status!="OWNER_ACCEPTED":return "Production blocked: unaccepted mapping"
		rich_mappings[key]=r
	for r in rich_attacks.values():
		var seen: Array=[]
		if r.option_defense_ids.size()!=4:return "Four learning options required"
		for value in r.option_defense_ids:
			if not Data.integer(value):return "Noninteger defense option"
			var id:=int(value)
			if not defenses.has(id) or id in seen:return "Invalid/duplicate learning option"
			seen.append(id)
			if id!=int(r.correct_defense_id) and mappings.has("%d/%d" % [r.attack_id,id]):return "Mapped defense used as distractor"
		if int(r.correct_defense_id) not in seen or not mappings.has("%d/%d" % [r.attack_id,r.correct_defense_id]):return "Unmapped correct learning answer"
	content=bundle;return ""
func generate(seed_number: int,contacts: Array) -> String:
	seed_value=seed_number;excluded.clear();var rng:=RandomNumberGenerator.new();rng.seed=seed_value
	var ids: Array=rich_attacks.keys();ids.sort();var pool: Array=[]
	for id in ids:
		var r: Dictionary=rich_attacks[id]
		pool.append({"question_id":"RETROFIT-V12-%03d" % id,"attack_id":id,"correct_defense_id":int(r.correct_defense_id),"options":shuffled(r.option_defense_ids.map(func(d):return int(d)),rng),"learning_deadline_seconds":300+30*(int(id)%8)})
	var problem:=validate_bank({"schema_version":1,"session_size":5,"questions":pool})
	if not problem.is_empty():return problem
	bank_size=pool.size()
	if bank_size!=100:return "All 100 canonical attacks required"
	pool=shuffled(pool,rng).slice(0,22);rounds.clear()
	for offset in range(0,22,5):
		var group: Array=[]
		for index in range(offset,mini(offset+5,22)):
			var q: Dictionary=pool[index];var center: String="DC-%02d" % [index%6+1]
			var slots: Array=contacts.filter(func(c):return c.center_id==center and not int(c.contact_id) in [1,4,7])
			if slots.is_empty():return "Missing learning center slots"
			var slot: Dictionary=slots[(index/6)%slots.size()]
			q.contact_id=int(slot.contact_id);q.center_id=center;q.learning_authored=true;group.append(q)
		rounds.append(tag_round(group,rounds.size()))
	activate_round(0);return ""
