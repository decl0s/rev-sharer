extends Control
class_name CreationPopUp

@export var resource_type : Resource
@export var inputs : Array[EditableInfo]
@export var required_inputs : Array[EditableInfo]

var new_resource : Resource

func _ready() -> void:
	%AddButton.pressed.connect(on_create)
	%Cancel.pressed.connect(on_cancel)
	
	for input : EditableInfo in required_inputs:
		if input.input_field is LineEdit:
			input.input_field.text_changed.connect(_on_text_changed)
	init()

func _on_text_changed(str : String) -> void:
	for input : EditableInfo in required_inputs:
		if input.input_field is LineEdit and input.input_field.text != "" :
			input.input_field.modulate = "ffffff"

func init() -> void:
	new_resource = resource_type.duplicate(true)
	for node : EditableInfo in inputs:
		node.target_resource = new_resource

func create_new_resource() -> void:
	for node : EditableInfo in inputs: # Pull info from inputs.
		node.update_property()
	
	#Create and append data
	Global.create_resource(new_resource)


func all_inputs_filled() -> bool:
	for input : EditableInfo in required_inputs:
		if input.input_field is LineEdit and input.input_field.text == "" :
			input.input_field.modulate = Colors.red_tint
			return false
	return true

func on_create() -> void:
	if all_inputs_filled() == true:
		create_new_resource()
		Utils.disable_overlay()
		queue_free()

func on_cancel() -> void:
	Utils.disable_overlay()
	queue_free()
