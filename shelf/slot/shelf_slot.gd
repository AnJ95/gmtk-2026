extends Node2D

const Item = preload("res://item/item.gd")
var item_scene: PackedScene
var current_item: Item


func _ready() -> void:
	assert(item_scene != null, "ShelfSlot needs item_scene")
	current_item = item_scene.instantiate() as Item
	add_child(current_item)
	current_item.get_node("Draggable").drag_drop($Droppable)
	
	$VBoxContainer/LabelItemName.text = current_item.item_name
	$VBoxContainer/LabelItemTime.text = "%ds" % current_item.target
