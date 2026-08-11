extends PanelContainer
class_name ProcessRevSourcePanel

@export var rev_source : RevenueSourceData

const RECIPIENTS_LAYER_CONTAINER : Resource = preload("uid://cyw43f6ukjkld")

func _ready() -> void:
	while rev_source == null:
		await get_tree().process_frame
	
	%RevenueName.target_resource = rev_source
	
	var layer_to_recipients: Dictionary[int, Array] = {}

	for recipient: RecipientData in Global.get_recipients_linked_to_rev(rev_source):
		var layer: int = recipient.shares[rev_source.id].layer
		var arr: Array = layer_to_recipients.get_or_add(layer, [])
		arr.append(recipient)
	
	for layer : int in layer_to_recipients.keys():
		var layer_container : ProcessLayerContainer = RECIPIENTS_LAYER_CONTAINER.instantiate()
		layer_container.layer = layer
		layer_container.layer_recipients.assign(layer_to_recipients[layer])
		layer_container.rev_source = rev_source
		%LevelsContainer.add_child(layer_container)
	
	var unprocessed_totals : Dictionary = Global.get_unprocessed_revenue_dict(rev_source)
	var total_due : float = unprocessed_totals[-1][&"pre_recoup_total"] + unprocessed_totals[-1][&"post_recoup_total"]
	
	%TotalUnprocessed.set_text(Utils.get_money_string(Global.get_unprocessed_total(rev_source)))
	%TotalDue.set_text((Utils.get_money_string(total_due)))
	%Leftover.set_text((Utils.get_money_string(unprocessed_totals[-1][&"leftover"])))

func _on_mark_processed_pressed() -> void:
	for recipient : RecipientData in Global.get_recipients_linked_to_rev(rev_source):
		for revenue : RevenueData in rev_source.revenue.values() :
			if revenue.is_processed == false and revenue.archived == false:
				var new_payment : PaymentData = PaymentData.new()
				new_payment.recipient = recipient
				new_payment.rev_source = rev_source
				new_payment.transaction = revenue.transaction
				Global.create_data(new_payment)
				revenue.is_processed = true
	queue_free()
