extends RefCounted
## Navigation metadata only. The game.session remains the sole incident owner.
const CENTERS=["DC-01","DC-02","DC-03","DC-04","DC-05","DC-06"]
var game: Node
var mission_sequence:=1
var run_id:=""
var selected_center:="DC-01"
func configure(owner_game: Node,sequence: int=1,run: String="") -> void:
	game=owner_game;mission_sequence=sequence;run_id=run if not run.is_empty() else "RUN-%d" % Time.get_ticks_usec()
func mission_id() -> String:
	return "%s/M%03d/G%03d" % [run_id,mission_sequence,game.session.generation]
func select_center(center: String) -> bool:
	if center not in CENTERS:return false
	selected_center=center;return true
func training_blocker() -> String:
	if not game.session.pending.is_empty() or game.session.in_flight() or game.animations_active():return "Live missiles are queued or in flight, or impact effects remain. "+("Resume the live mission until they finish, then press PAUSE before training." if game.command.strategic_paused else "Wait until launches and impact effects finish, then press PAUSE before training.")
	if not game.command.learning_mode:return "Training is unavailable during an Active Challenge mission. Return to Learning Mode before training."
	if not game.command.strategic_paused:return "Pause the live mission using PAUSE in Learning Mode before entering training. Training never pauses live combat automatically."
	return ""
