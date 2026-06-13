extends PanelContainer
class_name RecipientPanelContainer

@export var recipient : RecipientData

var recipient_index : int

func _ready() -> void:
	recipient_index = Global.recipients.find(recipient)
	
	%DeleteRecipientButton.pressed.connect(_on_delete_recipient_pressed)
	%delete_recipient_reset.timeout.connect(_on_delete_recipient_reset_timeout)
	
	%NameLabel.target_resource = recipient
	%MinimumPayment.target_resource = recipient
	
	Sig.revenue_deleted_from_recipient.connect(repopulate_revenues)
	Sig.revenue_added_to_recipient.connect(repopulate_revenues)


func init() -> void: ## Initializes the recipient panel.
	%AddRevenue.recipient = recipient
	repopulate_revenues()

func _on_min_payout_value_changed() -> void:
	Global.recipients[recipient_index].minimum_payout = %MinimumAmountEdit.value

#region Delete Recipient Button Logic
var want_to_delete_recipient : bool = false
func _on_delete_recipient_pressed() -> void:
	if want_to_delete_recipient == false:
		%DeleteRecipientButton.modulate = Color("ff8c8c")
		want_to_delete_recipient = true
		%delete_recipient_reset.start()
		return
	if want_to_delete_recipient == true:
		reset_delete_recipient_state()
		Global.delete_recipient(recipient)

func _on_delete_recipient_reset_timeout() -> void:
	reset_delete_recipient_state()

func reset_delete_recipient_state() -> void:
	%DeleteRecipientButton.modulate = Color("fff")
	want_to_delete_recipient = false
#endregion

const REVENUE_SOURCE_LINE : Resource = preload("uid://cbu0r3xa05npi")

func repopulate_revenues() -> void:
	for child : Node in %RevenueSourceContainer.get_children(): # Remove revenue lines.
		if child is RecipientRevenueLineUI:
			%RevenueSourceContainer.remove_child(child)
	
	for rev_share : RecipientRevShare in recipient.shares : # Repopulate Lines
		var revenue_line : RecipientRevenueLineUI = REVENUE_SOURCE_LINE.instantiate()
		revenue_line.recipient = recipient
		revenue_line.recipient_rev_share = rev_share
		revenue_line.update_labels()
		%RevenueSourceContainer.add_child(revenue_line)
