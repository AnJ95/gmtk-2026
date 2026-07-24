extends Node2D

var points: int = 0

func _on_level_manager_level_prepare(level_id: int, level: Level) -> void:
	if level_id > 0:
		$AnimationPlayer.play("playing")

func _on_timer_level_end() -> void:
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("scoring")

func _process(delta: float) -> void:
	$points.text = str(points)

func score(p: int):
	points += p
