extends Button
class_name PopUpCreator

@export var node_to_pop_up : Resource
@export var parent_resource : Resource

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	Utils.create_pop_up(node_to_pop_up, parent_resource)
