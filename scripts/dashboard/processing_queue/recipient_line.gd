extends VBoxContainer
class_name ProcessRecipientLine

@export var id : int
@export var is_last : bool 
@export var titles : Array[Label]
@export var bottom_divider : HSeparator
@export var recipient : RecipientData
@export var rev_source : RevenueSourceData
@export var totals_dict : Dictionary

func _ready() -> void:
	
	while recipient == null and rev_source == null:
		await get_tree().process_frame
	
	if id == 0:
		for title : Label in titles:
			title.show()
	
	if is_last : bottom_divider.hide()
	
	%RecipientName.target_resource = recipient
	
	var recipient_share : RecipientRevShare = Global.get_share(rev_source,recipient)
	
	%PreRecoupShare.set_text(Utils.get_money_string(totals_dict[recipient.id][&"recoup_share"]) + " ("+Utils.perc_str(recipient_share.recoup_percentage)+")")
	%PostRecoupShare.set_text(Utils.get_money_string(totals_dict[recipient.id][&"post_recoup_share"]) + " ("+Utils.perc_str(recipient_share.percentage)+")")
	%TotalDue.set_text(Utils.get_money_string(totals_dict[recipient.id][&"total"]))
