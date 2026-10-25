extends "res://tests/prototype4_test.gd"
const Sorter = preload("res://script/contact_table_sort.gd")
var command: Node
var signals: Array = []
func run() -> void:
 validate_sort_values()
 await original_boundaries()
 operations_boundaries()
 await operations_feedback()
 await header_integration()
 print("PROTOTYPE 9 CORRECTIONS: ","PASS" if failures==0 else "FAIL"," (",failures," failures; ",checks," checks)")
 quit(0 if failures==0 else 1)
func validate_sort_values() -> void:
 var rows: Array = [
 {"contact_id":10,"center_id":"DC-02","assessment":"Uncertain","confidence":100,"severity":3,"remaining":12.0,"operational_status":"WATCHLIST"},
 {"contact_id":2,"center_id":"DC-01","assessment":"Assessed nonhostile","confidence":9,"severity":1,"remaining":120.0,"operational_status":"MONITORED"},
 {"contact_id":11,"center_id":"DC-02","assessment":"Uncertain","confidence":null,"severity":3,"remaining":null,"operational_status":"ESCALATED"},
 {"contact_id":3,"center_id":"DC-01","assessment":"Uncertain","confidence":100,"severity":2,"remaining":12.0,"operational_status":"MONITORED"}]
 for column in range(7):
  for ascending in [true,false]:
   var ordered: Array = Sorter.sorted_rows(rows,column,ascending)
   check(ordered.size()==4,"Every required header sorts without dropping contacts")
 check(Sorter.sorted_rows(rows,0,true).map(func(r): return r.contact_id)==[2,3,10,11],"Numeric contact ID rather than lexicographic")
 check(Sorter.sorted_rows(rows,4,true).map(func(r): return r.severity)==[1,2,3,3],"Severity ordinal ascending")
 check(Sorter.sorted_rows(rows,4,false).map(func(r): return r.severity)==[3,3,2,1],"Severity ordinal descending")
 check(Sorter.sorted_rows(rows,3,true).map(func(r): return r.contact_id)==[2,3,10,11],"Confidence numeric with missing last ascending")
 check(Sorter.sorted_rows(rows,3,false).map(func(r): return r.contact_id)==[3,10,2,11],"Confidence numeric with missing last descending and ID tie")
 check(Sorter.sorted_rows(rows,5,true).map(func(r): return r.contact_id)==[3,10,2,11],"Deadline seconds numeric, no deadline last ascending")
 check(Sorter.sorted_rows(rows,5,false).map(func(r): return r.contact_id)==[2,3,10,11],"No deadline last descending")
 var before := rows.duplicate(true)
 Sorter.sorted_rows(rows,2,false)
 check(rows==before,"Sorting does not mutate public input records")
 var missing: Dictionary = rows.back().duplicate(true)
 missing.contact_id = 12
 missing.erase("confidence")
 rows.append(missing)
 for ascending in [true,false]:
  var sorted: Array = Sorter.sorted_rows(rows,3,ascending)
  check(sorted.slice(-2).map(func(r): return r.contact_id)==[11,12],"Absent and null confidence both placed last with stable ID ties")
func force_remaining(tactical: Node, seconds: float) -> void:
 tactical.active_contact.total_orbit_travel = tactical.deadline.initial.travel + tactical.deadline.budget - tactical.active_contact.move_speed*seconds
func original_boundaries() -> void:
 for fixture in ["H","N","N100"]:
  for remaining in [0.001,0.0,-0.001]:
   game = load("res://scene/game.tscn").instantiate()
   game.developer_fixture = fixture
   test_viewport.add_child(game)
   pointer_at(Vector2(10,880))
   await frames()
   game.set_process(false)
   for contact in game.get_node("EnemyContainer").get_children(): contact.set_process(false)
   game._on_attacker_selected(game.active_contact.attack_id)
   panel = game.get_node("HUD/AttackInfoPanel")
   signals = []
   game.encounter.resolution_recorded.connect(func(event): signals.append(event))
   force_remaining(game,remaining)
   game._on_command_requested("deploy")
   check(signals.size()==1,"One authoritative resolution at deadline boundary")
   var accepted: bool = remaining>0
   check(game.encounter.debug_state().decision==("deploy" if accepted else "expired"),"Strict before/boundary/late decision")
   var expected := "interference_blocked" if fixture=="H" else "probe_interfered"
   if not accepted: expected = "interference_allowed" if fixture=="H" else "legitimate_passage"
   check(game.encounter.debug_state().actual_result==expected,"Existing deterministic outcome unchanged")
   var view: Dictionary = game.encounter.public_view(game.active_contact.attack_id)
   check(panel.reports_label.text.contains(view.observation),"Original observable result visible")
   check(panel.reports_label.text.begins_with("AFTER ACTION"),"Result now precedes intelligence instead of being buried")
   check(panel.reports_label.text.contains("COMMAND ACCEPTED" if accepted else "COMMAND REJECTED"),"Immediate accepted/rejected feedback")
   var receipt: Dictionary = game.after_actions[0]
   check(receipt.remaining>0 if accepted else receipt.remaining==0,"Receipt captures authoritative acceptance/expiry time")
   game.active_contact.total_orbit_travel += game.active_contact.move_speed*10
   game._sync_deadline()
   game._update_clock()
   check(signals.size()==1 and game.encounter.debug_state().decision==("deploy" if accepted else "expired"),"No second expiration or contradictory outcome after deployment")
   check(panel.get_node("Content/Urgency").text.contains("Decision recorded" if accepted else "EXPIRED"),"Resolved-before-expiry stays distinct after motion passes zero")
   var count: int = game.after_actions.size()
   game._on_command_requested("deploy")
   game._on_command_requested("deploy")
   check(signals.size()==1 and game.after_actions.filter(func(r): return r.acceptance=="COMMAND ACCEPTED").size()==(1 if accepted else 0),"Repeated deployment never duplicates accepted resolution")
   check(game.after_actions.size() <= count+1,"Identical repeated rejections coalesced")
   await click_at(game.action_feedback.history_button.get_global_rect().get_center())
   check(game.action_feedback.modal.visible and game.action_feedback.history_label.text.contains(view.observation),"Persistent after-action history accessible by mouse")
   if fixture=="H" and accepted: await capture("p9_fix_original_history")
   await click_at(game.action_feedback.close_button.get_global_rect().get_center())
   check(not game.action_feedback.modal.visible,"History returns without restarting encounter")
   for secret in ["actual_result","private_truth","Martian covert"]:
    check(not game.action_feedback.history_label.text.contains(secret),"Original public history excludes private data")
   game._on_replay_requested()
   check(not game.after_actions.is_empty() and game.action_feedback.banner.text.is_empty(),"Replay keeps history but clears stale receipt banner")
   await close_game()
func operations_feedback() -> void:
 command = load("res://scene/operational_command.tscn").instantiate()
 game = command
 test_viewport.add_child(command)
 pointer_at(Vector2(10,880))
 await frames()
 command.set_strategic_pause(true)
 command.focus_center("DC-01",1)
 var original = command.tactical_centers["DC-01"]
 force_remaining(original,2.0)
 var official_before: Dictionary = command.mission.public_snapshot()
 original._on_command_requested("deploy")
 var official_after: Dictionary = command.mission.public_snapshot()
 check(official_after.resolved==official_before.resolved+1,"Original action still produces one official event")
 await frames()
 await capture("p9_fix_countdown_resolved")
 original._on_command_requested("deploy")
 check(command.mission.public_snapshot()==official_after,"Duplicate original command cannot farm mission points")
 panel = original.get_node("HUD/AttackInfoPanel")
 await frames()
 check(original.action_feedback.summary_panel.visible and original.action_feedback.summary_label.text.contains(original.encounter.public_view(1).observation),"Immediate independent receipt remains visible regardless of report scroll")
 var host = command.operations
 var ui = host.ui
 command.focus_center("DC-01",10)
 ui.open_console(10)
 host.execute(10,"escalate","Public evidence warrants review",host.evidence(10))
 await frames()
 await click_at(ui.actions.intercept.get_global_rect().get_center())
 check(ui.message.contains("C-010") and ui.message.contains("COMMAND ACCEPTED"),"Abstract contact receipt is explicit")
 check(ui.message.contains("No confirmed deadline") and ui.message.contains("UNVERIFIED"),"No invented deadline or confirmed neutralization")
 var events: Array = host.session.events()
 var issued: Array = events.filter(func(e): return e.kind=="command_issued")
 check(issued.size()==1 and issued[0].details.remaining==null,"Existing operations ledger carries acceptance time, no new duplicate ledger")
 var score: Dictionary = command.mission.public_snapshot()
 host.execute(10,"intercept")
 check(host.session.events().filter(func(e): return e.kind=="command_issued").size()==1 and command.mission.public_snapshot()==score,"Repeated abstract command cannot duplicate deployment or scoring")
 check(ui.detail.text.contains("AFTER ACTION"),"Operational after-action history remains in same event view")
 await capture("p9_fix_abstract_receipt")
 await close_game()
func header_integration() -> void:
 command = load("res://scene/operational_command.tscn").instantiate()
 game = command
 test_viewport.add_child(command)
 pointer_at(Vector2(10,880))
 await frames()
 command.set_strategic_pause(true)
 for column in range(7):
  for ascending in [true,false]:
   # Click actual header cells, including already-sorted same column reversal.
   var left: float = command.queue.global_position.x
   for previous in range(column): left += command.queue.get_column_width(previous)
   await click_at(Vector2(left+command.queue.get_column_width(column)*0.5,command.queue.global_position.y+12))
   check(command.header_sort_column==column and command.header_sort_ascending==ascending,"Header actual input toggles required column")
   check(command.queue.get_column_title(column).ends_with(" ^" if ascending else " v"),"Visible ascending/descending marker")
   var actual: Array = []
   var item: TreeItem = command.queue.get_root().get_first_child()
   while item!=null:
    actual.append(item.get_metadata(0))
    item = item.get_next()
   check(actual==command.strategic_table_rows().map(func(row): return row.contact_id),"Visible order matches public header comparator")
   check(actual.size()==18,"Every header retains all eighteen contacts")
 await capture("p9_fix_header_sort")
 # Preserve selected row object, scroll position and navigation through reordering.
 var selected: TreeItem = command.queue_rows[18]
 command._refreshing = true
 selected.select(0)
 command._refreshing = false
 command.queue.scroll_to_item(selected)
 await frames()
 var scroll: Vector2 = command.queue.get_scroll()
 command._on_column_title_clicked(0)
 await frames()
 check(command.queue.get_selected()==selected and command.queue_rows[18]==selected,"Header sorting preserves selected row object")
 check(command.queue.get_scroll().is_equal_approx(scroll),"Header sorting preserves scroll offset")
 # A new public assessment reorders deterministically without changing contact selection.
 command._on_column_title_clicked(2)
 var intel = command.registry.contacts[18].tactical.intelligence
 var report := {"contact_id":18,"report_id":"TEST-REASSESS-18","assessment":"AAA revised assessment","confidence":50,"severity":2,"source_type":"Follow-up Analysis","text":"Public revision for stable sorting test."}
 intel.append_operational_report(report)
 command.refresh()
 check(command.queue.get_selected()==selected and command.queue_rows[18]==selected,"Intelligence updates preserve selection while sorting")
 check(command.queue.get_root().get_first_child().get_metadata(0)==18,"Assessment update uses current public text")
 var signature: Array = command.strategic_table_rows().map(func(row): return row.contact_id)
 command.refresh()
 check(command.strategic_table_rows().map(func(row): return row.contact_id)==signature,"Equal public data does not flicker ordering")
 command.queue.scroll_to_item(selected)
 await frames()
 await click_at(command.queue.global_position+command.queue.get_item_area_rect(selected).get_center())
 check(command.focused_center=="DC-03" and command.tactical_centers["DC-03"].selected_attack_id==18,"Row navigation after sorting highlights associated contact")
 var public_text: String = JSON.stringify(command.strategic_table_rows())
 for secret in ["private_truth","covert_relay","peaceful_survey_probe","actual_result"]:
  check(not public_text.contains(secret),"Sorting never projects hidden truth")
 await close_game()

func operations_boundaries() -> void:
 var config: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/contact_operations.json"))
 config.contacts[0].operational_deadline_seconds = 1.0
 for elapsed in [0.999,1.0,1.001]:
  var session = preload("res://script/operations_session.gd").new()
  check(session.configure(config,[10,11,12,13,14,15,16,17,18]).is_empty(),"Configured operational boundary fixture")
  session.execute(10,"escalate","escalate","Public concern",{"assessment":"Uncertain"})
  session.advance(elapsed)
  var result: Dictionary = session.execute(10,"intercept","intercept")
  check(result.ok == (elapsed < 1.0),"Abstract authorization follows configured before/boundary/late rule")
  var events: Array = session.events()
  var commands: Array = events.filter(func(e): return e.kind=="command_issued")
  check(commands.size()==1 and commands[0].details.remaining > 0 if elapsed < 1.0 else commands.size()==1 and commands[0].details.remaining==0,"Existing ledger records configured acceptance or expiry remaining time")
  session.advance(20)
  check(session.events().filter(func(e): return e.kind=="resolved").size()==1,"No contradictory second configured operational disposition")
  var count: int = session.events().size()
  session.execute(10,"intercept","intercept")
  check(session.events().size()==count,"Configured-boundary command redelivery remains idempotent")
