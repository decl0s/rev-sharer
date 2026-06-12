extends Control

func _ready() -> void:
	repopulate_recipients()
	
	Sig.recipient_created.connect(repopulate_recipients)
	Sig.recipient_deleted.connect(repopulate_recipients)

const RECIPIENT_PANEL : Resource = preload("uid://drpajrjjw8av6")

func repopulate_recipients() -> void:
	for child : Node in %RecipientContainer.get_children() :
		if child is RecipientPanelContainer:
			child.queue_free()
	populate_recipients()
	
	if Global.recipients.is_empty() == true:
		%NoRecipientsLabel.show()
		%ScrollContainer.hide()
	else:
		%NoRecipientsLabel.hide()
		%ScrollContainer.show()

func populate_recipients() -> void:
	for recipient : RecipientData in Global.recipients:
		var new_recipient : RecipientPanelContainer = RECIPIENT_PANEL.instantiate()
		new_recipient.recipient = recipient
		new_recipient.init()
		%RecipientContainer.add_child(new_recipient)
