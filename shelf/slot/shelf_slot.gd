extends Node2D

var item_scene: PackedScene
var current_item: Node2D


func _ready() -> void:
	assert(item_scene != null, "ShelfSlot needs item_scene")
	current_item = item_scene.instantiate() as Node2D
	add_child(current_item)
	current_item.get_node("Draggable").drag_drop($Droppable)
