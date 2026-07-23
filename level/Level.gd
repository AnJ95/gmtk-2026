class_name Level

var total_time: int
var num_microwave_slots: int
var shelf_items: Array[PackedScene]

func _init(total_time: int, num_microwave_slots: int, shelf_items: Array[PackedScene]) -> void:
	self.total_time = total_time
	self.num_microwave_slots = num_microwave_slots
	self.shelf_items = shelf_items
