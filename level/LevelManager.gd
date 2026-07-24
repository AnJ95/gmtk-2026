extends Node

signal level_prepare(level: Level)

var levels := [
	Level.new(10, 3, [
		preload("res://item/items/item_wine_bottle.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_chinese_takeout.tscn"),
		preload("res://item/items/item_egg.tscn"),
		preload("res://item/items/item_kaba.tscn"),
		preload("res://item/items/item_smartphone.tscn"),
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
	level_prepare.emit(levels[current_level_id])

func _on_rating_rating_end() -> void:
	start_level(current_level_id + 1)
