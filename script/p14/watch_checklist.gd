extends RefCounted
## Read-only projection: navigation never checks off a procedure.
static func rows(s: RefCounted) -> Array:
	var recovery: Array=s.recovery_blockers()
	return [
		row("Receive watch briefing",s.started,false,"Take command to receive your assignment.","welcome"),
		row("Review crew responsibilities",s.met.size()==3,s.met.size()>0,"Meet the three crew members and hear their outstanding concerns.","crew:mara"),
		row("Inspect operational readiness",s.inspected.has("core") and s.completed_jobs.has("health"),s.jobs.has("health"),"Run the power and cooling check in station operations.","core"),
		row("Commission an upgrade",s.upgrade_ready,s.jobs.has("commission"),"Allocate one improvement and complete commissioning. Personal sign-off needs Identity and Network inspection.","upgrade"),
		row("Investigate the incident",s.evidence_reviewed,s.incident!="QUIET","Await unusual activity, then review available account or network evidence.","identity" if s.account_known else "network"),
		row("Complete corrective actions",s.credentials_retired and (not s.unauthorized or s.session_revoked),s.jobs.has("rotate"),"Retire the credential; revoke an accepted unauthorized session separately.","identity"),
		row("Verify operational recovery",s.service_verified and recovery.is_empty(),s.jobs.has("verify")," ".join(recovery) if not recovery.is_empty() else "Run service verification in station operations.","core",not recovery.is_empty()),
		row("File report and hand over",s.finished,false," ".join(s.handover_blockers()) if not s.ready_to_finish() else "Ready to file the watch report.","debrief",not s.ready_to_finish() and not s.finished)
	]
static func row(title: String,done: bool,active: bool,reason: String,destination: String,blocked: bool=false) -> Dictionary:
	return {"title":title,"status":"Verified" if done else "In Progress" if active else "Blocked" if blocked else "Pending","reason":"Procedure complete." if done else reason,"destination":destination,"mandatory":true}
