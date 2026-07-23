extends Node2D

@onready var sprite_door_closed = $AnimationRoot/MicrowaveDoorClosed
@onready var sprite_door_half = $AnimationRoot/MicrowaveDoorHalf
@onready var sprite_door_open = $AnimationRoot/MicrowaveDoorOpen

func _enter_tree() -> void:
	for child in $AnimationRoot/InnerRoot.get_children():
		child.get_node("Droppable").draggable_root = get_parent()
