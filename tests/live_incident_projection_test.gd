extends SceneTree
const Session=preload("res://script/player_fire_session.gd")
const Loader=preload("res://script/rich_learning_loader.gd")
const IncidentView=preload("res://script/live_incident_projection.gd")
class Owner extends Node:
	var session: RefCounted
	var loader: RefCounted
var checks:=0
var failures:=0
func check(value: bool,message: String) -> void:
	checks+=1
	if not value:failures+=1;push_error(message)
func _initialize() -> void:
	var g:=Owner.new();g.loader=Loader.new();check(g.loader.load_questions(null).is_empty(),"Canonical-ID editorial content validates")
	var contacts: Array=[]
	for c in range(1,7):
		var slots: Array=[c*3-2,c*3-1,c*3,c*3+7,c*3+8,c*3+9] if c<=3 else [c*100+1,c*100+2,c*100+3,c*100+4,c*100+5,c*100+6]
		for id in slots:contacts.append({"contact_id":id,"center_id":"DC-%02d" % c})
	check(g.loader.generate(2949072717,contacts).is_empty(),"Recorded DNS seed generates valid 22-question session")
	g.session=Session.new();g.session.configure(g.loader);g.session.analyze(contacts)
	var q: Dictionary=g.loader.questions[0];var id: int=q.contact_id
	check(q.attack_id==33 and q.center_id=="DC-01","Recorded scenario is DNS cache poisoning at DC-01")
	var ctx=preload("res://script/orbital_command_context.gd").new();ctx.configure(g,1,"TEST");var epoch: String=ctx.mission_id()
	check(IncidentView.rows(g,"DC-01",epoch).is_empty(),"No fabricated pending arrivals")
	g.session.select_answer(id,q.correct_defense_id);g.session.submit_answers();var shot: Dictionary=g.session.begin_volley()[0];g.session.claim_launch(shot)
	g.session.advance(36);var hit: Dictionary=g.session.finish_shot(id,g.session.generation)
	check(hit.projectile_outcome=="HIT" and IncidentView.rows(g,"DC-01",epoch).is_empty(),"Correct answer and real HIT yields no internal incident")
	g.session.reset();g.session.analyze(contacts);check(ctx.mission_id()!=epoch,"Learning restart changes projection epoch")
	g.session.select_answer(id,q.correct_defense_id);g.session.submit_answers();shot=g.session.begin_volley()[0];g.session.claim_launch(shot)
	# Controlled test evasion stream only; production probability and RNG implementation are unchanged.
	var rng:=RandomNumberGenerator.new();var seed_value:=0
	while true:
		rng.seed=seed_value
		if rng.randf()<0.5:break
		seed_value+=1
	g.session.evasion_rng.seed=seed_value;g.session.evade_all();g.session.advance(72);var evaded: Dictionary=g.session.finish_shot(id,g.session.generation)
	var rows: Array=IncidentView.rows(g,"DC-01",ctx.mission_id())
	check(evaded.projectile_outcome=="EVADED" and evaded.answer_correct and rows.size()==1,"Correctness and authoritative evaded arrival remain distinct")
	check(rows[0].display_name=="DNS cache poisoning" and rows[0].catalog_name=="DNS POISON" and rows[0].attack_id==33,"Full readable attack name and original ID/name retained")
	check(rows[0].physical_id==evaded.physical_id and rows[0].result_verified and rows[0].defense_id==q.correct_defense_id,"Join uses original physical and learning IDs")
	check(not rows[0].compromise_confirmed and rows[0].state=="ARRIVED_INTERNAL","Arrival cannot claim compromise or an established session")
	var original:=JSON.stringify(g.session.internal_threats);rows[0].display_name="changed copy";IncidentView.rows(g,"DC-01",ctx.mission_id());g.session.finish_shot(id,g.session.generation)
	check(JSON.stringify(g.session.internal_threats)==original,"Read-only copies and repeated callbacks preserve first arrival")
	for c in ["DC-02","DC-03","DC-04","DC-05","DC-06"]:check(IncidentView.rows(g,c,ctx.mission_id()).is_empty(),"No cross-center contamination: "+c)
	for other in g.loader.questions:
		if int(other.contact_id)!=id:g.session.select_answer(other.contact_id,other.options.filter(func(d):return d!=other.correct_defense_id)[0])
	g.session.submit_answers();var first: Dictionary=g.session.internal_for_center("DC-01")[0]
	check(g.session.round_complete() and g.session.advance_round(contacts),"Round advances without clearing arrivals")
	check(g.session.internal_for_center("DC-01")[0]==first,"First arrival survives reused contact/question slots")
	g.session.reset();check(g.session.internal_threats.is_empty(),"Explicit learning restart clears current arrivals")
	g.free();print("LIVE INCIDENT PROJECTION: ","PASS" if failures==0 else "FAIL"," (",failures," failures / ",checks," checks)");quit(0 if failures==0 else 1)
