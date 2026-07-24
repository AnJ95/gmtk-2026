extends Node2D

signal rating_end

const Slot = preload("res://shelf/slot/shelf_slot.tscn")
@export var end_position = Vector2.ZERO
@onready var root = self

func spawn_slots(items: Array[PackedScene]) -> void:
	for child in root.get_children():
		child.queue_free()

	for i in range(items.size()):
		var instance := Slot.instantiate() as Node2D
		instance.position = end_position * (i / float(items.size()))
		instance.item_scene = items[i]
		root.add_child(instance)
		instance.call_deferred("set_active", false)

func _on_level_manager_level_prepare(level: Level) -> void:
	spawn_slots(level.shelf_items)
	
func _on_timer_level_start(level: Level) -> void:
	for slot in root.get_children():
		slot.set_active(true)

func _on_timer_level_end() -> void:
	for slot in root.get_children():
		slot.set_active(false)
		slot.move_item_back_to_shelf()
	
	await get_tree().create_timer(2).timeout
	
	for slot in root.get_children():
		slot.show_rating()
		await get_tree().create_timer(2).timeout
	
	rating_end.emit()
	
	
	
