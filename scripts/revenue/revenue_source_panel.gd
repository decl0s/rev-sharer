extends PanelContainer
class_name RevenueSourcePanelContainer

@export var revenue : RevenueSourceData

func _on_deletion_requested() -> void:
	Global.delete_data(revenue)

func init() -> void:
	%RevenueSourceName.target_resource = revenue
	%Schedule.target_resource = revenue
	%EditableDescription.target_resource = revenue
	%AllocatedPercentage.text = Utils.perc_str(Global.get_allocated_percentage(revenue))
	toggle_hide_desc()

func toggle_hide_desc() -> void:
	if revenue.description != "":
		%EditableDescription.show()
	else:
		%EditableDescription.hide()

func _on_edit_button_started_editing() -> void:
	%EditableDescription.show()

func _on_edit_button_ended_editing() -> void:
	toggle_hide_desc()
