extends HBoxContainer
class_name RecipientRevenueLineUI

@export var recipient : RecipientData
@export var recipient_rev_share : RecipientRevShare

var show_titles : bool

var titles : Array[Label]
var editable_infos : Array[EditableInfo]

func _ready() -> void:
	%DeleteSourceButton.pressed.connect(_on_delete_revenue_pressed)
	%DeleteRevSourceReset.timeout.connect(_on_delete_share_reset_timeout)
	titles = [$SourceName/SourceNameTitle, $Layer/LayerTitle, $Percentage2/PercentageTitle, $Payout/PayoutScheduleTitle, $Recoup/RecoupTitle, $Start/StartDateTitle, %EndDateTitle]
	editable_infos = [%EditableInt, %EditablePercentage, %Recoup, %EditableMonth, %EditableYear, %EditableMonth2, %EditableYear2]
	
	%SourceName.target_resource = recipient_rev_share.revenue_source
	%Payout.target_resource = recipient_rev_share.revenue_source
	
	for info : EditableInfo in editable_infos:
		info.target_resource = recipient_rev_share
	
	call_deferred("update_labels")

var cal: Calendar = Calendar.new()

func update_labels() -> void:
	
	if show_titles == false:
		for node : Node in titles:
			node.hide()
	else:
		for node : Node in titles:
			node.show()
	
	var source : RecipientRevShare = recipient_rev_share
	var rev_source : RevenueSourceData = source.revenue_source
	
#	if source.recoup == 0:
#		%Recoup.label_node.text = "N/A"
#		%Recoup.highlight_container.label.text = "N/A"
#		%Recoup.modulate = Color(Colors.disabled_transparent)
#	else:
#		%Recoup.label_node.text = str(source.recoup) + "$ | " + str(100 * source.recoup_percentage) + "%" 
#		%Recoup.highlight_container.label.text = str(source.recoup) + "$ | " + str(100 * source.recoup_percentage) + "%" 
#		%Recoup.modulate = Color("fff")


var want_to_delete_share : bool = false
func _on_delete_revenue_pressed() -> void:
	if want_to_delete_share == false:
		%DeleteSourceButton.modulate = Color(Colors.red_tint)
		want_to_delete_share = true
		%DeleteRevSourceReset.start()
		return
	if want_to_delete_share == true:
		reset_delete_share_state()
		Global.delete_share_from_recipient(recipient,recipient_rev_share)

func _on_delete_share_reset_timeout() -> void:
	reset_delete_share_state()

func reset_delete_share_state() -> void:
	%DeleteSourceButton.modulate = Color("fff")
	want_to_delete_share = false
