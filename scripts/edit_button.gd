extends HBoxContainer
class_name EditButton

@export var editable_nodes : Array[EditableInfo]

func _ready() -> void:
	%EditRecipientButton.pressed.connect(toggle_edit_mode)
	%ConfirmButton.pressed.connect(on_confirm_pressed)
	%CancelButton.pressed.connect(disable_edit)

var is_editing : bool = false
func toggle_edit_mode() -> void:
	if is_editing == false:
		is_editing = true
		for node : EditableInfo in editable_nodes:
			node.enable_editing()
		%EditingButtons.show()
		%EditRecipientButton.hide()
		return
	if is_editing == true:
		disable_edit()
		return

func disable_edit() -> void:
	for node : EditableInfo in editable_nodes:
		node.disable_editing()
	%EditingButtons.hide()
	%EditRecipientButton.show()
	is_editing = false

func on_confirm_pressed() -> void:
	for node : EditableInfo in editable_nodes:
		node.update_property()
	disable_edit()
