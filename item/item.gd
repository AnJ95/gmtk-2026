@tool
extends Node2D

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
@onready var sprite: Sprite2D = $Sprite2D

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

func _ready() -> void:
	_set_sprite_texture(raw)
	$explosion.texture.gradient.set_color(0, particle_color)

func _set_sprite_texture(texture: Texture2D) -> void:
	var sprite_node := $Sprite2D as Sprite2D
	if sprite_node:
		sprite_node.texture = texture

func score() -> int:
	if time > target - RADIUS_PERFECT and time < target + RADIUS_PERFECT:
		return 2
	elif time > target - RADIUS_OKAY and time < target + RADIUS_OKAY:
		return 1
	return 0

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
	elif state == States.DONE and time > target + RADIUS_OKAY:
		state = States.BURNT
		sprite.texture = burnt
		$explosion.emitting = true
		$smoke.emitting = true

func _on_draggable_dropped(droppable: Droppable) -> void:
	if droppable.root.MICROWAVE:
		in_microwave = true
