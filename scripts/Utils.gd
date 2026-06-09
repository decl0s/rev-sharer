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
