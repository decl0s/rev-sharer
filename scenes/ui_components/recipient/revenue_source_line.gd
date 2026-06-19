extends HBoxContainer
class_name RecipientRevenueLineUI

@export var recipient : RecipientData
@export var recipient_rev_share : RecipientRevShare

var show_titles : bool

var titles : Array[Label]
var editable_infos : Array[EditableInfo]

var is_being_edited : bool
@onready var edit_btn : EditButton = $Edit


func _ready() -> void:
	%DeleteSourceButton.pressed.connect(_on_delete_revenue_pressed)
	%DeleteRevSourceReset.timeout.connect(_on_delete_share_reset_timeout)
	
	titles = [$SourceName/SourceNameTitle, $Layer/LayerTitle, $Percentage2/PercentageTitle, $Payout/PayoutScheduleTitle, $Recoup/RecoupTitle, $Start/StartDateTitle, %EndDateTitle]
	editable_infos = [%EditableInt, %EditablePercentage, %Recoup, %EditableMonth, %EditableYear, %EditableMonth2, %EditableYear2]
	%SourceName.target_resource = recipient_rev_share.revenue_source
	%Payout.target_resource = recipient_rev_share.revenue_source
	
	for info : EditableInfo in editable_infos:
		info.target_resource = recipient_rev_share
	
	edit_btn.started_editing.connect(_on_edit_started)
	edit_btn.ended_editing.connect(_on_edit_ended)
	
	call_deferred("update_labels")

func _on_edit_started() -> void:
	is_being_edited = true

func _on_edit_ended() -> void:
	is_being_edited = false

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
