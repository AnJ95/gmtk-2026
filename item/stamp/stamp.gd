extends Sprite2D

@export var stamps: Array[Texture2D]
@export var sounds: Array[AudioStream]
@export var colors: Array[Color]

var sound_count: int

func _ready() -> void:
	self.visible = false
	sound_count = randi_range(0, 2)
	$bam.stream = sounds[sound_count]

func stamp(rating: int):
	$bam.play()
	self.texture = stamps[rating]
	self.visible = true
	splash(rating)

func splash(rating: int):
	$particles.texture.gradient.set_color(0, colors[rating])
	$particles.emitting = true
