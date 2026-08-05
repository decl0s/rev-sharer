extends PanelContainer
class_name RevenuePanelContainer

@export var revenue_source : RevenueSourceData

const TRANSACTION_PANEL : Resource = preload("uid://3yeh41ie3hqx")

func init() -> void:
	%Name.target_resource = revenue_source
	%Description.target_resource = revenue_source
	%AddRevenueButton.parent_resource = revenue_source
	
	if not revenue_source.revenue.is_empty():
		for transaction : TransactionData in revenue_source.revenue:
			if transaction.archived == false:
				var new_panel : TransactionPanelContainer = TRANSACTION_PANEL.instantiate()
				new_panel.transaction = transaction
				%TransactionsContainer.add_child(new_panel)
	
	%Total.set_text(str(snappedf(Global.get_total_revenue(revenue_source),0.01)) + "$")
	
	if revenue_source.description.is_empty() : %Description.hide()
