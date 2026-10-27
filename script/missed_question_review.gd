extends RefCounted
## Detached copies only: cannot launch, roll evasion, or write original results.
var questions: Array=[]
var results: Dictionary={}
var original_score: Dictionary={}
var attacks: Dictionary={}
var defenses: Dictionary={}
var mappings: Dictionary={}
func configure(source: RefCounted,original_results: Dictionary,score: Dictionary) -> void:
	original_score=score.duplicate(true);attacks=source.attacks.duplicate(true);defenses=source.defenses.duplicate(true);mappings=source.mappings.duplicate(true)
	for group in source.rounds:
		for q in group:
			if original_results.has(q.learning_id) and not original_results[q.learning_id].answer_correct:questions.append(q.duplicate(true))
func evaluate(identity: String,defense: int) -> bool:
	if results.has(identity):return false
	var matches: Array=questions.filter(func(q):return q.learning_id==identity)
	if matches.is_empty() or not matches[0].options.has(defense):return false
	var q: Dictionary=matches[0]
	var correct: bool=defense==int(q.correct_defense_id) and mappings.has("%d/%d" % [q.attack_id,defense])
	results[identity]={"answer":defense,"correct":correct,"correct_name":defenses[int(q.correct_defense_id)].defense_name}
	return true
func performance() -> Dictionary:
	var corrected: int=results.values().filter(func(r):return r.correct).size()
	return {"total":questions.size(),"reviewed":results.size(),"corrected":corrected,"still_incorrect":results.size()-corrected,"remaining":questions.size()-results.size()}
