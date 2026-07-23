extends Sprite2D

@export var item_name: String = ""

@export_group("Time")
@export var target: int = 30

@export_group("Sprites")
@export var raw: Texture2D
@export var done: Texture2D
@export var burnt: Texture2D
@export var particle_color: Color

var time: float = 0.
var in_microwave: bool = false

enum states {
		RAW,
		DONE,
		BURNT,
	}
var state = states.RAW

const RADIUS_PERFECT = 1
const RADIUS_OKAY = 3

func _ready() -> void:
	self.texture = raw

func enter_microwave():
	self.in_microwave = true

func leave_microwave():
	self.in_microwave = false

func score() -> int:
	if time > target - RADIUS_PERFECT and time < target + RADIUS_PERFECT:
		return 2
	elif time > target - RADIUS_OKAY and time < target + RADIUS_OKAY:
		return 1
	return 0

func _process(delta: float) -> void:
	if in_microwave:
		time += delta

	if state == states.RAW and time > target - RADIUS_OKAY:
		state = states.DONE
		self.texture = done
	elif state == states.DONE and time > target + RADIUS_OKAY:
		state = states.BURNT
		self.texture = burnt
