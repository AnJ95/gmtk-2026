extends Sprite2D

signal level_start(level: Level)
signal level_end()

@export_category("Sound")
@export var ticks: Array[AudioStream]

var time: float = 0
var tick_counter: int = 0
var is_counting: bool = false

func set_timer(t: int):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "time", t , 4)
	await tween.finished
	is_counting = true
	$music_test.play()

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
	elif is_counting and time < 0:
		$ring.play()
		is_counting = false
		$music_test.stop()
		$AnimationPlayer.play("ring")
		level_end.emit()


func _on_level_manager_level_prepare(level: Level) -> void:
	await set_timer(level.total_time)
	level_start.emit(level)
