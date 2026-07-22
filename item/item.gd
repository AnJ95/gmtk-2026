extends Sprite2D

@export_group("Time")
@export var goal: int = 30
@export var max: int = 40

@export_group("Sprites")
@export var raw: Texture2D
@export var done: Texture2D
@export var burnt: Texture2D
@export var particle_color: Color

var time: int = 0
var in_microwave: bool = false

enum states {
		RAW,
		DONE,
		BURNT,
	}
var state = states.RAW

const THRESHOLD = 1

func _ready() -> void:
	self.texture = raw

func enter_microwave():
	self.in_microwave = true

func leave_microwave():
	self.in_microwave = false

func go_kaputt():
	queue_free()

func _process(delta: float) -> void:
	if in_microwave:
		time += delta

	if state == states.RAW and time > goal - THRESHOLD:
		state = states.DONE
		self.texture = done
	elif state == states.DONE and time > goal + THRESHOLD:
		state = states.BURNT
		self.texture = burnt
	elif state == states.BURNT and time > max:
		go_kaputt()
