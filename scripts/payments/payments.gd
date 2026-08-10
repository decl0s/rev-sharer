extends Control

func _ready() -> void:
	repopulate_payments()
	
	Sig.revenue_source_deleted.connect(repopulate_payments)
	Sig.revenue_source_created.connect(repopulate_payments)
	Sig.rev_share_modified.connect(repopulate_payments)
	Sig.rev_share_added_to_recipient.connect(repopulate_payments)
	Sig.rev_share_deleted_from_recipient.connect(repopulate_payments)
	Sig.recoup_created.connect(repopulate_payments)
	Sig.recoup_edited.connect(repopulate_payments)
	Sig.recoup_deleted.connect(repopulate_payments)
	Sig.transaction_created.connect(repopulate_payments)
	Sig.transaction_edited.connect(repopulate_payments)
	Sig.transaction_deleted.connect(repopulate_payments)
	Sig.revenue_created.connect(repopulate_payments)
	Sig.revenue_edited.connect(repopulate_payments)
	Sig.revenue_deleted.connect(repopulate_payments)
	Sig.payment_created.connect(repopulate_payments)
	Sig.payment_edited.connect(repopulate_payments)
	Sig.payment_deleted.connect(repopulate_payments)
	Sig.paid_payment.connect(repopulate_payments)

@onready var empty_label: Label = %EmptyLabel
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var container : VBoxContainer = %DataContainer

func repopulate_payments() -> void:
	for child : Node in container.get_children() :
		if child is RevenuePanelContainer:
			child.queue_free()
	populate_recipient_payments()
	
	if Global.get_available_revenue_sources().is_empty() == true:
		empty_label.show()
		scroll_container.hide()
	else:
		empty_label.hide()
		scroll_container.show()

const RECIPIENT_PAYMENT_PANEL_CONTAINER : Resource = preload("uid://pp8t7wvhwf6a")

func populate_recipient_payments() -> void:
	for recipient : RecipientData in Global.recipients.values():
		if recipient.archived == true: # Don't instantiate if archived.
			continue
		var new_recipient_revenue_panel : RecipientPaymentPanelContainer = RECIPIENT_PAYMENT_PANEL_CONTAINER.instantiate()
		new_recipient_revenue_panel.recipient = recipient
		container.add_child(new_recipient_revenue_panel)
		
		if not new_recipient_revenue_panel.is_node_ready():
			await new_recipient_revenue_panel.ready
		new_recipient_revenue_panel.init()
