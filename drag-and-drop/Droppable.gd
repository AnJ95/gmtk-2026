extends Area2D
class_name Droppable

signal draggable_dropped(draggable: Draggable)
signal draggable_undropped(draggable: Draggable)

@export var root: Node2D
@export var draggable_root: Node2D
@export var accepted_draggable_identifiers: Array[String] = []
@export var custom_draggable_rect: Control
@export var max_draggables: int = INF

var current_draggables: Array[Draggable] = []
var _enabled := true

func _ready() -> void:
	assert(draggable_root != null, "Droppable must define root for Draggables")
	assert(accepted_draggable_identifiers.size() > 0, "Droppable must at least have one accepted Draggable identifier")
	if custom_draggable_rect:
		custom_draggable_rect.connect("resized", _custom_draggable_rect_changed)

func draggable_drop(draggable: Draggable):
	current_draggables.append(draggable)
	draggable_dropped.emit(draggable)

func draggable_undrop(draggable: Draggable):
	current_draggables.erase(draggable)
	draggable_undropped.emit(draggable)
	
func enable():
	_enabled = true
	
func disable():
	_enabled = false
	
func is_enabled() -> bool:
	return _enabled

func can_accept(draggable: Draggable) -> bool:
	if accepted_draggable_identifiers.has(draggable.draggable_identifier) and current_draggables.size() < max_draggables:
		return not root.has_method("can_accept_draggable") or root.can_accept_draggable(draggable)
	return false

func get_contents_recursive() -> Array[Draggable]:
	var out: Array[Draggable] = []
	for draggable in current_draggables:
		out.append(draggable)
		if draggable.owned_droppable != null:
			out.append_array(draggable.owned_droppable.get_contents_recursive())
	return out

func get_root_rect(including_custom := true) -> Rect2:
	if including_custom and custom_draggable_rect:
		return custom_draggable_rect.get_global_rect()
	return Util.get_area_rect(self)
	
func _custom_draggable_rect_changed():
	for draggable in current_draggables:
		draggable.droppable_rect_changed(self)
	
