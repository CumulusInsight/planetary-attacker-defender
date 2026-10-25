extends CanvasLayer
## Public receipts projected from existing resolutions, never private outcome codes.
const Clock = preload("res://script/command_status.gd")
var records: Array = []
var banner: Label
var history_button: Button
var modal: ColorRect
var history_label: Label
var close_button: Button
var selected_id := -1
var summary_panel: Panel
var summary_label: Label
func _ready() -> void:
 layer = 25
 var shell := Control.new()
 shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
 shell.size = Vector2(1600,900)
 var theme := Theme.new()
 theme.default_font = load("res://fonts/routed-gothic-wide.ttf")
 theme.default_font_size = 16
 shell.theme = theme
 add_child(shell)
 summary_panel = Panel.new()
 place(shell,summary_panel,Rect2(16,500,300,330))
 var summary_scroll := ScrollContainer.new()
 summary_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 place(summary_panel,summary_scroll,Rect2(12,12,276,306))
 summary_label = Label.new()
 summary_label.add_theme_font_size_override("font_size",15)
 summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 summary_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 summary_scroll.add_child(summary_label)
 summary_panel.hide()
 banner = Label.new()
 banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
 banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 banner.add_theme_color_override("font_color",Color(1,0.96,0.65))
 place(shell,banner,Rect2(340,852,910,46))
 history_button = Button.new()
 history_button.text = "After-action history"
 place(shell,history_button,Rect2(16,850,300,38))
 history_button.pressed.connect(func(): modal.show())
 modal = ColorRect.new()
 modal.color = Color(0.02,0.035,0.05,1)
 place(shell,modal,Rect2(0,0,1600,900))
 var title := Label.new()
 title.text = "ORIGINAL ENCOUNTER / AFTER-ACTION HISTORY"
 title.add_theme_font_size_override("font_size",24)
 place(modal,title,Rect2(100,70,1360,44))
 var scroll := ScrollContainer.new()
 scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 place(modal,scroll,Rect2(100,130,1400,630))
 history_label = Label.new()
 history_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 history_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 scroll.add_child(history_label)
 close_button = Button.new()
 close_button.text = "Return to command"
 place(modal,close_button,Rect2(1180,800,320,40))
 close_button.pressed.connect(func(): modal.hide())
 modal.hide()
 history_button.hide()
func place(parent: Node, control: Control, bounds: Rect2) -> void:
 parent.add_child(control)
 control.position = bounds.position
 control.size = bounds.size
func publish(receipts: Array, contact_id: int, attempt: int = 0) -> void:
 records = receipts.duplicate(true)
 selected_id = contact_id
 history_button.visible = not records.is_empty()
 history_button.text = "After-action history (%d)" % records.size()
 var latest := latest_for(contact_id)
 summary_panel.visible = not latest.is_empty() and (attempt == 0 or latest.attempt == attempt)
 if summary_panel.visible: summary_label.text = format_brief(latest)
 banner.text = "" if latest.is_empty() or (attempt > 0 and latest.attempt != attempt) else "C-%03d | %s | %s\n%s / After-action history available" % [contact_id,latest.acceptance,time_text(latest.remaining),latest.disposition]
 history_label.text = "\n\n".join(records.map(func(record): return format_record(record)))
func latest_for(id: int) -> Dictionary:
 for index in range(records.size()-1,-1,-1):
  if records[index].contact_id == id: return records[index].duplicate(true)
 return {}
static func time_text(seconds: float) -> String:
 return "No applicable countdown" if seconds < 0 else "%s remaining (%.3fs)" % [Clock.format_time(ceil(seconds)),seconds]
static func format_record(record: Dictionary) -> String:
 return ("%s | %s | %s | simulation %.3fs\n" % [record.get("local_datetime",""),record.get("center_id",""),record.get("path_id",""),record.get("simulation_elapsed",0.0)]) + "C-%03d / attempt %d / receipt %d\n%s: %s\n%s\nACTION: %s\nDISPOSITION: %s\nOBSERVED: %s\nLIMITS: %s" % [record.contact_id,record.attempt,record.receipt_id,record.acceptance,record.command,time_text(record.remaining),record.execution,record.disposition,record.observation,record.uncertainty]

static func format_brief(record: Dictionary) -> String:
 return "C-%03d / %s\n%s\n%s\n%s\n\nOBSERVED\n%s\n\nFull receipts: After-action history" % [record.contact_id,record.acceptance,time_text(record.remaining),record.execution,record.disposition,record.observation]
