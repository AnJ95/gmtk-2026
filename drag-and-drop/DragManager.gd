extends Node2D
class_name DragManager

@export var draggable_mask: int = 1 << 4
@export var is_active := true : set = _set_is_active

var active_draggable: Draggable = null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			active_draggable = pick_top_draggable(get_global_mouse_position())
			if active_draggable:
				active_draggable.drag_start()
				get_viewport().set_input_as_handled()
		else:
			if active_draggable:
				active_draggable.drag_end()
				active_draggable = null
				get_viewport().set_input_as_handled()

func pick_top_draggable(pos: Vector2) -> Draggable:
	var space := get_world_2d().direct_space_state
	var params := PhysicsPointQueryParameters2D.new()
	params.position = pos
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.collision_mask = draggable_mask

	var hits := space.intersect_point(params, 32) # up to 32 candidates

	var best: Draggable = null
	var best_score := -INF

	for hit in hits:
		if hit.collider is Draggable:
			var draggable: Draggable = hit.collider
			if not draggable.is_enabled():
				continue
			var score := float(draggable.root.get_index())
			if score > best_score:
				best_score = score
				best = draggable
	return best


func _on_round_manager_round_started(round_duration: int, round_time_getter: Callable) -> void:
	is_active = true

func _on_round_manager_round_ended() -> void:
	is_active = false

func _set_is_active(v: bool):
	is_active = v
	for in_group in get_tree().get_nodes_in_group("draggable"):
		var draggable = in_group as Draggable
		draggable.set_enabled(is_active)
