extends Node2D

const ItemScene = preload("res://item/item.tscn")
var current_item: Node2D


func _ready() -> void:
	current_item = ItemScene.instantiate() as Node2D
	add_child(current_item)
	current_item.get_node("Draggable").drag_drop($Droppable)
