@tool
extends Node2D

signal heat_death

@export var item_name: String = ""
@export_group("Time")
@export var target: int = 30
@export_group("Sprites")
@export var raw: Texture2D:
	set(value):
		raw = value
		_set_sprite_texture(raw)

@export var done: Texture2D
@export var burnt: Texture2D
@export var particle_color: Color
@export_group("Effects")
@export var floating := false
@export var do_heat_death := false

@onready var sprite: Sprite2D = $Sprite2D

const Stamp = preload("res://item/stamp/stamp.tscn")

var time: float = 0.0
var in_microwave: bool = false

enum States {
	RAW,
	DONE,
	BURNT,
}

var state: States = States.RAW
const RADIUS_PERFECT := 1
const RADIUS_OKAY := 3
var main: Node

func _ready() -> void:
	_set_sprite_texture(raw)
	$explosion.texture.gradient.set_color(0, particle_color)
	main = get_tree().root.get_node("Main")
	if floating:
		$AnimationPlayer.play("float")
		var length = $AnimationPlayer.get_animation("float").length
		$AnimationPlayer.seek(randf_range(0.0, length), true)

func _set_sprite_texture(texture: Texture2D) -> void:
	var sprite_node := $Sprite2D as Sprite2D
	if sprite_node:
		sprite_node.texture = texture

func show_rating():
	var stamp = Stamp.instantiate()
	add_child(stamp)
	stamp.stamp(rating())
	score()

func rating() -> int:
	if time < target - RADIUS_OKAY:
		return 0
	elif time > target + RADIUS_OKAY:
		return 4
	elif time < target - RADIUS_PERFECT:
		return 1
	elif time > target + RADIUS_PERFECT:
		return 3
	return 2

func score():
	var sco = 2 - abs(2 - rating())
	main.score(sco)

func _process(delta: float) -> void:
	# Prevent the cooking logic from running inside the editor.
	if Engine.is_editor_hint():
		return

	if in_microwave:
		time += delta

	if state == States.RAW and time > target - RADIUS_OKAY:
		state = States.DONE
		sprite.texture = done
		$explosion.emitting = true
		if do_heat_death:
			play_animation_heat_death()
	elif state == States.DONE and time > target + RADIUS_OKAY:
		state = States.BURNT
		sprite.texture = burnt
		$explosion.emitting = true
		$smoke.emitting = true

func _on_draggable_dropped(droppable: Droppable) -> void:
	if droppable.root.MICROWAVE:
		in_microwave = true
	else:
		in_microwave = false

func set_draggable(draggable: bool):
	$Draggable.set_enabled(draggable)

func play_animation_heat_death():
	$AnimationPlayer.play("heat_death")
	heat_death.emit()
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://menu/menu.tscn")
