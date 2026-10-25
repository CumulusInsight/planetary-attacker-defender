extends RefCounted
## Read-only projections. Never reads private fixtures, evaluator rules or unreleased intelligence.
static func epoch(record: Dictionary) -> Variant:
	var value: Variant=record.get("wall_unix",record.get("report",{}).get("wall_unix"))
	if (value is float or value is int) and is_finite(float(value)) and value>0:return float(value)
	var text: String=record.get("local_datetime","")
	var regex:=RegEx.new()
	regex.compile("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}([+-])(\\d{2}):(\\d{2})$")
	var match:=regex.search(text)
	if match==null:return null
	var hours:=int(match.get_string(2));var minutes:=int(match.get_string(3))
	if hours>23 or minutes>59:return null
	var offset: int=(hours*60+minutes)*60*(1 if match.get_string(1)=="+" else -1)
	return float(Time.get_unix_time_from_datetime_string(text.left(19))-offset)
static func age(record: Dictionary, now: float=-1.0) -> String:
	var instant: Variant=epoch(record)
	if instant==null:return "Time unavailable"
	var elapsed: float=(Time.get_unix_time_from_system() if now<0 else now)-float(instant)
	if elapsed<0:return "Clock discrepancy"
	if elapsed<60:return "%d seconds ago" % int(elapsed)
	if elapsed<3600:return "%d minutes ago" % int(elapsed/60)
	if elapsed<86400:return "%d hours ago" % int(elapsed/3600)
	return "%d days ago" % int(elapsed/86400)
static func investigation(operations: RefCounted, id: int) -> Dictionary:
	var view: Dictionary=operations.view(id)
	if view.is_empty():return {"state":"Unavailable","position":null,"eta":null,"progress":null,"active":operations.statistics().active,"capacity":operations.capacity()}
	var result: Dictionary={"state":view.investigation,"position":null,"eta":view.eta,"progress":null,"active":operations.statistics().active,"capacity":operations.capacity()}
	var queued:=[];var started: Variant=null
	for event in operations.events():
		if event.kind=="investigation_requested" and operations.view(int(event.contact_id)).investigation=="queued":queued.append(event.contact_id)
		if event.contact_id==id and event.kind=="investigation_started":started=event.time
	if view.investigation=="queued":result.position=queued.find(id)+1
	if view.investigation=="active" and started!=null and view.eta!=null:
		var elapsed: float=maxf(0,operations.now-float(started))
		if elapsed+float(view.eta)>0:result.progress=elapsed/(elapsed+float(view.eta))*100.0
	return result
static func trend(reports: Array) -> String:
	if reports.size()<2:return "No comparable revision"
	var latest: Dictionary=reports.back()
	for previous in reports.slice(0,-1):
		if latest.get("supersedes","")==previous.report_id and latest.source_type==previous.source_type and latest.has("severity") and previous.has("severity"):
			return "Assessed severity increased" if latest.severity>previous.severity else "Assessed severity decreased" if latest.severity<previous.severity else "Assessed severity unchanged"
	return "No comparable revision"
static func availability(option: Dictionary, choices: Array, operation: Dictionary) -> String:
	if not option.executable:return "Catalog reference only"
	for choice in choices:
		if choice.defense_id==option.defense_id and choice.used:return "Unavailable / already issued"
	if operation.get("state")=="ESCALATED":return "Executable / review required"
	if operation.get("state") in ["MONITORED","WATCHLIST","INVESTIGATING"]:return "Requires escalation"
	return "Unavailable in this scenario"
static func outcome(entry: Dictionary) -> String:
	var details: Dictionary=entry.get("details",{})
	if details.has("outcome"):return str(details.outcome).capitalize()
	if entry.get("kind")=="Intelligence received":return "Received / "+entry.get("report",{}).get("assessment","Uncertain")
	if entry.get("kind")=="Commander recommendation / advisory":return "Advisory issued"
	if entry.get("kind")=="transition":return details.get("from","")+" -> "+details.get("to","")
	if entry.get("command_status","") in ["COMMAND ACCEPTED","COMMAND REJECTED","DEADLINE EXPIRED"]:return entry.command_status
	return str(entry.get("observed_outcome",entry.get("kind","Recorded"))).replace("\n"," ").left(75)
