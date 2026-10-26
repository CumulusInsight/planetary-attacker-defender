extends "res://tests/prototype4_test.gd"
const Session=preload("res://script/learning_session.gd")
var learning: Node
var command: Node
var clicks:=0
func settle() -> void:await create_timer(0.23).timeout
func press(control: Button) -> void:
	clicks+=1;await click_at(control.get_global_rect().get_center());await settle()
func open_report() -> void:
	await press(learning.nav.analyze);await press(learning.yes_button)
func assert_no_command_events(before: Array) -> void:
	var after: Array=command.cyber.journal.filter(func(e):return e.kind not in ["Intelligence received","Commander recommendation"])
	check(after==before,"Learning never appends operational decision/score events")
func pure_checks() -> void:
	check(learning.error.is_empty() and learning.loader.questions.size()==5,"Five validated local catalog questions")
	var data: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/learning_questions.json"))
	for q in learning.loader.questions:
		check(q.options.size()==4 and q.options.count(q.correct_defense_id)==1,"Exactly four options and one designated answer")
		var valid:=0
		for id in q.options:
			check(learning.loader.defenses.has(int(id)),"Every option uses a real catalog ID/name")
			if learning.loader.mappings.has("%d/%d" % [q.attack_id,id]):valid+=1
		check(valid==1,"Exactly one mapped option; no other mapped defense is called wrong")
		check(command.decision_pages.model.view(int(q.contact_id)).cyber.any(func(h):return int(h.attack_id)==int(q.attack_id)),"Question association uses public possibility, not hidden capability")
	var bad=data.duplicate(true);bad.questions[0].options[1]=129
	check(learning.loader.validate(bad,command.decision_pages.model).contains("mapped defense"),"Another valid mapping cannot be a distractor")
	bad=data.duplicate(true);bad.questions[0].options[1]=9999
	check(not learning.loader.validate(bad,command.decision_pages.model).is_empty(),"Missing defense rejected")
	bad=data.duplicate(true);bad.questions[0].center_id="DC-03"
	check(not learning.loader.validate(bad,command.decision_pages.model).is_empty(),"Fabricated contact/center association rejected")
	var loader=preload("res://script/learning_question_loader.gd").new()
	check(not loader.load_questions(command.decision_pages.model,"user://no_p11_questions.json").is_empty(),"Missing question data understandable diagnostic")
	check(not loader.load_questions(command.decision_pages.model,"res://data/learning_questions.json","user://no_p11_catalog.json").is_empty(),"Missing catalog rejected; no substitute catalog")
	for delay in [60,300,600]:
		var s=Session.new();s.configure(learning.loader);s.advance(100)
		check(s.analyze(command.registry.public_rows()),"Analyze public registry")
		s.select_answer(10,138);check(s.request_fire(10,delay).ok,"Exact supported wait accepted")
		check(s.pending.due_at==100+delay and s.countdown()==delay,"Minute waits never shortened")
		check(s.select_answer(10,111) and s.pending.shots[0].defense_id==138,"Later selection cannot change scheduled snapshot")
		check(not s.request_fire(10,0).ok,"Duplicate scheduled shot rejected")
		s.advance(100);check(s.countdown()==delay,"Unchanged shared clock holds countdown")
		s.advance(100+delay-0.01);check(s.begin_due().is_empty(),"No early shot")
		check(s.results.is_empty(),"No answer correctness reveal during wait")
		s.advance(100+delay);var shot: Dictionary=s.begin_due()
		check(shot.contact_id==10 and shot.defense_id==138 and shot.hit,"Shot uses immutable selected contact/answer at exact due time")
		check(s.results.is_empty() and s.in_flight(),"Feedback waits for visible impact")
		check(s.finish_shot(10,s.generation).hit,"Correct key yields deterministic hit")
		check(s.finish_shot(10,s.generation).is_empty(),"No double result")
		s.reset();s.select_answer(10,111);s.request_fire(10,0);shot=s.begin_due()
		check(not shot.hit,"Nonmapped distractor yields deterministic miss")
		check(s.finish_shot(10,s.generation).correct_name=="Antivirus","Correct answer revealed only after result")
		s.reset();s.select_answer(10,138);s.request_fire(10,delay)
		check(s.cancel() and s.pending.is_empty(),"Pending cancellation")
func run() -> void:
	learning=load("res://scene/learning_command.tscn").instantiate();learning.legacy_test_fixture=true;game=learning;test_viewport.add_child(learning);await frames()
	command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(800,100));await frames()
	pure_checks()
	var official: Dictionary=command.mission.public_snapshot()
	var operational: Array=command.operations.session.events()
	var cyber: Dictionary=command.cyber.session.public_view(10)
	var commands: Array=command.cyber.journal.filter(func(e):return e.kind not in ["Intelligence received","Commander recommendation"])
	var controls: Array=command.decision_pages.top_buttons.keys()
	check(controls==["overview","contacts","threat","intelligence","history","mission","alerts"],"All existing P10 taskbar controls/order intact")
	check(learning.nav.size()==3 and learning.nav.analyze.text=="A" and learning.nav.report.text=="R" and learning.nav.decide.text=="D","Exactly three P11 taskbar controls: A, R and D")
	for key in learning.nav:
		check(learning.nav[key].size==Vector2(48,34) and not learning.nav[key].tooltip_text.is_empty(),"New navigation matches native dimensions and hover tooltips")
	await capture("p11_default")
	await press(learning.nav.decide)
	check(learning.decide_message.text=="Select a countermeasure in Report first." and learning.fire_buttons[0].disabled,"No answer: firing disabled, explicit Report instruction")
	await press(learning.closes.decide)
	await press(learning.nav.analyze);await capture("p11_analyze")
	await press(learning.no_button)
	check(not learning.session.analyzed and learning.page.is_empty(),"Analyze NO performs no analysis")
	await press(learning.nav.analyze);await press(learning.closes.analyze)
	check(not learning.session.analyzed,"Analyze CLOSE performs no analysis")
	# Required short flow: A-R -> YES (Report) -> choice -> D -> FIRE NOW.
	clicks=0
	await press(learning.nav.analyze);await press(learning.yes_button)
	check(learning.analysis_message.text.contains("Analysis complete") and learning.windows.report.visible,"Analysis enables Report, no private answer disclosed")
	await capture("p11_report")
	check(learning.report_grid.columns==9 and learning.option_buttons.size()==5,"Compact table has time, one attack and four named choices per contact")
	for row in learning.session.public_rows():
		for i in range(4):check(learning.option_buttons[row.contact_id][i].text==row.choices[i].name,"Actual defense name visible, not Option placeholder")
	await press(learning.option_buttons[10][0])
	check(learning.session.answers[10]==138 and learning.option_buttons[10][0].button_pressed,"Selected answer highlighted and stored")
	check(learning.session.results.is_empty() and learning.result_message.text.is_empty() and not learning.why_label.visible,"No premature correctness or key disclosure")
	await press(learning.nav.decide)
	check(learning.windows.decide.visible and not learning.windows.report.visible and not learning.windows.analyze.visible,"Only one new window open")
	check(learning.target_label.text.contains("DC-01 / C-010") and learning.session.answers[10]==138,"Contact/answer persist across Report/Decide")
	await capture("p11_decide")
	command.set_learning_mode(false)
	var actor=learning.actor_for(10);var before: Vector2=actor.position
	await press(learning.fire_buttons[0]);await create_timer(0.14).timeout
	check(learning.session.in_flight() and learning.projectiles.size()==1,"Fire Now launches visible projectile without extra confirmation")
	check(learning.page.is_empty() and learning.toast.visible,"Decision window clears for unobscured flight/impact; temporary learning feedback remains")
	check(clicks==5,"Introductory A-R/YES/answer/D/FIRE flow takes five clicks")
	check(learning.projectiles[0].head.distance_to(learning.projectiles[0].origin)>10 and learning.projectiles[0].trail.size()>1,"Projectile moves away from DATA with visible trail")
	await capture("p11_projectile")
	var projectile=learning.projectiles[0]
	await create_timer(3.3).timeout;await frames()
	check(projectile.impacted_already and projectile.head.is_equal_approx(projectile.target_at_impact),"Correct homing shot reaches the moving target actual position")
	check(learning.session.results[10].hit and not actor.visible,"Correct answer hits and removes only learning target visual")
	check(actor.position!=before and actor.get_parent().get_child_count()==6,"Moving contact model/record is retained, not destroyed")
	check(learning.result_message.text.contains("Correct countermeasure: Antivirus"),"Immediate concise correct feedback")
	await capture("p11_hit")
	await create_timer(1.9).timeout # Allow the requested longer hit effect to finish before another shot.
	check(command.mission.public_snapshot()==official and command.operations.session.events()==operational and command.cyber.session.public_view(10)==cyber,"P10 official scoring/operations/containment unchanged")
	assert_no_command_events(commands)
	# Compare old interface within the same session; restore its original target visual.
	await press(command.decision_pages.top_buttons.threat)
	check(actor.visible and learning.page.is_empty() and command.decision_pages.opened.threat,"P10 comparison restores contact and opens unchanged detailed screen")
	await open_report()
	check(not actor.visible and learning.session.results.has(10),"Returning to learning restores learning-only removal/result")
	await press(learning.option_buttons[11][0]);await press(learning.nav.decide);await press(learning.fire_buttons[0])
	await create_timer(3.8).timeout;await frames()
	check(not learning.session.results[11].hit and learning.actor_for(11).visible,"Incorrect countermeasure visibly misses, target remains")
	check(learning.result_message.text.contains("Incorrect countermeasure") and learning.result_message.text.contains("Segmentation"),"Miss reveals designated correct mapped defense")
	await capture("p11_miss")
	# Actual shared-clock integration for wait and pause. Long wait arithmetic is tested above without shortened durations.
	await open_report();await press(learning.option_buttons[12][1]);await press(learning.nav.decide)
	command.set_strategic_pause(true);command.set_learning_mode(true);command.set_strategic_pause(true)
	await press(learning.fire_buttons[60]);var remaining: float=learning.session.countdown();await frames(12)
	check(is_equal_approx(learning.session.countdown(),remaining) and learning.decide_message.text.contains("Scheduled C-012"),"Existing strategic pause holds pending shot and visible countdown")
	await press(learning.closes.decide)
	check(learning.toast.visible and learning.toast_cancel.visible,"Closed window preserves visible countdown and cancellation access")
	await press(learning.toast_cancel);check(learning.session.pending.is_empty(),"Visible countdown cancellation works")
	await open_report();await press(learning.restart_button)
	check(learning.session.answers.is_empty() and learning.session.results.is_empty() and learning.actor_for(10).visible,"Learning restart restores visuals, clears only learning state")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==operational,"Learning reset does not corrupt P10")
	for key in learning.windows:
		await open_report() if key=="report" else await press(learning.nav.analyze if key=="analyze" else learning.nav.decide)
		await press(learning.closes[key]);check(learning.page.is_empty(),"Every new window has working upper-right Close")
	await close_game()
	# Explicit existing-operational-expiry policy, in an isolated test-only short-window fixture.
	learning=load("res://scene/learning_command.tscn").instantiate();learning.legacy_test_fixture=true;game=learning;test_viewport.add_child(learning);await frames();command=learning.command
	learning.analyze();learning.select_answer(12,19);learning.session.advance(command.operations.session.now);learning.request_fire(60)
	var original=command.tactical_centers["DC-01"]
	original.deadline.capture(original.active_contact,0.02);command.set_learning_mode(false);pointer_at(Vector2(40,100));await frames(6)
	check(original.encounter.public_view(1).status=="Deadline expired" and not learning.session.pending.is_empty(),"P10 operational expiry is not bypassed by pending learning shot")
	var expired: Dictionary=command.mission.public_snapshot()
	# Advance the existing authoritative clock in the test, never shorten the scheduled sixty seconds.
	command.operations.session.advance(61.0);await frames()
	check(learning.session.in_flight(),"Pending learning shot still fires as educational-only after operational expiry")
	await create_timer(3.8).timeout;await frames()
	check(learning.session.results[12].hit and original.encounter.public_view(1).status=="Deadline expired" and command.mission.public_snapshot()==expired,"Learning hit cannot reverse actual P10 expiry or alter official score")
	await close_game()
	print("PROTOTYPE 11: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
