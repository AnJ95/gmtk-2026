extends Node2D

func _ready() -> void:
	set_dragging(false)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	global_position.x = clamp(mouse_pos.x, 0, get_viewport_rect().size.x)
	global_position.y = clamp(mouse_pos.y, 0, get_viewport_rect().size.y)

func set_dragging(dragging: bool):
	$CursorPoint.visible = !dragging
	$CursorDragging.visible = dragging
	
func _on_drag_manager_drag_start() -> void:
	set_dragging(true)

func _on_drag_manager_drag_end() -> void:
	set_dragging(false)
