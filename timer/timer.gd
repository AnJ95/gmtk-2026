extends Sprite2D

@export var level_time: int = 20

@export_category("Sound")
@export var ticks: Array[AudioStream]

var time: float = 0
var tick_counter: int = 0
var is_counting: bool = true

func _ready() -> void:
	tick()
	set_timer(level_time)

func set_timer(t: int):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "time", t , 4)

func tick():
	$Label.visible_characters = int(self.time) + 22
	$tick.stream = ticks[tick_counter]
	$tick.play()
	tick_counter = (tick_counter + 1) % len(ticks)
	$AnimationPlayer.play("shake")

func _process(delta: float) -> void:
	if $Label.visible_characters != int(time) + 22:
		tick()

	if is_counting and time >= 0:
		time -= delta
