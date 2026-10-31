extends RefCounted
## Read-only facts and identity-checked result joins, never an incident store.
static func rows(game: Node,center: String,mission: String) -> Array:
	var projected: Array=[]
	for original in game.session.internal_for_center(center):
		var row: Dictionary=original.duplicate(true)
		var id:=int(row.learning_attack_id)
		row.attack_id=id;row.mission_id=mission;row.source="orbital_learning_session"
		row.catalog_name=game.loader.attacks.get(id,{}).get("attack_name",row.learning_attack_name)
		row.display_name=game.loader.rich_attacks.get(id,{}).get("display_name",row.learning_attack_name)
		row.definition=game.loader.rich_attacks.get(id,{}).get("definition","No definition available.")
		row.answer_correct=null;row.defense_id=null;row.result_verified=false
		var result: Dictionary=game.session.all_results.get(row.learning_id,{})
		if result.get("physical_id","")==row.physical_id and result.get("center_id","")==row.center_id and result.get("learning_id","")==row.learning_id:
			row.answer_correct=result.get("answer_correct",result.get("hit"));row.defense_id=result.get("answer");row.result_verified=true
		row.cause_text="Threat evaded orbital interception." if row.arrival_cause=="EVADED_INTERCEPTION" else "Threat entered without interception."
		row.evidence="Authoritative arrival and engagement records only. No network telemetry or unauthorized session has been established by this record."
		projected.append(row)
	return projected
