extends Node2D

const MICROWAVE: bool = false
var item_scene: PackedScene
var current_item: Node2D

func _ready() -> void:
	assert(item_scene != null, "ShelfSlot needs item_scene")
	current_item = item_scene.instantiate() as Node2D
	add_child(current_item)
	current_item.get_node("Draggable").drag_drop($Droppable)
	$VBoxContainer/LabelItemName.text = current_item.item_name
	$VBoxContainer/LabelItemTime.text = "%ds" % current_item.target
	
	
	current_item.heat_death.connect(get_parent().get_parent()._on_death_death)

func can_accept_draggable(draggable: Draggable) -> bool:
	return draggable.root == current_item

func set_active(active: bool):
	current_item.set_draggable(active)
	
func move_item_back_to_shelf():
	current_item.get_node("Draggable").drag_drop($Droppable)

func show_rating():
	current_item.show_rating()
