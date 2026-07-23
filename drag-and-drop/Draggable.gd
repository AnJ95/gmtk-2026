extends Area2D
class_name Draggable

signal dragging_started()
signal dragging_ended()
signal dropped(droppable: Droppable)
signal undropped(droppable: Droppable)
signal dropping_rejected(droppable: Droppable)

@export var root: Node2D
@export var draggable_identifier: String
@export var animate_on_drop_accept := false

var _enabled := true
var dragging := false
var drag_offset := Vector2.ZERO
var current_droppable: Droppable = null
var initial_droppable: Droppable = null

func _ready() -> void:
	assert(root != null, "Draggable root must not be null")
	assert(draggable_identifier != null and draggable_identifier != "", "Draggable identifier must be set")

func _process(_dt):
	if dragging:
		drag_move()

func drag_start():
	dragging = true
	drag_offset = root.global_position - get_global_mouse_position()
	root.reparent(get_tree().root)
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
				drag_drop(initial_droppable)
		else:
			drag_drop(initial_droppable)
			

func drag_move():
	if not is_enabled():
		drag_end()
	root.global_position = get_global_mouse_position() + drag_offset

func drag_drop(droppable: Droppable):
	current_droppable = droppable
	if initial_droppable == null:
		initial_droppable = droppable
	droppable.draggable_drop(self)
	root.reparent(droppable.root)
	dropped.emit(droppable)
	if animate_on_drop_accept:
		animate_drop_accept(droppable)

func animate_drop_accept(droppable: Droppable):
	var target_pos = droppable.get_root_rect().get_center()
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(root, "position", target_pos, 0.2)
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
	
