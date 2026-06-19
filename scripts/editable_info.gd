extends VBoxContainer
class_name EditableInfo

@export var target_resource : Resource ## Targeted resource that this editable field gets and sets.

@export var target_property : String ## Targeted resource property that this field gets and sets.

@export var target_enum : StringName ## Used for optionbuttons as a source of the list of option it creates.

@export var is_input_only : bool ## Set this to true if meant to be used as an input for new resources.

@export var prefix : String ## Adds a prefix to the label.
@export var suffix : String ## Adds a suffix to the label.

@export_group("Highlight Panels")
@export var use_highlight_panel : bool 
@export var highlight_color : HighlightContainer.ColorStyle

@export_group("Linked Nodes")
@export var highlight_container : HighlightContainer ## The HighlightContainer label node that displays information.
@export var label_node : Node ## The label node that displays information.
@export var input_field : Node ## The input field that is used to input new information.

var target_subclass : Resource

func _ready() -> void:
	call_deferred("update_labels_and_inputs")

func set_property(new_value : Variant) -> void:
	if new_value == null: 
		push_error("Edited value is null, cannot update resource.") 
		return
	if target_resource is RecipientData:
		if is_input_only == false:
			Global.recipients[target_resource.id].set(target_property,new_value) #FIXME: NOT UPDATING
			print("Updated : ", target_property ," to ", str(new_value) ," for Recipient : ", target_resource.name)
			Sig.edit_recipient()
		else:
			target_resource.set(target_property,new_value)
			print(target_property," ",new_value)
	if target_resource is RevenueSourceData:
		if is_input_only == false:
			Global.revenue_sources[target_resource.id].set(target_property,new_value)
			print("Updated : ", target_property ," to ", str(new_value) ," for Revenue Source : ", target_resource.name)
			Sig.edit_revenue_source()
		else:
			target_resource.target_subclass.set(target_property,new_value)
			print(target_property," ",new_value)

func get_value() -> Variant:
	if target_resource is RecipientData:
		var recipient : RecipientData = Global.recipients[target_resource.id]
		return recipient.get(target_property)
	
	if target_resource is RevenueSourceData:
		var revenue_source : RevenueSourceData = Global.revenue_sources[target_resource.id]
		return revenue_source.get(target_property)
	
	if target_resource is RecipientRevShare:
		var rev_share : RecipientRevShare = Global.recipients[target_resource.linked_recipient.id].shares[target_resource.id]
		return rev_share.get(target_property)
	
	push_error("Couldn't match target resource to implemented data source.")
	return null

func get_new_value() -> Variant:
	if input_field is LineEdit:
		return input_field.text
	if input_field is SpinBox:
		if input_field.suffix == "%":
			return input_field.value * 0.01
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
		if suffix == "%":
			input_field.value = get_value() * 0.01
	if input_field is OptionButton :
		
		input_field.clear()
		var item_index : int = 0
		#print(target_resource.get_script().get_script_constant_map())
		for option : Variant in target_resource.get_script().get_script_constant_map()[target_enum].values() : # Repopulate it with available
			if target_enum == &"Schedule" :
				input_field.add_item(Utils.get_schedule_string(option))
			else:
				input_field.add_item(option)
			option_items[item_index] = option
			item_index += 1
			
		input_field.selected = 0
	
	if input_field is OptionButton:
		if target_enum == &"Schedule":
			var display_str : String = Utils.get_schedule_string(target_resource.payout_schedule)
			label_node.text = prefix + display_str + suffix
			highlight_container.label.text = prefix + display_str + suffix

	if is_input_only == false and not (input_field is OptionButton):
		label_node.text = prefix + str(get_value()) + suffix
		highlight_container.label.text = prefix + str(get_value()) + suffix
		if input_field is SpinBox and suffix == "%":
			label_node.text = prefix + str(get_value() * 100) + suffix
			highlight_container.text = prefix + str(get_value() * 100) + suffix #FIXME: LABELS NOT CORRECTLY SHOWING PERCENTAGE
	
	if is_input_only == true:
		label_node.hide()
		highlight_container.hide()
		input_field.show()
	else:
		if use_highlight_panel == true:
			label_node.hide()
			highlight_container.show()
		if use_highlight_panel == false:
			label_node.show()
			highlight_container.hide()
		input_field.hide()
	
	highlight_container.color = highlight_color
	highlight_container.update_colors()

func enable_editing() -> void:
	update_labels_and_inputs()
	input_field.show()
	label_node.hide()
	highlight_container.hide()

func disable_editing() -> void:
	update_labels_and_inputs()
	input_field.hide()
	if use_highlight_panel == true:
		label_node.hide()
		highlight_container.show()
	if use_highlight_panel == false:
		label_node.show()
		highlight_container.hide()
