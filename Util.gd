class_name Util

static func get_area_rect(area: Area2D) -> Rect2:
	var shape_node := area.get_node("CollisionShape2D") as CollisionShape2D
	var shape := shape_node.shape as RectangleShape2D
	var extents := shape.size * 0.5
	var center := shape_node.global_position
	return Rect2(
		center - extents,
		shape.size
	)
	
static func get_random_point_in_area(area: Area2D) -> Vector2:
	var shape_node := area.get_node("CollisionShape2D") as CollisionShape2D
	var shape := shape_node.shape as RectangleShape2D
	var extents := shape.size * 0.5
	var local_point := Vector2(
		randf_range(-extents.x, extents.x),
		randf_range(-extents.y, extents.y)
	)
	return shape_node.global_transform * local_point

static func get_random_point_outside(my_rect: Rect2, other_rect: Rect2, eps := 0.0):
	var my_center := my_rect.position + my_rect.size * 0.5
	var other_center := other_rect.position + other_rect.size * 0.5
	var my_half := my_rect.size * 0.5
	var other_half := other_rect.size * 0.5

	# Minimum center-to-center separation along each axis to avoid intersection
	var sep_x := my_half.x + other_half.x
	var sep_y := my_half.y + other_half.y

	# Safe "edge lines" for my CENTER around the other rect
	var left_x   := other_center.x - sep_x - eps
	var right_x  := other_center.x + sep_x + eps
	var top_y    := other_center.y - sep_y - eps
	var bottom_y := other_center.y + sep_y + eps

	# When choosing LEFT/RIGHT, Y can be anything within the vertical overlap band
	var y_min := other_center.y - sep_y
	var y_max := other_center.y + sep_y

	# When choosing TOP/BOTTOM, X can be anything within the horizontal overlap band
	var x_min := other_center.x - sep_x
	var x_max := other_center.x + sep_x

	match randi_range(0, 3):
		0: # left edge
			return Vector2(left_x, randf_range(y_min, y_max))
		1: # right edge
			return Vector2(right_x, randf_range(y_min, y_max))
		2: # top edge
			return Vector2(randf_range(x_min, x_max), top_y)
		3: # bottom edge
			return Vector2(randf_range(x_min, x_max), bottom_y)
	return my_center

static func move_to_closest_point_inside(my_rect: Rect2, other_rect: Rect2, eps := 0.0) -> Vector2:
	var my_center := my_rect.position + my_rect.size * 0.5
	var my_half := my_rect.size * 0.5

	var other_pos := other_rect.position
	var other_end := other_rect.position + other_rect.size

	# Valid center range so that my_rect is fully inside other_rect
	var min_x := other_pos.x + my_half.x + eps
	var max_x := other_end.x - my_half.x - eps
	var min_y := other_pos.y + my_half.y + eps
	var max_y := other_end.y - my_half.y - eps

	# Clamp current center to the valid range (closest possible point)
	return Vector2(
		clamp(my_center.x, min_x, max_x),
		clamp(my_center.y, min_y, max_y)
	)
