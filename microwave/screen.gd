@tool
extends Node2D 

@onready var viewport: SubViewport = $SubViewport
@onready var polygon: Polygon2D = $Polygon2D

func _ready():
	polygon.texture = viewport.get_texture()

	polygon.uv = PackedVector2Array([
		Vector2(0, 0),
		Vector2(0, 440),
		Vector2(810, 440),
		Vector2(810, 0),
	])
	
func show_text(text: String):
	$SubViewport/MarginContainer/RichTextLabel.text = text
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 1, 0.35)

func hide_text():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate:a", 0, 0.35)
	
