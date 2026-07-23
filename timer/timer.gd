extends Sprite2D

@export var level_time: int = 60

func _ready() -> void:
	$Label.visible_characters = 22

	set_timer(90)

func set_timer(t: int):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property($Label, "visible_characters", 22 + t , 2)

func _process(delta: float) -> void:
	pass
