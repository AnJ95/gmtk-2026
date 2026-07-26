extends Node

const MUSIC_TITLE = preload("res://music.wav")
const MUSIC_LACRIMOSA = preload("res://lacrimosa.wav")
const MUSIC_SPACE = preload("res://space.wav")

signal level_prepare(level_id: int, level: Level)
signal level_start(level_id: int, level: Level)
signal rating_start()

@export var first_level_id = 0

var levels := [
	Level.new(30, 3, MUSIC_TITLE, [
		preload("res://item/items/item_wine_bottle.tscn"),
		preload("res://item/items/item_pizza.tscn"),
		preload("res://item/items/item_pizza.tscn"),
	], "[b]First Date at my place![/b]

A romance is blooming... your crush is coming over to your place for a romatic dinner.
Prepare two pizzas and a bottle of wine for the date.

Damn it, you don't have a wine opener!"),
	Level.new(30, 3, MUSIC_TITLE, [
		preload("res://item/items/item_egg.tscn"),
		preload("res://item/items/item_egg.tscn"),
		preload("res://item/items/item_egg.tscn"),
		preload("res://item/items/item_egg.tscn"),
		preload("res://item/items/item_kaba.tscn"),
		preload("res://item/items/item_kaba.tscn")
	], "[b]5 years later...[/b]

Your love has grown and you have two beautiful children.
Prepare breakfast for your family"),
	Level.new(40, 2, MUSIC_LACRIMOSA, [
		preload("res://item/items/item_chinese_takeout.tscn"),
		preload("res://item/items/item_chinese_takeout.tscn"),
		preload("res://item/items/item_chinese_takeout.tscn"),
		preload("res://item/items/item_divorce_papers.tscn"),
		
	], "[b]2 years later...[/b]

Unfortunately your luck has run out.
Your wife is divorcing you and your are no longer allowed to see your children.
The days pass by and the takeout boxes are starting to rise to a large tower."),
	Level.new(60, 2, MUSIC_LACRIMOSA, [
		preload("res://item/items/item_smartphone.tscn"),
		preload("res://item/items/item_microwave.tscn"),
	], "[b]Soon after...[/b]

You found the answers that you were looking for.
Everything around you finally makes sense."),
	Level.new(60, 3, MUSIC_SPACE, [
		preload("res://item/items/item_planet_mercury.tscn"),
		preload("res://item/items/item_planet_venus.tscn"),
		preload("res://item/items/item_planet_earth.tscn"),
		preload("res://item/items/item_planet_mars.tscn"),
		preload("res://item/items/item_planet_jupiter.tscn"),
		preload("res://item/items/item_planet_saturn.tscn"),
		preload("res://item/items/item_planet_uranus.tscn"),
		preload("res://item/items/item_planet_neptune.tscn"),
	], "[b]Soon after...[/b]

You have transcended your mortal existence and your microwave has guided you through the process.
Now, it is the solar system that will be microwaved."),
	Level.new(30, 1, MUSIC_SPACE, [
		preload("res://item/items/item_universe.tscn"),
		
	], "[b]The chef of the Universe[/b]

This is the final countdown.
You have become bored of your solemn existence.
Eveything around you was exposed to electromagnetic radiation.
Nothing remains.
As you contemplate your actions, you realize there is onl one thing left to do.
So you take the universe and put it on your plate.")
]

var current_level_id = 0

func _ready() -> void:
	start_level(first_level_id)
	
func start_level(level_id: int):
	current_level_id = level_id
	level_prepare.emit(current_level_id, levels[current_level_id])

func _on_button_start_pressed() -> void:
	level_start.emit(current_level_id, levels[current_level_id])

func _on_button_continue_pressed() -> void:
	if current_level_id + 1 == levels.size():
		get_tree().change_scene_to_file("res://menu/menu.tscn")
	else:
		start_level(current_level_id + 1)

func _on_timer_level_end() -> void:
	await get_tree().create_timer(2.0).timeout
	rating_start.emit()
