extends Node

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

func create_pop_up(pop_up_to_instantiate : Resource) -> void:
	var new_node : Node = pop_up_to_instantiate.instantiate()
	get_node("/root/Main/CanvasLayer/PopUpContainer").add_child(new_node)
	get_node("/root/Main/CanvasLayer/PopUpContainer").show()

func disable_overlay() -> void:
	get_node("/root/Main/CanvasLayer/PopUpContainer").hide()
