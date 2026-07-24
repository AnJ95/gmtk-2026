extends Node2D

signal rating_end


func _on_timer_level_end() -> void:
	await get_tree().create_timer(5).timeout
	 # TODO: Show stamps, set points flying, await button blick
	rating_end.emit()
