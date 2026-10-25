extends CanvasLayer
const Clock = preload("res://script/command_status.gd")
var host: Node
var opener: Button
var local_panel: Panel
var local_status: Label
var local_button: Button
var modal: ColorRect
var summary: Label
var queue: Tree
var filter: OptionButton
var sorting: OptionButton
var detail: Label
var detail_scroll: ScrollContainer
var close_button: Button
var confirmation: ColorRect
var confirm_text: Label
var reason_input: LineEdit
var confirm_button: Button
var cancel_button: Button
var actions: Dictionary = {}
var selected := -1
var pending_id := -1
var pending_evidence: Dictionary = {}
var message := ""
var _signature := ""
var _detail_signature := ""
var _building := false

func label(size: int = 17) -> Label:
	var node := Label.new()
	node.add_theme_font_size_override("font_size",size)
	node.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return node
func place(parent: Node, node: Control, bounds: Rect2) -> void:
	parent.add_child(node)
	node.position = bounds.position
	node.size = bounds.size
func button(parent: Node, text: String, bounds: Rect2, callback: Callable) -> Button:
	var node := Button.new()
	node.text = text
	node.add_theme_font_size_override("font_size",16)
	place(parent,node,bounds)
	node.pressed.connect(callback)
	return node
func _ready() -> void:
	layer = 30
	var shell := Control.new()
	shell.size = Vector2(1600,900)
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var theme := Theme.new()
	theme.default_font = load("res://fonts/routed-gothic-wide.ttf")
	shell.theme = theme
	add_child(shell)
	opener = button(shell,"Operations / investigations",Rect2(650,362,370,36),func(): open_console())
	local_panel = Panel.new()
	place(shell,local_panel,Rect2(16,500,300,330))
	local_status = label(16)
	place(local_panel,local_status,Rect2(12,12,276,256))
	local_button = button(local_panel,"Operational commands",Rect2(12,278,276,38),func():
		if host.command.cyber != null and host.command.cyber.is_cyber_contact(selected): host.command.cyber.open_contact(selected)
		else: open_console(selected))
	modal = ColorRect.new()
	modal.color = Color(0.02,0.035,0.05,1.0)
	place(shell,modal,Rect2(0,0,1600,900))
	var heading := label(26)
	heading.text = "CONTACT OPERATIONS / ACCOUNTABILITY"
	place(modal,heading,Rect2(80,62,1200,40))
	close_button = button(modal,"Return to command",Rect2(1240,62,280,40),func(): host.set_console(false))
	summary = label(16)
	place(modal,summary,Rect2(80,112,1440,78))
	filter = OptionButton.new()
	for item in ["All elliptical contacts","ESCALATED","WATCHLIST","INVESTIGATING","RESOLVED","MONITORED","Awaiting review"]: filter.add_item(item)
	filter.add_theme_font_size_override("font_size",16)
	filter.fit_to_longest_item = false
	place(modal,filter,Rect2(80,200,320,36))
	filter.item_selected.connect(func(_index): _signature = "")
	sorting = OptionButton.new()
	for item in ["Operational priority","Contact ID"]: sorting.add_item(item)
	sorting.add_theme_font_size_override("font_size",16)
	place(modal,sorting,Rect2(416,200,264,36))
	sorting.item_selected.connect(func(_index): _signature = "")
	queue = Tree.new()
	queue.hide_root = true
	queue.columns = 4
	queue.column_titles_visible = true
	queue.select_mode = Tree.SELECT_ROW
	queue.allow_reselect = true
	queue.add_theme_font_size_override("font_size",16)
	queue.add_theme_constant_override("v_separation",10)
	for i in range(4):
		queue.set_column_title(i,["Contact / center","State","Investigation","ETA"][i])
		queue.set_column_expand(i,false)
		queue.set_column_custom_minimum_width(i,[155,145,180,80][i])
	place(modal,queue,Rect2(80,250,600,330))
	queue.item_selected.connect(func():
		if _building: return
		var item := queue.get_selected()
		if item != null:
			selected = int(item.get_metadata(0))
			message = ""
			host.navigate(selected)
			host.set_console(true)
			_detail_signature = "")
	var legend := label(16)
	legend.text = "Original encounters: use mission console.\nThese nine contacts have separate operational states.\nState is not a threat classification.\nInvestigation ETA is network simulation time.\nHover does not pause analyst work.\nLearning strategic pause holds the scheduler."
	place(modal,legend,Rect2(80,600,600,180))
	detail_scroll = ScrollContainer.new()
	detail_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	place(modal,detail_scroll,Rect2(720,200,800,376))
	detail = label(18)
	detail.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_scroll.add_child(detail)
	var options := [["watch","Add to Watchlist"],["investigate","Request Investigation"],["escalate","Escalate (confirm...)"],["continue","Continue tracking"],["intercept","Deploy interceptor (abstract)"],["hold_fire","Hold fire / allow departure"],["stand_down","De-escalate to Watchlist"],["release","Resolve: release / stand down"],["review","Mark investigation reviewed"]]
	for i in range(options.size()):
		var action: String = options[i][0]
		actions[action] = button(modal,options[i][1],Rect2(720+(i%2)*408,600+(i/2 as int)*44,392,36),func(): choose(action))
	confirmation = ColorRect.new()
	confirmation.color = Color(0.01,0.02,0.03,0.94)
	place(modal,confirmation,Rect2(0,0,1600,900))
	var confirm_panel := Panel.new()
	place(confirmation,confirm_panel,Rect2(390,170,820,570))
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	place(confirm_panel,scroll,Rect2(24,24,772,360))
	confirm_text = label(18)
	confirm_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(confirm_text)
	reason_input = LineEdit.new()
	reason_input.max_length = 300
	reason_input.placeholder_text = "Reason for escalation (required)"
	place(confirm_panel,reason_input,Rect2(24,402,772,40))
	confirm_button = button(confirm_panel,"Confirm escalation",Rect2(24,482,370,44),confirm_escalation)
	cancel_button = button(confirm_panel,"Cancel",Rect2(426,482,370,44),func(): confirmation.hide())
	reason_input.text_changed.connect(func(text): confirm_button.disabled = text.strip_edges().length() < 3)
	confirmation.hide()
	modal.hide()
	local_panel.hide()

func open_console(id: int = -1) -> void:
	if id >= 0:
		if selected != id: message = ""
		selected = id
	elif selected < 0 and not host.session.ids().is_empty(): selected = int(host.session.ids()[0])
	host.set_console(true)
	_detail_signature = ""
	render()
func choose(action: String) -> void:
	if action == "intercept" and host.command.cyber != null and host.command.cyber.is_cyber_contact(selected):
		host.command.cyber.open_contact(selected)
		return
	if action == "escalate":
		pending_id = selected
		pending_evidence = host.evidence(selected)
		confirm_text.text = "CONFIRM OPERATIONAL ESCALATION / C-%03d\nAssessment: %s\nConfidence in assessment: %s\nSource: %s\n%s\n\nThis is not verified identity. Available responses: Continue tracking; abstract interceptor deployment; Hold fire; De-escalate; Resolve/release. A reason is required.\nNo confirmed deadline unless explicitly configured." % [selected,pending_evidence.get("assessment","Uncertain"),("Not supplied" if pending_evidence.get("confidence") == null else str(pending_evidence.confidence) + "%"),pending_evidence.get("source_type","None"),pending_evidence.get("text","No report available.")]
		reason_input.text = ""
		confirm_button.disabled = true
		confirmation.show()
	else:
		var result: Dictionary = host.execute(selected,action)
		message = command_receipt(selected,action,result)
		_detail_signature = ""
		render()
func confirm_escalation() -> void:
	var result: Dictionary = host.execute(pending_id,"escalate",reason_input.text,pending_evidence)
	message = command_receipt(pending_id,"escalate",result)
	confirmation.hide()
	_detail_signature = ""
	render()
func filtered_ids() -> Array:
	var ids: Array = host.session.ids()
	var mode := filter.selected
	if mode == 6: ids = ids.filter(func(id): return host.session.view(id).awaiting_review)
	elif mode > 0: ids = ids.filter(func(id): return host.session.view(id).state == filter.get_item_text(mode))
	ids.sort_custom(func(a,b):
		if sorting.selected == 0:
			var ranks := {"ESCALATED":0,"INVESTIGATING":1,"WATCHLIST":2,"MONITORED":3,"RESOLVED":4}
			var av: Dictionary = host.session.view(a)
			var bv: Dictionary = host.session.view(b)
			if ranks[av.state] != ranks[bv.state]: return ranks[av.state] < ranks[bv.state]
			if av.state == "ESCALATED":
				if (av.remaining == null) != (bv.remaining == null): return av.remaining != null
				if av.remaining != null and not is_equal_approx(av.remaining,bv.remaining): return av.remaining < bv.remaining
		return a < b)
	return ids
func render() -> void:
	var overview: bool = host.command.focused_center.is_empty()
	opener.visible = overview and not host.command.scorecard_open
	var tactical_id := -1
	if not overview: tactical_id = host.command.tactical_centers[host.command.focused_center].selected_attack_id
	local_panel.visible = not overview and host.session.has_contact(tactical_id) and not host.command.scorecard_open
	if local_panel.visible and not modal.visible:
		selected = tactical_id
		var v: Dictionary = host.session.view(selected)
		local_button.text = "Cyber response / operations" if host.command.cyber != null and host.command.cyber.is_cyber_contact(selected) else "Operational commands"
		local_status.text = "CONTACT C-%03d / OPERATIONS\nState: %s\nInvestigation: %s\nETA: %s\n%s\n%s\n%s\nP9 stats; no mission points." % [selected,v.state,v.investigation,time_text(v.eta),deadline_text(v.remaining),v.disposition,"Report awaits review" if v.awaiting_review else ""]
	if host.error.is_empty():
		var workload: Dictionary = host.session.statistics()
		opener.text = "Operations: %d active / %d queued" % [workload.active,workload.queued]
	else: opener.text = "Operations unavailable / details"
	if not modal.visible: return
	if not host.error.is_empty():
		summary.text = "OPERATIONS UNAVAILABLE: " + host.error
		for control in actions.values(): control.disabled = true
		return
	var stats: Dictionary = host.session.statistics()
	var centers: Array[String] = []
	for center in host.command.tactical_centers:
		var ids: Array = host.session.ids().filter(func(id): return host.command.registry.contacts[id].center_id == center)
		var unresolved: int = ids.filter(func(id): return host.session.view(id).state == "ESCALATED").size()
		var active: int = ids.filter(func(id): return host.session.view(id).investigation == "active").size()
		var queued: int = ids.filter(func(id): return host.session.view(id).investigation == "queued").size()
		centers.append("%s: %d escalated, %d active/%d queued" % [center,unresolved,active,queued])
	summary.text = "P9 CAPACITY: %d slots | %d active / %d queued / %d completed awaiting review | %s\nInvestigated %d | Completed %d | Escalated %d | De-escalated %d | Deployed %d | Hold fire %d | Resolved %d | Open %d\nQueue delays: %.1fs | Rejected commands: %d | Operational statistics only; official mission score unchanged. %s" % [host.session.capacity(),stats.active,stats.queued,stats.awaiting_review,"PAUSED" if host.command.strategic_paused else "Running",stats.contacts_investigated,stats.investigations_completed,stats.contacts_escalated,stats.contacts_deescalated,stats.interceptors_deployed,stats.hold_fire_decisions,stats.contacts_resolved,stats.unresolved_escalations,stats.queue_delay_seconds,stats.rejected_commands," / ".join(centers)]
	var ids := filtered_ids()
	var signature := str(ids)
	_building = true
	if signature != _signature:
		queue.clear()
		var root := queue.create_item()
		for id in ids:
			var item := queue.create_item(root)
			item.set_metadata(0,id)
		_signature = signature
	var item := queue.get_root().get_first_child() if queue.get_root() != null else null
	for id in ids:
		var v: Dictionary = host.session.view(id)
		item.set_text(0,"C-%03d / %s" % [id,host.command.registry.contacts[id].center_id])
		item.set_text(1,v.state)
		item.set_text(2,v.investigation + (" / review" if v.awaiting_review else ""))
		item.set_text(3,"--" if v.eta == null else time_text(v.eta))
		item = item.get_next()
	_building = false
	for action in actions: actions[action].disabled = not host.session.can(selected,action)
	if host.command.cyber != null and host.command.cyber.is_cyber_contact(selected):
		actions.intercept.text = "Review cyber countermeasures"
		actions.intercept.disabled = false
	else: actions.intercept.text = "Deploy interceptor (abstract)"
	if not host.session.has_contact(selected):
		detail.text = "Select an elliptical contact."
		return
	var v: Dictionary = host.session.view(selected)
	var tactical = host.command.registry.contacts[selected].tactical
	var reports: Array = tactical.intelligence.history(selected)
	var signature_detail := "%d/%d/%d/%s/%s/%s" % [selected,host.session.revision,tactical.intelligence.revision,message,time_text(v.eta),deadline_text(v.remaining)]
	if signature_detail != _detail_signature:
		var text := "C-%03d / %s / %s\nInvestigation: %s | %s\n%s\n%s\n" % [selected,host.command.registry.contacts[selected].center_id,v.state,v.investigation,time_text(v.eta),deadline_text(v.remaining),message]
		if not v.consequence.is_empty(): text += "\nCOMMAND: %s\nEXECUTED: %s\nOBSERVED: %s\n" % [v.consequence.issued,v.consequence.executed,v.consequence.observation]
		if not v.reason.is_empty(): text += "\nESCALATION RECORD\nReason: %s\nAssessment at order: %s\nConfidence at order: %s\nReport: %s\nEvidence at order: %s\n" % [v.reason,v.escalation_evidence.get("assessment",""),str(v.escalation_evidence.get("confidence","Not supplied")),v.escalation_evidence.get("report_id",""),v.escalation_evidence.get("text","")]
		if not reports.is_empty(): text += "\n" + "\n\n".join(preload("res://script/attack_info_panel.gd")._source_sections(reports))
		text += "\n\nOPERATIONAL EVENT HISTORY / AFTER ACTION\n"
		for event in host.session.events(true):
			if event.contact_id == selected: text += "%s / %.1fs / %s / %s\n" % [event.local_datetime,event.time,event.kind,JSON.stringify(event.details)]
		detail.text = text
		_detail_signature = signature_detail
static func time_text(seconds: Variant) -> String:
	return "Not applicable" if seconds == null else Clock.format_time(ceil(float(seconds)))
static func deadline_text(seconds: Variant) -> String:
	return "No confirmed deadline." if seconds == null else "Configured operational window: " + time_text(seconds)

func command_receipt(id: int, action: String, result: Dictionary) -> String:
	var view: Dictionary = host.session.view(id)
	var accepted: bool = result.ok
	var text := "C-%03d / %s: %s" % [id,"COMMAND ACCEPTED" if accepted else "COMMAND REJECTED",action]
	text += "\n" + ("No confirmed deadline." if result.get("remaining_at_acceptance") == null else ("Time at acceptance: " if accepted else "Time at rejection: ") + time_text(result.remaining_at_acceptance))
	text += "\nDisposition: " + (view.disposition if not view.disposition.is_empty() else view.state)
	if not accepted: text += "\nNo new action executed: " + result.error
	elif not view.consequence.is_empty(): text += "\nOUTCOME UNVERIFIED: " + view.consequence.executed + " " + view.consequence.observation
	else: text += "\nOperational command recorded; no interception outcome claimed."
	return text
