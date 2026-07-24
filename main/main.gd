extends Node2D

var points: int = 0

func _on_level_manager_level_prepare(level_id: int, level: Level) -> void:
	$AnimationPlayer.play("playing", -1, 100 if level_id == 0 else 1)

func _on_timer_level_prepared(level_id: int, level: Level) -> void:
	$ButtonStart.is_shown = true
	
func _on_timer_level_end() -> void:
	pass

func _on_level_manager_rating_start() -> void:
	$AnimationPlayer.play("scoring")
	
func _on_shelf_rating_end() -> void:
	$ButtonContinue.is_shown = true
	
func _process(delta: float) -> void:
	$points.text = str(points)

func score(p: int):
	points += p
