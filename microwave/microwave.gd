extends Node2D

const Slot = preload("res://microwave/slot/microwave_slot.tscn")

@onready var sprite_door_closed = $AnimationRoot/MicrowaveDoorClosed
@onready var sprite_door_half = $AnimationRoot/MicrowaveDoorHalf
@onready var sprite_door_open = $AnimationRoot/MicrowaveDoorOpen
@onready var inner_root = $AnimationRoot/InnerRoot

@export var slot_num := 3
@export var slot_radius := Vector2(220, 75)
@export var slot_rotation_speed = TAU / 8.0

var current_runtime = 0
var is_open = false
var is_running = false

func spawn_slots() -> void:
	for child in inner_root.get_children():
		child.queue_free()

	for i in range(slot_num):
		var instance := Slot.instantiate() as Node2D
		instance.position = calc_pos_at(i, 0)
		inner_root.add_child(instance)

func calc_pos_at(i: int, time: float):
	var angle_step := TAU / slot_num
	return Vector2.from_angle(angle_step * i + time * slot_rotation_speed) * slot_radius

func _process(delta: float) -> void:
	if is_running:
		current_runtime += delta
		for i in inner_root.get_child_count():
			inner_root.get_child(i).position = calc_pos_at(i, current_runtime)


func _on_level_manager_level_prepare(level: Level) -> void:
	slot_num = level.num_microwave_slots
	spawn_slots()
	
func _on_timer_level_start(level: Level) -> void:
	is_running = true

func set_open_state(new_open_state: bool):
	if is_open != new_open_state:
		is_open = new_open_state
		$AnimationPlayerDoor.play("open" if new_open_state else "close")

func _on_mouse_hover_area_2d_mouse_entered() -> void:
	set_open_state(true)

func _on_mouse_hover_area_2d_mouse_exited() -> void:
	set_open_state(false)
