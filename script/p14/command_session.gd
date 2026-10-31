extends RefCounted
## Standalone authored exercise. Never calls a P12 evaluator, registry or score.
var scenario: Dictionary
var attack: Dictionary
var clock:=0.0
var started:=false
var paused:=false
var finished:=false
var revision:=0
var inspected: Dictionary={}
var met: Dictionary={}
var followed: Dictionary={}
var crew_briefed:=false
var evidence_reviewed:=false
var upgrade:=""
var commissioning:=""
var upgrade_ready:=false
var jobs: Dictionary={}
var completed_jobs: Dictionary={}
var incident:="QUIET"
var incident_at:=0.0
var account_known:=false
var connection_known:=false
var credentials_retired:=false
var unauthorized:=false
var session_revoked:=false
var route_open:=true
var service_verified:=false
var compromise_confirmed:=false
var events: Array=[]
var metrics:={"Operational readiness":76,"Security effectiveness":50,"Infrastructure development":20,"Resource stewardship":80,"Leadership & personnel":50}
var last_message:="Your installation. Your first watch."
func configure() -> void:
	scenario=JSON.parse_string(FileAccess.get_file_as_string("res://data/p14/first_watch.json"))
	var content: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/learning_retrofit.json"))
	for row in content.attacks:
		if int(row.attack_id)==int(scenario.attack_id):attack=row.duplicate(true)
	assert(not attack.is_empty())
func record(kind: String,message: String,deltas: Dictionary={}) -> void:
	events.append({"time":clock,"kind":kind,"message":message,"deltas":deltas.duplicate()})
	for key in deltas:metrics[key]=clampi(int(metrics[key])+int(deltas[key]),0,100)
	last_message=message;revision+=1
func start() -> void:
	if started:return
	started=true;record("command","Watch accepted. Meet your crew and inspect the installation.")
func inspect_module(id: String) -> void:
	if not started or finished or inspected.has(id):return
	inspected[id]=true;record("inspection","%s inspected." % id.capitalize())
func talk(id: String) -> void:
	if not started or finished:return
	if not met.has(id):met[id]=true;record("crew","Spoke with "+personnel_name(id)+".",{"Leadership & personnel":2})
func follow_up(id: String) -> void:
	if not met.has(id) or followed.has(id) or finished:return
	followed[id]=true;record("crew","Heard "+personnel_name(id)+"'s concerns.",{"Leadership & personnel":1})
func brief_crew() -> bool:
	if finished or crew_briefed or not followed.has("eli"):return false
	crew_briefed=true;record("leadership","Messages retained privately. Crew briefed to verify requests without blaming Ensign Eli Chen.",{"Leadership & personnel":7});return true
func choose_upgrade(value: String) -> bool:
	if not started or finished or not upgrade.is_empty() or value not in ["identity","network"]:return false
	upgrade=value;record("infrastructure",value.capitalize()+" upgrade allocated. Choose who commissions it.",{"Resource stewardship":-4});return true
func commission(mode: String) -> bool:
	if upgrade.is_empty() or not commissioning.is_empty() or mode not in ["delegate","personal"] or finished:return false
	commissioning=mode;start_job("commission",float(scenario.commission_seconds[mode]));record("task","Chief Petty Officer Mara Voss is commissioning the module." if mode=="delegate" else "Personal commissioning underway. Verify the identity and communications modules.");return true
func start_job(id: String,duration: float) -> void:
	jobs[id]={"began":clock,"duration":duration};revision+=1
func remaining(id: String) -> float:
	return maxf(0,float(jobs[id].began)+float(jobs[id].duration)-clock) if jobs.has(id) else 0.0
func step(delta: float) -> void:
	if not started or paused or finished:return
	clock+=maxf(delta,0)
	for key in jobs.keys():
		if remaining(key)>0:continue
		if key=="commission" and commissioning=="personal" and (not inspected.has("identity") or not inspected.has("network")):continue
		var first_completion:=not completed_jobs.has(key)
		jobs.erase(key);completed_jobs[key]=true
		match key:
			"commission":
				upgrade_ready=true;record("infrastructure","%s module online. Maintenance window approaching." % upgrade.capitalize(),{"Infrastructure development":45,"Operational readiness":6,"Leadership & personnel":10 if commissioning=="delegate" else 5})
			"health":record("operations","Power and cooling baseline verified. Service margin is healthy.",{"Operational readiness":6})
			"account":account_known=true;record("evidence","Legacy vendor account found: factory credential remains active.")
			"connection":connection_known=true;record("evidence","Repeated attempts reach the remote-maintenance gateway. Source attribution is unresolved.")
			"rotate":credentials_retired=true;service_verified=false;record("response","Factory credential retired. New sign-ins require the replacement credential.",{"Security effectiveness":22})
			"verify":service_verified=true;record("verification","Customer service and approved maintenance verified. No data compromise established.",{"Operational readiness":4,"Security effectiveness":8} if first_completion else {})
	if incident=="QUIET" and upgrade_ready and met.size()>=2 and clock>=90:
		incident="SUSPICIOUS";incident_at=clock;account_known=upgrade=="identity";connection_known=upgrade=="network"
		record("alert","Lieutenant Junior Grade Imani Rao: unusual activity on the vendor maintenance service. Inspect the highlighted module.")
	if incident=="SUSPICIOUS" and not credentials_retired and route_open and not unauthorized and clock-incident_at>=(100 if upgrade=="identity" else 65):
		unauthorized=true;incident="UNAUTHORIZED";record("access","Simulated evidence: the vendor service accepted a factory credential. Revoke the session as well as changing the credential.",{"Security effectiveness":-12,"Operational readiness":-3})
func audit_account() -> bool:
	if finished or incident=="QUIET" or account_known or jobs.has("account"):return false
	start_job("account",22);record("investigation","Auditing service-account configuration.");return true
func trace_connection() -> bool:
	if finished or incident=="QUIET" or connection_known or jobs.has("connection"):return false
	start_job("connection",16);record("investigation","Tracing the maintenance service path.");return true
func health_check() -> bool:
	if not started or finished or completed_jobs.has("health") or jobs.has("health"):return false
	start_job("health",18);record("operations","Checking power and cooling baseline.");return true
func rotate_credential() -> bool:
	if finished or not account_known or credentials_retired or jobs.has("rotate"):return false
	start_job("rotate",18);record("response","Provisioning a unique vendor credential; customer traffic stays online.");return true
func set_route(opened: bool) -> bool:
	if finished or not connection_known or route_open==opened:return false
	route_open=opened;service_verified=false
	if not opened:
		record("response","Maintenance route isolated. Customer service remains online; vendor work is delayed.",{"Resource stewardship":-3})
	else:record("response","Maintenance route restored. Verify the service before filing your report.")
	return true
func revoke_session() -> bool:
	if finished or not unauthorized or session_revoked or not account_known:return false
	session_revoked=true;service_verified=false;record("response","Unauthorized vendor session revoked. Evidence preserved.",{"Security effectiveness":10});return true
func verify_service() -> bool:
	if finished or not credentials_retired or not route_open or (unauthorized and not session_revoked) or service_verified or jobs.has("verify"):return false
	start_job("verify",25);record("verification","Verifying customer service, approved maintenance and account policy.");return true
func personnel_name(id: String) -> String:
	for crew in scenario.crew:
		if crew.id==id:return crew.rank+" "+crew.name
	return id
func review_evidence(id: String) -> void:
	if finished or evidence_reviewed or incident=="QUIET":return
	if (id=="identity" and account_known) or (id=="network" and connection_known):
		evidence_reviewed=true;record("investigation","Available incident evidence reviewed. Attribution and data compromise remain unconfirmed.")
func recovery_blockers() -> Array:
	var reasons: Array=[]
	if not credentials_retired:reasons.append("Retire the factory credential.")
	if unauthorized and not session_revoked:reasons.append("Revoke the existing unauthorized vendor session.")
	if not route_open:reasons.append("Restore the maintenance route.")
	return reasons
func handover_blockers() -> Array:
	var reasons: Array=[]
	if not started:reasons.append("Receive the watch briefing.")
	if met.size()<3:reasons.append("Review responsibilities with all three crew members.")
	if not inspected.has("core") or not completed_jobs.has("health"):reasons.append("Inspect operations and complete the power/cooling check.")
	if not upgrade_ready:reasons.append("Finish commissioning the infrastructure upgrade.")
	if not evidence_reviewed:reasons.append("Review available incident evidence.")
	reasons.append_array(recovery_blockers())
	if not service_verified:reasons.append("Complete service recovery verification.")
	if not jobs.is_empty():reasons.append("Wait for active operational jobs to finish.")
	return reasons
func ready_to_finish() -> bool:
	return handover_blockers().is_empty()
func finish() -> bool:
	if finished or not ready_to_finish():return false
	finished=true;incident="STABILIZED";record("debrief","Watch report filed. The installation is ready for the next crew.");return true
func score() -> int:
	var total:=0
	for value in metrics.values():total+=int(value)
	return roundi(float(total)/metrics.size())
func standings() -> Array:
	var rows: Array=scenario.competitors.duplicate(true);rows.append({"center":"DC-01","name":"You / Lieutenant","score":score(),"player":true})
	rows.sort_custom(func(a,b):return a.score>b.score if a.score!=b.score else a.center<b.center);return rows
func objective() -> String:
	if finished:return "Watch complete. Review your report or explore the installation."
	if not started:return "Take command of Orbital Data Center 01."
	if upgrade.is_empty():return "Meet your crew. Allocate one security upgrade."
	if commissioning.is_empty():return "Choose who commissions the new module."
	if not upgrade_ready:return "Commissioning in progress. Inspect modules and speak with the crew."
	if incident=="QUIET":return "Maintenance opens shortly. Check the installation and meet the watch."
	if not credentials_retired:return "Inspect the vendor account. Stop the unauthorized access path."
	if unauthorized and not session_revoked:return "New sign-ins are protected. Revoke the existing vendor session."
	if not route_open:return "Restore the maintenance route when ready."
	if not service_verified:return "Verify service restoration."
	if met.size()<3:return "Speak with the remaining crew before handover."
	if not handover_blockers().is_empty():return str(handover_blockers()[0])
	return "File your watch report when ready."
