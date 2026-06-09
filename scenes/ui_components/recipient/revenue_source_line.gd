extends HBoxContainer
class_name RecipientRevenueLineUI

@export var recipient : RecipientData
@export var recipient_rev_share : RecipientRevShare

func _ready() -> void:
	%DeleteSourceButton.pressed.connect(_on_delete_revenue_pressed)
	%DeleteRevSourceReset.timeout.connect(_on_delete_share_reset_timeout)

var cal: Calendar = Calendar.new()

func update_labels() -> void:
	var source : RecipientRevShare = recipient_rev_share
	var rev_source : RevenueSourceData = source.revenue_source
	%SourceName.text = rev_source.name
	%Percentage.text = str(100 * source.percentage)+"%"
	%PayoutSchedule.text = Utils.get_schedule_string(rev_source.payout_schedule)
	%StartDate.text = cal.get_date_formatted(source.start_year,source.start_month,1,"%m-%Y")
	%EndDate.text = cal.get_date_formatted(source.end_year,source.end_month,1,"%m-%Y")

var want_to_delete_share : bool = false
func _on_delete_revenue_pressed() -> void:
	if want_to_delete_share == false:
		%DeleteSourceButton.modulate = Color("ff8c8c")
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
