extends "res://drag-and-drop/Draggable.gd"

enum Direction {
	VERTICAL, HORIZONTAL
}
enum SnapType {
	NONE, MIN, MAX
}
@export var direction := Direction.VERTICAL
@export var min_pos := 0
@export var max_pos := 0
@export var snap_back := SnapType.MIN


func drag_move():
	if not is_enabled():
		drag_end()
		return
	if direction == Direction.VERTICAL:
		root.global_position.y = clamp(get_global_mouse_position().y + drag_offset.y, min_pos, max_pos)
	if direction == Direction.HORIZONTAL:
		root.global_position.x = clamp(get_global_mouse_position().x + drag_offset.x, min_pos, max_pos)

func drag_end():
	super.drag_end()
	if is_enabled() and snap_back != SnapType.NONE:
		var snap_pos = min_pos if snap_back == SnapType.MIN else max_pos
		var tween_property = "global_position:x" if direction == Direction.HORIZONTAL else "global_position:y"
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_property(root, tween_property, snap_pos, 0.6)
		
