extends Control


func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	await move_to_page(0)
	get_tree().change_scene_to_file("res://main/Main.tscn")

func _on_howto_pressed() -> void:
	move_to_page(1)

func _on_credits_pressed() -> void:
	move_to_page(2)

func _on_quit_pressed() -> void:
	get_tree().quit()

func move_to_page(i: int):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property($Moveable, "position:y", -1080*i, 0.75)
	await tween.finished
