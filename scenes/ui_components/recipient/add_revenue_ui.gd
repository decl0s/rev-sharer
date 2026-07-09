extends VBoxContainer

@export var recipient : RecipientData

func _ready() -> void:
	%AddRevenue.pressed.connect(_on_add_revenue_pressed)
	%Confirm.pressed.connect(_on_confirm_revenue_pressed)
	%Cancel.pressed.connect(_on_cancel_revenue_pressed)
	
	Sig.rev_share_deleted_from_recipient.connect(_on_revenue_change)
	Sig.rev_share_added_to_recipient.connect(_on_revenue_change)
	Sig.revenue_source_deleted.connect(_on_revenue_change)
	Sig.revenue_source_edited.connect(_on_revenue_change)
	Sig.revenue_source_created.connect(_on_revenue_change)

func _on_revenue_change() -> void:
	if Global.get_available_shares(recipient).is_empty() == true:
		%AddRevenue.disabled = true
	else:
		%AddRevenue.disabled = false
	
	toggle_off()

var option_items : Dictionary[int,RevenueSourceData] = {
	
}

func _on_add_revenue_pressed() -> void:
	reset_inputs()
	
	var available_revenues : Array[RevenueSourceData] = Global.get_available_shares(recipient)
	
	var item_index : int = 0
	for revenue_source : RevenueSourceData in available_revenues: # Repopulate it with available
		%RevenueOption.add_item(revenue_source.name)
		option_items[item_index] = revenue_source
		item_index += 1
	
	%RevenueOption.selected = 0
	
	%AddRevenueSourceContainer.show()
	%AddRevenue.hide()

func reset_inputs() -> void:
	%RevenueOption.clear() # Reset OptionButton
	
	%RevenueOption.selected = -1
	%LayerInput.value = 1
	%PercentageShare.value = 0.0
	%StartMonthInput.value = 1
	%StartYearInput.value = 1900.0
	%EndMonthInput.value = 1
	%EndYearInput.value = 9999

func _on_confirm_revenue_pressed() -> void:
	var new_share : RecipientRevShare = RecipientRevShare.new()
	new_share.id = Global.get_next_id(Global.rev_shares)
	new_share.linked_recipient = recipient
	new_share.layer = %LayerInput.value
	new_share.revenue_source = option_items[%RevenueOption.selected]
	new_share.percentage = %PercentageShare.value * 0.01
	new_share.start_month = %StartMonthInput.value
	new_share.start_year = %StartYearInput.value
	new_share.end_month = %EndMonthInput.value
	new_share.end_year = %EndYearInput.value
	Global.add_rev_share_to_recipient(recipient,new_share)
	toggle_off()

func _on_cancel_revenue_pressed() -> void:
	toggle_off()

func toggle_off() -> void:
	%AddRevenueSourceContainer.hide()
	%AddRevenue.show()
	reset_inputs()
