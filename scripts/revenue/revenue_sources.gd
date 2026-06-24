extends Control

func _ready() -> void:
	repopulate_revenues()
	
	Sig.revenue_source_deleted.connect(repopulate_revenues)
	Sig.revenue_source_created.connect(repopulate_revenues)
	Sig.rev_share_modified.connect(repopulate_revenues)
	Sig.rev_share_added_to_recipient.connect(repopulate_revenues)
	Sig.rev_share_deleted_from_recipient.connect(repopulate_revenues)

@onready var empty_label: Label = %NoRevenueLabel
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var container : VBoxContainer = %RevenueSourcesContainer

func repopulate_revenues() -> void:
	for child : Node in container.get_children() :
		if child is RevenueSourcePanelContainer:
			child.queue_free()
	populate_revenues()
	
	if Global.revenue_sources.is_empty() == true:
		empty_label.show()
		scroll_container.hide()
	else:
		empty_label.hide()
		scroll_container.show()

const REVENUE_SOURCE_PANEL : Resource = preload("uid://3mhhjb0d4dio")

func populate_revenues() -> void:
	for revenue_source : RevenueSourceData in Global.revenue_sources.values():
		if revenue_source.archived == true: # Don't instantiate if archived.
			continue
		var new_revenue_panel : RevenueSourcePanelContainer = REVENUE_SOURCE_PANEL.instantiate()
		new_revenue_panel.revenue = revenue_source
		new_revenue_panel.init()
		container.add_child(new_revenue_panel)
