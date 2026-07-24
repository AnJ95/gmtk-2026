extends Node

signal level_prepare(level_id: int, level: Level)
signal level_start(level_id: int, level: Level)
signal rating_start()

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
	level_prepare.emit(current_level_id, levels[current_level_id])

func _on_button_start_pressed() -> void:
	level_start.emit(current_level_id, levels[current_level_id])

func _on_button_continue_pressed() -> void:
	start_level(current_level_id + 1)

func _on_timer_level_end() -> void:
	rating_start.emit()
