extends PanelContainer
class_name RecoupPanelContainer

@export var revenue_source : RevenueSourceData

const TRANSACTION_PANEL : Resource = preload("uid://3yeh41ie3hqx")

func init() -> void:
	%Name.target_resource = revenue_source
	%Description.target_resource = revenue_source
	
	if not revenue_source.recoup.transactions.is_empty():
		for transaction : TransactionData in revenue_source.recoup.transactions:
			var new_panel : TransactionPanelContainer = TRANSACTION_PANEL.instantiate()
			new_panel.transaction = transaction
			%TransactionsContainer.add_child(new_panel)
