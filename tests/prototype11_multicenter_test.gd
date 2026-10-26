extends "res://tests/prototype11_test.gd"
func open_session(seed_number: int,limit: int=3,legacy: bool=false) -> void:
	learning=load("res://scene/learning_command.tscn").instantiate();learning.session_seed=seed_number;learning.participating_center_limit=limit;learning.legacy_test_fixture=legacy
	game=learning;test_viewport.add_child(learning);await frames();command=learning.command;command.set_strategic_pause(true);pointer_at(Vector2(40,140));await frames();learning.show_page("analyze");learning.analyze();learning.close_page();await frames()
func assert_questions(source: RefCounted) -> void:
	check(source.questions.size()==5,"Exactly five learning questions per session")
	var contacts:={};var attacks:={};var centers:={}
	for q in source.questions:
		check(not contacts.has(q.contact_id) and not attacks.has(q.attack_id),"Unique contact and attack in selected set")
		contacts[q.contact_id]=true;attacks[q.attack_id]=true;centers[q.center_id]=true
		check(command.registry.contacts[int(q.contact_id)].center_id==q.center_id,"Actual contact/center association retained")
		check(q.options.size()==4 and q.options.count(q.correct_defense_id)==1,"Exactly four choices and one answer")
		var mapped:=0
		for id in q.options:
			check(source.defenses.has(int(id)),"Exact real catalog defense ID")
			if source.mappings.has("%d/%d" % [q.attack_id,id]):mapped+=1
		check(mapped==1,"Other mapped defenses are not distractors")
	check(centers.size()<=3,"No more than three centers")
func run() -> void:
	await open_session(12345)
	check(learning.error.is_empty() and learning.loader.bank_size==12,"Twelve validated distinct attack templates loaded")
	assert_questions(learning.loader)
	var bank: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/learning_question_bank.json"))
	check(learning.loader.validate_bank(bank).is_empty(),"Full authored bank validates mappings and deadlines")
	var bad=bank.duplicate(true);bad.questions[0].options[1]=129
	check(not learning.loader.validate_bank(bad).is_empty(),"Second valid mapped defense rejected as distractor")
	bad=bank.duplicate(true);bad.questions[0].learning_deadline_seconds=-1
	check(not learning.loader.validate_bank(bad).is_empty(),"Invalid learning deadline rejected")
	bad=bank.duplicate(true);bad.questions[0].attack_id=999
	check(not learning.loader.validate_bank(bad).is_empty(),"Missing catalog attack rejected")
	var other=preload("res://script/learning_question_loader.gd").new();check(other.load_questions(command.decision_pages.model).is_empty(),"Catalog baseline loaded")
	check(other.prepare_session(command.decision_pages.model,12345).is_empty() and other.questions==learning.loader.questions,"Same seed reproduces associations/order/options/deadlines exactly")
	var current: Array=learning.loader.questions.duplicate(true)
	other.prepare_session(command.decision_pages.model,98765)
	check(other.questions.map(func(q):return q.attack_id)!=current.map(func(q):return q.attack_id),"Different seed changes selected attack set/order")
	check(other.questions.map(func(q):return q.options)!=current.map(func(q):return q.options),"Countermeasure positions vary")
	check(not other.prepare_session(command.decision_pages.model,3,4).is_empty(),"More than three centers rejected")
	var recorded: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("user://prototype11_learning_session.json"))
	check(recorded.seed==12345 and recorded.bank_sha256==FileAccess.get_sha256("res://data/learning_question_bank.json"),"Recorded seed and content fingerprints support reproduction")
	check(learning.session.results.is_empty() and not learning.toast.visible,"No initial answer-key feedback")
	# The old P10 clocks remain original contacts; P11 now explicitly owns different learning windows.
	check(command.decision_pages.deadline_items.has(1) and command.decision_pages.deadline_items.has(4) and command.decision_pages.deadline_items.has(7),"Underlying P10 primary clocks retain C001/C004/C007")
	check(not command.decision_pages.deadline_table.visible and learning.learning_deadline_table.visible,"Only current learning clock list is visible in learning context")
	for q in learning.loader.questions:
		var v: Dictionary=learning.deadline_view(q.contact_id)
		check(v.source=="P11 learning" and not learning.operational_deadline(q.contact_id).applies,"Never inherit a neighbor's operational deadline")
		check(learning.learning_deadline_items[int(q.contact_id)].get_text(2)==learning.time_labels[int(q.contact_id)].text,"Primary and Report share exact contact-owned remaining value")
		check(learning.session.learning_remaining(q.contact_id)==q.learning_deadline_seconds,"Explicit authored budget starts at Analyze, not app launch")
		check(q.contact_id not in [1,4,7],"Official original encounter participant count unchanged")
	await open_report();await capture("p11_multi_report")
	var id: int=learning.loader.questions[0].contact_id
	var remaining: float=learning.session.learning_remaining(id);await frames(10)
	check(learning.session.learning_remaining(id)==remaining,"Strategic pause holds learning deadline")
	await press(learning.closes.report);await open_report()
	check(learning.session.learning_remaining(id)==remaining and learning.loader.questions==current,"Reopen/re-analysis cannot reset or reshuffle active session")
	learning.analyze();check(learning.session.learning_remaining(id)==remaining and learning.loader.questions==current,"Repeated Analyze preserves time and questions")
	command.set_learning_mode(false);await create_timer(0.3).timeout;await frames()
	check(learning.session.learning_remaining(id)<remaining,"Challenge countdown advances on authoritative simulation time")
	command.set_learning_mode(true);command.set_strategic_pause(true);await frames();var held: float=learning.session.learning_remaining(id);await frames(8)
	check(learning.session.learning_remaining(id)==held,"Resume then pause has no catch-up")
	learning.session.learning_deadlines[id]=learning.session.now+0.05
	command.set_learning_mode(false);await create_timer(0.15).timeout;await frames()
	check(learning.time_labels[id].text=="EXPIRED" and learning.learning_deadline_items[id].get_text(2)=="EXPIRED","Expired learning opportunity consistent in both displays")
	check(learning.session.results.is_empty(),"Expiry does not invent a defensive result or alter learning score")
	var late=Session.new();late.configure(learning.loader);late.advance(100);late.analyze(command.registry.public_rows());late.learning_deadlines[id]=late.now
	late.select_answer(id,int(late.question(id).correct_defense_id));check(late.request_fire(id,0).ok,"Explicit late practice stays available after learning expiry")
	var late_shots: Array=late.begin_volley();check(late_shots[0].late_practice and late.finish_shot(id,late.generation).late_practice,"Late practice recorded separately without inventing an operational outcome")
	check(not JSON.stringify(learning.session.public_rows()).contains("correct_defense"),"Public report projection never includes answer-key fields")
	command.set_learning_mode(true);command.set_strategic_pause(true);learning.restart_learning();await frames()
	check(learning.session.learning_remaining(id)==learning.session.question(id).learning_deadline_seconds,"Learning restart restores same seeded scenario and own deadline")
	# Responsive layouts, all original contacts within separate center bounds.
	learning.close_page();await frames()
	check(learning.orbital_display.centers.size()==3 and learning.orbital_display.markers.size()==18,"Three displayed centers, six contacts each")
	for c in learning.orbital_display.centers:
		var tile: Rect2=learning.orbital_display.tiles[c]
		check(Rect2(0,0,1600,900).encloses(tile),"All center tiles fit 1600 x 900 without scrolling")
		for contact_id in learning.orbital_display.markers:
			if command.registry.contacts[contact_id].center_id==c:check(tile.has_point(learning.orbital_display.markers[contact_id].position),"Each moving contact stays in its own center display")
	await capture("p11_multi_three_centers")
	var hovered_id: int=learning.loader.questions[0].contact_id
	var hitbox: Control=learning.orbital_display.interactions[hovered_id]
	pointer_at(hitbox.get_global_rect().get_center());await frames();var source=learning.actor_for(hovered_id);var position: Vector2=source.position
	await frames(8);check(source.is_hovered and source.position==position,"Projected hover freezes only its actual source contact")
	pointer_at(Vector2(40,140));await frames();check(not source.is_hovered,"Projected exit releases original hover without catch-up")
	# Simultaneous three-center volley with independently mixed outcomes.
	var official: Dictionary=command.mission.public_snapshot();var events: Array=command.operations.session.events();var cyber: Dictionary=command.cyber.session.public_view(10)
	var index:=0
	await open_report()
	for q in learning.loader.questions:
		var choice: int=q.correct_defense_id if index<3 else q.options.filter(func(d):return d!=q.correct_defense_id)[0]
		await press(learning.option_buttons[int(q.contact_id)][q.options.map(func(v):return int(v)).find(choice)]);check(learning.session.answers[int(q.contact_id)]==choice,"Clicked shuffled option stores intended catalog ID");index+=1
	await press(learning.nav.decide);command.set_learning_mode(false);await press(learning.fire_buttons[0])
	check(learning.projectiles.size()==5 and learning.session.results.is_empty(),"One action launches five independent shots, no early scores")
	var involved:={}
	for shot in learning.projectiles:
		var center_id: String=command.registry.contacts[shot.contact_id].center_id;involved[center_id]=true
		check(shot.origin==learning.orbital_display.origins[center_id],"Projectile starts at its displayed associated center")
		check(shot.target==learning.orbital_display.markers[shot.contact_id],"Projectile homes to the correct displayed moving contact")
	check(involved.size()==3,"Volley spans all three centers at once")
	await create_timer(0.2).timeout;await capture("p11_multi_volley")
	await create_timer(3.3).timeout;await frames()
	check(learning.session.results.size()==5 and learning.session.metrics().correct==3 and learning.session.metrics().incorrect==2 and learning.session.metrics().percentage==60,"Independent mixed outcomes keep correct metrics")
	for q in learning.loader.questions:check(learning.orbital_display.markers[int(q.contact_id)].visible!=learning.session.results[int(q.contact_id)].hit,"Correct target hidden; missed target remains in its own display")
	check(command.mission.public_snapshot()==official and command.operations.session.events()==events and command.cyber.session.public_view(10)==cyber,"P10 operational truth/evaluator/score/ledger untouched")
	await capture("p11_multi_results")
	await press(command.decision_pages.top_buttons.threat)
	check(not learning.orbital_canvas.visible and command.decision_pages.deadline_table.visible,"Original P10 presentation restored for comparison")
	await close_game()
	# One/two center participation still supports five questions with real unique background contacts.
	for limit in [1,2]:
		await open_session(99,limit);assert_questions(learning.loader)
		check(learning.orbital_display.centers.size()==limit and learning.orbital_display.markers.size()==limit*6,"Responsive one/two-center contact count")
		for tile in learning.orbital_display.tiles.values():check(Rect2(0,0,1600,900).encloses(tile),"One/two-center bounds visible")
		learning.close_page();await capture("p11_multi_%d_centers" % limit);await close_game()
	# Exact deadline priority on DC01 with an actually configured operational window.
	await open_session(0,3,true)
	var ops=command.operations.session;ops._contacts[10].config.operational_deadline_seconds=125.0
	check(ops.execute(10,"escalate","p11-dc01-priority","Public fixture concern",{"assessment":"Uncertain"}).ok,"Existing deadline fixture uses actual owner")
	await frames();check(learning.deadline_view(10).source=="P10 operational" and learning.time_labels[10].text=="02:05" and learning.learning_deadline_items[10].get_text(2)=="02:05","DC01 matching contact/owner shown exactly in both views")
	ops.advance(125);await frames();check(learning.time_labels[10].text=="EXPIRED" and learning.learning_deadline_items[10].get_text(2)=="EXPIRED","Operational expiry stays exact; no fallback or extension")
	await close_game()
	# Fresh normal launches record different RNG seeds, rather than silently using a fixed default.
	await open_session(-1);var first_seed: int=learning.session_seed;var first_questions: Array=learning.loader.questions.duplicate(true);await close_game()
	await open_session(-1);check(learning.session_seed!=first_seed and learning.loader.questions!=first_questions,"Normal application sessions generate fresh seed/selection")
	await close_game()
	print("PROTOTYPE 11 TIME VARIETY MULTICENTER: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
