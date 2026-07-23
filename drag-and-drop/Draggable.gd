extends Area2D
class_name Draggable

signal dragging_started()
signal dragging_ended()
signal dropped(droppable: Droppable)
signal undropped(droppable: Droppable)
signal dropping_rejected(droppable: Droppable)

@export var root: Node2D
@export var draggable_identifier: String
@export var owned_droppable: Droppable = null
@export var animate_on_drop_reject := false
@export var animate_on_drop_accept := false

var _enabled := true
var dragging := false
var drag_offset := Vector2.ZERO
var current_droppable: Droppable = null
var local_in_droppable: Transform2D = Transform2D.IDENTITY

func _ready() -> void:
	assert(root != null, "Draggable root must not be null")
	assert(draggable_identifier != null and draggable_identifier != "", "Draggable identifier must be set")

func _process(_dt):
	if dragging:
		drag_move()
	elif current_droppable != null:
		root.global_transform = current_droppable.draggable_root.global_transform * local_in_droppable

func drag_start():
	dragging = true
	drag_offset = root.global_position - get_global_mouse_position()
	move_to_top()
	if current_droppable != null:
		drag_undrop()
	dragging_started.emit()
	
func drag_end():
	dragging = false
	dragging_ended.emit()
	if is_enabled():
		var droppable := get_currently_overlapping_droppable()
		if droppable:
			if droppable.can_accept(self):
				drag_drop(droppable)
			else:
				dropping_rejected.emit(droppable)
				if animate_on_drop_reject:
					animate_drop_reject(droppable)

func drag_move():
	if not is_enabled():
		drag_end()
		
	root.global_position = get_global_mouse_position() + drag_offset
	# Push transform updates down immediately (no 1-frame lag)
	if owned_droppable != null:
		for child in owned_droppable.get_contents_recursive():
			child.apply_follow_transform_recursive()

func drag_drop(droppable: Droppable):
	current_droppable = droppable
	local_in_droppable = droppable.draggable_root.global_transform.affine_inverse() * root.global_transform
	droppable.draggable_drop(self)
	dropped.emit(droppable)
	if animate_on_drop_accept:
		animate_drop_accept(droppable)

func animate_drop_accept(droppable: Droppable):
	var target_pos = get_random_droppable_accept_position(droppable)
	var current_pos = root.global_position
	root.global_position = target_pos
	var target_local_in_droppable = droppable.draggable_root.global_transform.affine_inverse() * root.global_transform
	root.global_position = current_pos
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "local_in_droppable", target_local_in_droppable, 0.2)
	tween.play()
	
func animate_drop_reject(droppable: Droppable):
	var target_pos = get_random_droppable_reject_position(droppable)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(root, "global_position", target_pos, 0.2)
	tween.play()
	
func drag_undrop():
	var droppable := current_droppable
	current_droppable = null
	droppable.draggable_undrop(self)
	undropped.emit(droppable)

func droppable_rect_changed(droppable: Droppable):
	if animate_on_drop_accept:
		animate_drop_accept(droppable)

func enable():
	set_enabled(true)
	
func disable():
	set_enabled(false)

func set_enabled(enabled: bool):
	_enabled = enabled
	
func is_enabled() -> bool:
	return _enabled

func get_currently_overlapping_droppable() -> Droppable:
	var selected_candidate: Droppable
	for candidate in get_overlapping_areas():
		if candidate is Droppable:
			var droppable := candidate as Droppable
			if not droppable.is_enabled():
				continue
			# TODO better select, also take mouse pos into account to resolve conflict
			if not selected_candidate or droppable.get_index() > selected_candidate.get_index():
				selected_candidate = candidate
	return selected_candidate
	
func move_to_top():
	var parent := root.get_parent()
	var to_move: Array[Node2D] = []
	to_move.append(root)
	if owned_droppable != null:
		for d in owned_droppable.get_contents_recursive():
			if d != null and d.root != null and d.root.get_parent() == parent:
				to_move.append(d.root)
	# Move to top as a block, keeping internal order
	to_move.sort_custom(func(a: Node2D, b: Node2D): return a.get_index() < b.get_index())
	for n in to_move:
		parent.move_child(n, parent.get_child_count() - 1)

func apply_follow_transform_recursive() -> void:
	if current_droppable != null and not dragging:
		root.global_transform = current_droppable.draggable_root.global_transform * local_in_droppable
	# If I'm a container, update my children too (so nesting has no lag)
	if owned_droppable != null:
		for child in owned_droppable.get_contents_recursive():
			if child != null:
				child.apply_follow_transform_recursive()
				
func get_random_droppable_reject_position(droppable: Droppable) -> Vector2:
	# TODO try again if outside viewport
	# TODO try again if now over other Newspaper?
	return Util.get_random_point_outside(Util.get_area_rect(self), droppable.get_root_rect(false), 10)

func get_random_droppable_accept_position(droppable: Droppable) -> Vector2:
	return droppable.get_root_rect().get_center()
	# return Util.move_to_closest_point_inside(Util.get_area_rect(self), droppable.get_root_rect(), 5)
	
