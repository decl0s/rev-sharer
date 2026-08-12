extends PanelContainer

const AWAITING_PROCESS_REV_SOURCE_PANEL : Resource = preload("uid://ddc2qks4x3ngl")

func _ready() -> void:
	Sig.revenue_source_created.connect(populate_dues)
	Sig.revenue_source_edited.connect(populate_dues)
	Sig.revenue_source_deleted.connect(populate_dues)
	Sig.revenue_created.connect(populate_dues)
	Sig.revenue_edited.connect(populate_dues)
	Sig.revenue_deleted.connect(populate_dues)
	Sig.rev_share_added_to_recipient.connect(populate_dues)
	Sig.rev_share_deleted_from_recipient.connect(populate_dues)
	Sig.rev_share_modified.connect(populate_dues)
	Sig.recipient_edited.connect(populate_dues)
	Sig.recipient_edited.connect(populate_dues)
	Sig.recoup_created.connect(populate_dues)
	Sig.recoup_edited.connect(populate_dues)
	Sig.recoup_deleted.connect(populate_dues)
	
	populate_dues()

func populate_dues() -> void:
	if %QueueContainer.get_child_count() != 0:
		for child : Node in %QueueContainer.get_children():
			child.queue_free()
	
	if Global.get_rev_sources_with_unprocessed_rev().size() == 0 : 
		%Empty.show()
	else:
		%Empty.hide()
		for rev_source : RevenueSourceData in Global.get_rev_sources_with_unprocessed_rev():
			var rev_source_panel : ProcessRevSourcePanel = AWAITING_PROCESS_REV_SOURCE_PANEL.instantiate()
			rev_source_panel.rev_source = rev_source
			%QueueContainer.add_child(rev_source_panel)
	print("repopulating")
