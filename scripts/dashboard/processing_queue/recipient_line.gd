extends VBoxContainer
class_name ProcessRecipientLine

@export var id : int
@export var is_last : bool 
@export var titles : Array[Label]
@export var bottom_divider : HSeparator
@export var recipient : RecipientData
@export var rev_source : RevenueSourceData

func _ready() -> void:
	
	while recipient == null and rev_source == null:
		await get_tree().process_frame
	
	if id == 1:
		for title : Label in titles:
			title.show()
	
	if is_last : bottom_divider.hide()
	
	%RecipientName.target_resource = recipient
	
	var recipient_dict : Dictionary = Global.get_unprocessed_revenue_dict(rev_source)
	var layer : int = Global.get_share(rev_source, recipient).layer

	%PreRecoupShare.set_text(Utils.get_money_string(recipient_dict[layer][recipient.id][&"pre_recoup"]))
	%PostRecoupShare.set_text(Utils.get_money_string(recipient_dict[layer][recipient.id][&"post_recoup"]))
	%TotalDue.set_text(Utils.get_money_string(recipient_dict[layer][recipient.id][&"total"]))
