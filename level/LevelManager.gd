extends Node

signal level_start(level: Level)

var levels := [
	Level.new(95, 3, [
		preload("res://item/items/item_wine_bottle.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn")
	]),
	Level.new(45, 3, [
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn")
	]),
	Level.new(60, 4, [
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn")
	])
]

var current_level_id = 0

func _ready() -> void:
	start_level(0)
	
func start_level(level_id: int):
	current_level_id = level_id
	level_start.emit(levels[current_level_id])
	
