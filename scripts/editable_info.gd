extends VBoxContainer
class_name EditableInfo

@export var target_resource : Resource ## Targeted resource that this editable field gets and sets.
@export var target_property : String ## Targeted resource property that this field gets and sets.

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
		Global.recipients[Global.get_recipient_index(target_resource)].set(target_property, new_value)
		print("Updated : ", target_property ," to ", str(new_value) ," for Recipient : ", target_resource.name)
		Sig.edit_recipient()
	if target_resource is RevenueSourceData:
		Global.revenue_sources[Global.get_revenue_source_index(target_resource)].set(target_property, new_value)
		print("Updated : ", target_property ," to ", str(new_value) ," for Revenue Source : ", target_resource.name)
		#Sig.edit_recipient() #TODO: EDIT REVENUE

func get_value() -> Variant:
	return Global.recipients[Global.get_recipient_index(target_resource)].get(target_property)

func get_new_value() -> Variant:
	if input_field is LineEdit:
		return input_field.text
	if input_field is SpinBox:
		return input_field.value
	return null

func update_property() -> void:
	set_property(get_new_value())

func update_labels_and_inputs() -> void:
	if input_field is LineEdit:
		input_field.text = get_value()
	if input_field is SpinBox:
		input_field.value = get_value()
	label_node.text = prefix + str(get_value()) + suffix

func enable_editing() -> void:
	update_labels_and_inputs()
	input_field.show()
	label_node.hide()

func disable_editing() -> void:
	update_labels_and_inputs()
	input_field.hide()
	label_node.show()
