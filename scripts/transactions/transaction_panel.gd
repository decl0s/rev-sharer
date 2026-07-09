extends PanelContainer
class_name TransactionPanelContainer

@export var transaction : TransactionData

func _on_deletion_requested() -> void:
	Global.delete_data(transaction)

func init() -> void:
	%Name.target_resource = transaction
	%Description.target_resource = transaction
	%EditableMoney.target_resource = transaction
	toggle_hide_desc()

func toggle_hide_desc() -> void:
	if transaction.description != "":
		%Description.show()
	else:
		%Description.hide()

func _on_edit_button_started_editing() -> void:
	%Description.show()

func _on_edit_button_ended_editing() -> void:
	toggle_hide_desc()
