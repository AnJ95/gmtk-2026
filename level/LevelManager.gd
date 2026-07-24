extends Node

const MUSIC_TITLE = preload("res://music.wav")
const MUSIC_LACRIMOSA = preload("res://lacrimosa.wav")

signal level_prepare(level_id: int, level: Level)
signal level_start(level_id: int, level: Level)
signal rating_start()

var levels := [
	Level.new(10, 3, MUSIC_TITLE, [
		preload("res://item/items/item_wine_bottle.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_chinese_takeout.tscn"),
		preload("res://item/items/item_egg.tscn"),
		preload("res://item/items/item_kaba.tscn"),
		preload("res://item/items/item_smartphone.tscn"),
	], "[b]Lorem ipsum dolor sit amet[/b]

Consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. [i]At vero eos[/i] et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
	Level.new(45, 3, MUSIC_TITLE, [
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn")
	], "[b]Lorem ipsum dolor sit amet[/b]

Consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. [i]At vero eos[/i] et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."),
	Level.new(60, 4, MUSIC_LACRIMOSA, [
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn")
	], "[b]Lorem ipsum dolor sit amet[/b]

Consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. [i]At vero eos[/i] et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")
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
	await get_tree().create_timer(2.0).timeout
	rating_start.emit()
