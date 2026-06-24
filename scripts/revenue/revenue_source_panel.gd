extends PanelContainer
class_name RevenueSourcePanelContainer

@export var revenue : RevenueSourceData

func _on_deletion_requested() -> void:
	Global.delete_revenue_source(revenue)

func init() -> void:
	%RevenueSourceName.target_resource = revenue
	%AllocatedPercentage.text = Utils.perc_str(Global.get_allocated_percentage(revenue))
