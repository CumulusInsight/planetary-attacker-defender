extends "res://tests/prototype11_multicenter_test.gd"
func assert_sorted(column: int,ascending: bool) -> void:
	learning.report_sort=-1
	learning.sort_report(column)
	if not ascending:learning.sort_report(column)
	var rows: Array=learning.session.public_rows(learning.review_index)
	var by_id: Dictionary={}
	for row in rows:by_id[row.learning_id]=row
	for i in range(1,learning.report_order.size()):
		var a: Dictionary=by_id[learning.report_order[i-1]];var b: Dictionary=by_id[learning.report_order[i]]
		var av: Variant=learning.report_sort_value(a);var bv: Variant=learning.report_sort_value(b)
		check(av==null or bv==null or av<=bv if ascending else av==null or bv==null or av>=bv,"Column %d direction %s ordered" % [column,ascending])
		if av==bv:check(a.learning_id<b.learning_id,"Stable question identity breaks ties")
	check(learning.report_headers[column].text.ends_with("^" if ascending else "v"),"Active sort arrow")
func run() -> void:
	await open_session(12345)
	var official: Dictionary=command.mission.public_snapshot()
	var budgets: Dictionary=learning.session.learning_deadlines.duplicate(true)
	learning.show_page("report");await frames()
	check(learning.report_headers.size()==9,"Nine clickable Report headings")
	for column in range(9):
		assert_sorted(column,true);assert_sorted(column,false)
	for column in range(9):
		learning.report_sort=-1;learning.build_report();await frames()
		await press(learning.report_headers[column]);check(learning.report_sort==column and learning.report_ascending,"Every rendered header selects its own column")
		await press(learning.report_headers[column]);check(not learning.report_ascending,"Every rendered header reverses")
		var heading: Button=learning.report_headers[column]
		check(heading.get_theme_font("font").get_string_size(heading.text,HORIZONTAL_ALIGNMENT_LEFT,-1,14).x<=heading.size.x,"Heading %d and sort marker fit without clipping (%s / %s)" % [column,heading.get_theme_font("font").get_string_size(heading.text,HORIZONTAL_ALIGNMENT_LEFT,-1,14).x,heading.size.x])
	learning.report_sort=-1;learning.build_report();await frames()
	await press(learning.report_headers[3]);check(learning.report_sort==3 and learning.report_ascending,"Rendered TIME header click ascends")
	await press(learning.report_headers[3]);check(not learning.report_ascending,"Second rendered click reverses direction")
	learning.sort_report(3);var order: Array=learning.report_order.duplicate()
	var ids: Array=learning.loader.questions.map(func(q):return int(q.contact_id))
	ids=[2,6,8,14,11]
	var unanswered: int=ids[4]
	var initial: float=learning.session.learning_remaining(unanswered)
	command.operations.session.now+=3;learning.session.advance(command.operations.session.now);learning.refresh()
	check(learning.report_order==order and learning.session.learning_remaining(unanswered)<initial,"Live times update without shuffling visible rows")
	await capture("p11_manual_sorted_time")
	learning.sort_report(2);await frames();await capture("p11_manual_sorted_attack")
	# Select through reordered controls: callbacks retain question/contact identity.
	for i in range(4):
		var id: int=ids[i];var q: Dictionary=learning.session.question(id)
		var choice: int=int(q.correct_defense_id) if i<2 else int(q.options.filter(func(d):return int(d)!=int(q.correct_defense_id))[0])
		var index: int=q.options.map(func(d):return int(d)).find(choice)
		await frames()
		await press(learning.option_buttons[id][index])
		check(learning.session.answers[id]==choice,"Sorted row selection keeps exact question identity")
	learning.request_fire(60)
	check(learning.deadline_text(ids[0])!="00:00","Scheduled answer is not neutralized")
	learning.session.cancel();learning.close_page();command.set_learning_mode(false)
	learning.request_fire(0);await create_timer(0.3).timeout
	check(learning.projectiles.size()==4 and learning.orbital_display.centers.size()==3,"Simultaneous volley opens three displays")
	check(learning.deadline_text(ids[0])!="00:00","Flight does not neutralize before impact")
	await create_timer(5.8).timeout;await frames()
	check(not learning.animations_active() and learning.orbital_display.centers.size()==3,"No automatic reset after completed effects")
	check(learning.reset_view_button.visible and learning.reset_view_button.text=="RESET TO ONE","Manual reset visible only for multi-center presentation")
	await capture("p11_manual_three_survivors")
	for id in ids.slice(0,2):
		check(learning.session.results[id].learning_state=="NEUTRALIZED" and learning.deadline_text(id)=="00:00","Only confirmed correct hit neutralizes time projection")
		check(learning.learning_deadline_items[id].get_text(2)=="00:00","Primary learning clock matches Report")
	check(learning.deadline_text(ids[2])!="00:00" and learning.deadline_text(unanswered)!="00:00","Incorrect and unanswered clocks continue")
	check(learning.session.learning_deadlines==budgets,"Original absolute deadline data unchanged")
	var score: Dictionary=learning.session.metrics();var results: Dictionary=learning.session.all_results.duplicate(true)
	await press(learning.reset_view_button)
	check(learning.orbital_display.centers.size()==1 and not learning.reset_view_button.visible,"Manual three-to-one reset hides button")
	check(learning.session.all_results==results and learning.session.metrics().correct==score.correct,"View reset preserves results and scores")
	await capture("p11_manual_single_hidden")
	learning.show_page("report");await frames();await capture("p11_manual_zero_report")
	learning.report_sort=-1;learning.sort_report(3);await frames();await capture("p11_manual_zero_time_sort")
	# Complete final contact; deliberately request reset during its animation with two displays shown.
	var q: Dictionary=learning.session.question(unanswered)
	learning.select_answer(unanswered,int(q.correct_defense_id));learning.close_page();learning.request_fire(0);await create_timer(0.15).timeout
	learning.orbital_display.layout_centers(["DC-01","DC-02"]);learning.refresh()
	learning.reset_view();check(not learning.queued_reset_center.is_empty() and learning.orbital_display.centers.size()==2,"Manual reset waits for flight/effects")
	await create_timer(5.8).timeout;await frames()
	check(learning.orbital_display.centers.size()==1 and not learning.reset_view_button.visible,"Deferred two-to-one reset completes after effects")
	command.set_learning_mode(true);command.set_strategic_pause(true)
	command.operations.session.now+=600;learning.session.advance(command.operations.session.now);learning.refresh()
	check(learning.deadline_text(ids[0])=="00:00" and learning.deadline_text(ids[2])=="EXPIRED","Neutralized stays zero while incorrect clock expires")
	learning.review_index=-1;assert_sorted(3,true);assert_sorted(3,false)
	learning.analyze();check(learning.session.round_index==1,"Next round still available")
	learning.select_report_round(1);await frames()
	for row in learning.session.public_rows(0):
		if row.result.hit:check(row.recorded_time=="00:00","Archived neutralization retained at zero")
	var history: Dictionary=learning.session.round_history[0].duplicate(true)
	for column in range(9):assert_sorted(column,true);assert_sorted(column,false)
	check(learning.session.round_history[0]==history,"Historical sorting does not mutate records")
	check(learning.option_buttons.values().all(func(options):return options.all(func(b):return b.disabled)),"Historical answers remain read only")
	await capture("p11_manual_history")
	check(command.mission.public_snapshot()==official,"Official scoring unchanged")
	await close_game()
	print("PROTOTYPE 11 MANUAL RESET TIMER SORTING: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
	quit(0 if failures==0 else 1)
