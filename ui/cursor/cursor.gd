extends Node2D

@export var smoothing := 12.0

func _ready() -> void:
	set_dragging(false)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _process(delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var viewport_size := get_viewport_rect().size

	var target_pos := Vector2(
		clamp(mouse_pos.x, 0.0, viewport_size.x),
		clamp(mouse_pos.y, 0.0, viewport_size.y)
	)

	global_position = global_position.lerp(target_pos,  1.0 - exp(-smoothing * delta))

func set_dragging(dragging: bool):
	$CursorPoint.visible = !dragging
	$CursorDragging.visible = dragging
	
func _on_drag_manager_drag_start() -> void:
	set_dragging(true)

func _on_drag_manager_drag_end() -> void:
	set_dragging(false)
