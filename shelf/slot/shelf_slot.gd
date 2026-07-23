extends Node2D

func _enter_tree() -> void:
	$Droppable.draggable_root = get_parent()
