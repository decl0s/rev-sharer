extends VBoxContainer
class_name EditableInfo

@export var target_resource : Resource ## Targeted resource that this editable field gets and sets.
@export var target_property : String ## Targeted resource property that this field gets and sets.
@export var target_enum : StringName ## Used for optionbuttons as a source of the list of option it creates.

@export var is_input_only : bool ## Set this to true if meant to be used as an input for new resources.

@export var label_node : Node ## The label node that displays information.
@export var input_field : Node ## The input field that is used to input new information.

@export var prefix : String
@export var suffix : String

func _ready() -> void:
	call_deferred("update_labels_and_inputs")

func set_property(new_value : Variant) -> void:
	if new_value == null: 
		push_error("Edited value is null, cannot update resource.") 
		return
	if target_resource is RecipientData:
		if is_input_only == false:
			Global.recipients[Global.get_recipient_index(target_resource)].set(target_property, new_value)
			print("Updated : ", target_property ," to ", str(new_value) ," for Recipient : ", target_resource.name)
			Sig.edit_recipient()
		else:
			target_resource.set(target_property,new_value)
			print(target_property," ",new_value)
	if target_resource is RevenueSourceData:
		if is_input_only == false:
			Global.revenue_sources[Global.get_revenue_source_index(target_resource)].set(target_property, new_value)
			print("Updated : ", target_property ," to ", str(new_value) ," for Revenue Source : ", target_resource.name)
			Sig.edit_revenue_source()
		else:
			target_resource.set(target_property,new_value)
			print(target_property," ",new_value)

func get_value() -> Variant:
	return Global.recipients[Global.get_recipient_index(target_resource)].get(target_property)

func get_new_value() -> Variant:
	if input_field is LineEdit:
		return input_field.text
	if input_field is SpinBox:
		return input_field.value
	if input_field is OptionButton:
		return option_items[input_field.selected]
	return null

func update_property() -> void:
	set_property(get_new_value())

var option_items : Dictionary[int,Variant] = {}

func update_labels_and_inputs() -> void:
	if input_field is LineEdit and is_input_only == false:
		input_field.text = get_value()
	if input_field is SpinBox and is_input_only == false:
		input_field.value = get_value()
	if input_field is OptionButton :
		
		input_field.clear()
		var item_index : int = 0
		print(target_resource.get_script().get_script_constant_map())
		for option : Variant in target_resource.get_script().get_script_constant_map()[target_enum].values() : # Repopulate it with available
			if target_enum == &"Schedule" :
				input_field.add_item(Utils.get_schedule_string(option))
			else:
				input_field.add_item(option)
			option_items[item_index] = option
			item_index += 1
			
		input_field.selected = 0
	
	if is_input_only == false:
		label_node.text = prefix + str(get_value()) + suffix
	
	if is_input_only == true:
		label_node.hide()
		input_field.show()
	else:
		label_node.show()
		input_field.hide()

func enable_editing() -> void:
	update_labels_and_inputs()
	input_field.show()
	label_node.hide()

func disable_editing() -> void:
	update_labels_and_inputs()
	input_field.hide()
	label_node.show()
