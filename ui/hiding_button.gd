@tool
extends Button

@export var is_shown := false:
	set(value):
		is_shown = value
		disabled = !is_shown
		_update_position()

@export var show_position := Vector2.ZERO:
	set(value):
		show_position = value
		_update_position()

@export var hide_position := Vector2.RIGHT * 500.0:
	set(value):
		hide_position = value
		_update_position()

@export var tween_duration := 0.25

var _tween: Tween


func _ready() -> void:
	_update_position()


func show_button() -> void:
	is_shown = true
	_animate_to(show_position)


func hide_button() -> void:
	is_shown = false
	_animate_to(hide_position)


func toggle() -> void:
	is_shown = not is_shown
	_animate_to(show_position if is_shown else hide_position)


func _update_position() -> void:
	if not is_inside_tree():
		return

	position = show_position if is_shown else hide_position


func _animate_to(target_position: Vector2) -> void:
	if Engine.is_editor_hint():
		position = target_position
		return

	if _tween:
		_tween.kill()

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position", target_position, tween_duration)


func _on_pressed() -> void:
	is_shown = false
