extends "res://script/correct_only_learning_session.gd"
## Partial submissions reuse inherited grading, queue, clocks and RNG.
func report_submittable() -> bool:
	return analyzed and not review_locked and not eligible().is_empty() and pending.is_empty() and not in_flight()
func eligible() -> Array:
	return super.eligible().filter(func(id):return not submitted_questions.has(question(id).learning_id))
func request_fire(id: int,delay: int) -> Dictionary:
	var ids:=eligible()
	var response:=super.request_fire(id,delay)
	if response.ok:
		for contact in ids:submitted_questions[question(contact).learning_id]=true
		refresh_pending_contact()
	return response
func refresh_pending_contact() -> void:
	# Legacy Decide summary uses this single-shot compatibility field.
	if not pending.is_empty() and pending.shots.size()==1:pending.contact_id=int(pending.shots[0].contact_id)
func begin_volley() -> Array:
	var shots:=super.begin_volley()
	refresh_pending_contact()
	return shots
func submit_answers(delay: int=0) -> Dictionary:
	if not report_submittable():return {"ok":false,"error":"Select a new answer, or wait for the active launch sequence to finish."}
	return request_fire(focused,delay)
func cancel() -> bool:
	# Preserve existing WAIT cancellation: only not-yet-launched selections unlock.
	if pending.is_empty():return false
	for shot in pending.shots:submitted_questions.erase(shot.learning_id)
	return super.cancel()
func live_status(id: int) -> String:
	return super.live_status(id).replace("ANSWER INCORRECT","INCORRECT ANSWER")
