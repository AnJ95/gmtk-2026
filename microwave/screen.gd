@tool
extends Node2D 

@onready var viewport: SubViewport = $SubViewport
@onready var polygon: Polygon2D = $Polygon2D
@onready var label: RichTextLabel = $SubViewport/MarginContainer/RichTextLabel

const TIME_PER_CHARACTER = 0.01

func _ready():
	polygon.texture = viewport.get_texture()

	polygon.uv = PackedVector2Array([
		Vector2(0, 0),
		Vector2(0, 440),
		Vector2(810, 440),
		Vector2(810, 0),
	])
	
func show_text(text: String):
	label.text = text
	label.visible_characters = 0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1, 0.75)
	var char_count = label.get_total_character_count()
	tween.tween_property(label, "visible_characters", char_count, TIME_PER_CHARACTER * char_count)

func hide_text():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0, 0.75)
	
