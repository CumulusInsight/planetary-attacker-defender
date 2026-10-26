extends RefCounted
## Local learning key, independent of operational truth/effectiveness rules.
const Data=preload("res://script/cyber_data.gd")
var questions: Array=[]
var rounds: Array=[]
var attacks:={}
var defenses:={}
var mappings:={}
func load_questions(public_model: RefCounted,path: String="res://data/learning_questions.json",catalog_path: String="res://data/cyber_catalog.json") -> String:
	questions.clear();attacks.clear();defenses.clear();mappings.clear()
	var c: Dictionary=Data.read_json(catalog_path)
	if not c.error.is_empty():return c.error
	if c.data.get("schema_version")!=1 or not c.data.get("source_sha256") is String or c.data.source_sha256.length()!=64:return "Learning catalog: invalid schema/fingerprint"
	for spec in [["attacks",100],["defenses",185],["attack_defenses",211]]:
		if not c.data.get(spec[0]) is Array or c.data[spec[0]].size()!=spec[1]:return "Learning catalog: invalid "+spec[0]+" count"
	for row in c.data.attacks:
		if not Data.integer(row.get("ID")) or attacks.has(int(row.ID)) or not row.get("attack_name") is String:return "Learning catalog: invalid attack"
		attacks[int(row.ID)]=row
	for row in c.data.defenses:
		if not Data.integer(row.get("ID")) or defenses.has(int(row.ID)) or not row.get("defense_name") is String or not row.get("definition") is String:return "Learning catalog: invalid defense"
		defenses[int(row.ID)]=row
	for row in c.data.attack_defenses:
		if not Data.integer(row.get("attack_id")) or not Data.integer(row.get("defense_id")) or not attacks.has(int(row.attack_id)) or not defenses.has(int(row.defense_id)):return "Learning catalog: broken mapping"
		var key: String="%d/%d" % [row.attack_id,row.defense_id]
		if mappings.has(key):return "Learning catalog: duplicate mapping"
		mappings[key]=true
	var source: Dictionary=Data.read_json(path)
	if not source.error.is_empty():return source.error
	var error:=validate(source.data,public_model)
	if not error.is_empty():return error
	questions=tag_round(source.data.questions,0);rounds=[questions.duplicate(true)]
	return ""
func validate(data: Dictionary,public_model: RefCounted) -> String:
	if data.get("schema_version")!=1 or not data.get("questions") is Array or data.questions.size()<3 or data.questions.size()>5:return "Learning questions: require 3-5 questions, schema 1"
	var contacts:={};var ids:={}
	for q in data.questions:
		if not q is Dictionary or not q.get("question_id") is String or q.question_id.is_empty() or ids.has(q.question_id):return "Learning question: invalid/duplicate ID"
		if not Data.integer(q.get("contact_id")) or contacts.has(int(q.contact_id)) or not public_model.contacts.has(int(q.contact_id)):return "Learning question: invalid/duplicate contact"
		var public: Dictionary=public_model.view(int(q.contact_id))
		if q.get("center_id")!=public.center_id:return "Learning question: contact/data-center mismatch"
		if not Data.integer(q.get("attack_id")) or not attacks.has(int(q.attack_id)) or not public.cyber.any(func(h):return int(h.attack_id)==int(q.attack_id)):return "Learning question: attack must be an existing public possibility"
		if not Data.integer(q.get("correct_defense_id")) or not mappings.has("%d/%d" % [q.attack_id,q.correct_defense_id]):return "Learning question: designated answer is not mapped"
		if not q.get("options") is Array or q.options.size()!=4:return "Learning question: exactly four choices required"
		var seen:={};var correct:=0
		for id in q.options:
			if not Data.integer(id) or not defenses.has(int(id)) or seen.has(int(id)):return "Learning question: missing/duplicate defense choice"
			seen[int(id)]=true
			if int(id)==int(q.correct_defense_id):correct+=1
			elif mappings.has("%d/%d" % [q.attack_id,id]):return "Learning question: another mapped defense cannot be a distractor"
		if correct!=1:return "Learning question: exactly one designated answer required"
		ids[q.question_id]=true;contacts[int(q.contact_id)]=true
	return ""

var seed_value:=0
var bank_size:=0
func shuffled(values: Array,rng: RandomNumberGenerator) -> Array:
	var copy:=values.duplicate(true)
	for i in range(copy.size()-1,0,-1):
		var j:=rng.randi_range(0,i);var item=copy[i];copy[i]=copy[j];copy[j]=item
	return copy
func validate_bank(data: Dictionary) -> String:
	if data.get("schema_version")!=1 or data.get("session_size")!=5 or not data.get("questions") is Array or data.questions.size()<5:return "Learning bank: schema 1 and at least five templates required"
	var ids:={};var types:={}
	for q in data.questions:
		if not q is Dictionary or not q.get("question_id") is String or ids.has(q.question_id) or q.question_id.is_empty():return "Learning bank: invalid/duplicate question ID"
		if not Data.integer(q.get("attack_id")) or not attacks.has(int(q.attack_id)) or types.has(int(q.attack_id)):return "Learning bank: missing/duplicate attack"
		if not Data.integer(q.get("correct_defense_id")) or not mappings.has("%d/%d" % [q.attack_id,q.correct_defense_id]):return "Learning bank: answer is not mapped"
		if not q.get("options") is Array or q.options.size()!=4:return "Learning bank: exactly four options required"
		var seen:={};var correct:=0
		for id in q.options:
			if not Data.integer(id) or not defenses.has(int(id)) or seen.has(int(id)):return "Learning bank: invalid/duplicate defense"
			seen[int(id)]=true
			if int(id)==int(q.correct_defense_id):correct+=1
			elif mappings.has("%d/%d" % [q.attack_id,id]):return "Learning bank: mapped distractor is not allowed"
		if correct!=1:return "Learning bank: exactly one designated answer required"
		if not (q.get("learning_deadline_seconds") is float or q.get("learning_deadline_seconds") is int) or not is_finite(float(q.get("learning_deadline_seconds",0))) or q.learning_deadline_seconds<=0 or q.learning_deadline_seconds>86400:return "Learning bank: invalid explicit deadline"
		ids[q.question_id]=true;types[int(q.attack_id)]=true
	return ""
func prepare_session(public_model: RefCounted,seed_number: int,center_limit: int=3,path: String="res://data/learning_question_bank.json") -> String:
	var source: Dictionary=Data.read_json(path)
	if not source.error.is_empty():return source.error
	var problem:=validate_bank(source.data)
	if not problem.is_empty():return problem
	if center_limit<1 or center_limit>3:return "Learning session: one to three centers required"
	seed_value=seed_number;bank_size=source.data.questions.size()
	var rng:=RandomNumberGenerator.new();rng.seed=seed_value
	var slots: Dictionary={"DC-01":[10,11,12,2,3],"DC-02":[13,14,15,5,6],"DC-03":[16,17,18,8,9]}
	var base_slots: Dictionary=slots.duplicate(true)
	var centers: Array=slots.keys().slice(0,center_limit)
	for c in centers:slots[c]=shuffled(slots[c],rng)
	var pool:=shuffled(source.data.questions,rng);rounds.clear()
	for offset in range(0,pool.size(),5):
		var selected: Array=[];var count:=mini(5,pool.size()-offset)
		var round_centers: Array=centers.slice(0,mini(count,centers.size()))
		if offset>0:
			for c in round_centers:slots[c]=shuffled(base_slots[c],rng)
		for i in range(count):
			var c: String=round_centers[i%round_centers.size()];var id: int=slots[c].pop_back()
			if not public_model.contacts.has(id) or public_model.view(id).center_id!=c:return "Learning session: actual contact/center association missing"
			var q: Dictionary=pool[offset+i].duplicate(true);q.contact_id=id;q.center_id=c;q.learning_authored=true;q.options=shuffled(q.options,rng);selected.append(q)
		rounds.append(tag_round(shuffled(selected,rng),rounds.size()))
	activate_round(0)
	return ""
func tag_round(source: Array,index: int) -> Array:
	var tagged: Array=source.duplicate(true)
	for q in tagged:q.learning_id="R%02d/%s" % [index+1,q.question_id];q.round_number=index+1
	return tagged
func activate_round(index: int) -> void:
	questions=rounds[index].duplicate(true)
