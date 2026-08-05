extends Node

func get_rounded_amount(value : float) -> float: ## Returns a snapped float to 2 decimals.
	return snappedf(value,0.01)

func get_money_string(value : float) -> String: ## Returns a formatted money string. eg: 104.34$
	return str(get_rounded_amount(value)) + Global.settings.currency_symbol

func perc_str(value : float) -> String: ## Returns a string of the percentage from a float. Eg: 0.15 = 15%
	return str(value * 100)+"%"

func get_schedule_string(schedule : RevenueSourceData.Schedule) -> String:
	match schedule:
		RevenueSourceData.Schedule.Monthly:
			return tr("REV_MONTHLY")
		RevenueSourceData.Schedule.Quarterly:
			return tr("REV_QUARTERLY")
		RevenueSourceData.Schedule.Yearly:
			return tr("REV_YEARLY")
		_:
			return "Error"

func create_pop_up(pop_up_to_instantiate : Resource, parent : Resource) -> void:
	var new_node : Node = pop_up_to_instantiate.instantiate()
	new_node.parent_resource = parent
	get_node("/root/Main/CanvasLayer/PopUpContainer").add_child(new_node)
	get_node("/root/Main/CanvasLayer/PopUpContainer").show()

func disable_overlay() -> void:
	get_node("/root/Main/CanvasLayer/PopUpContainer").hide()
