extends Control

func _ready() -> void:
	repopulate_revenues()
	
	Sig.revenue_source_deleted.connect(repopulate_revenues)
	Sig.revenue_source_created.connect(repopulate_revenues)
	Sig.rev_share_modified.connect(repopulate_revenues)
	Sig.rev_share_added_to_recipient.connect(repopulate_revenues)
	Sig.rev_share_deleted_from_recipient.connect(repopulate_revenues)
	Sig.recoup_created.connect(repopulate_revenues)
	Sig.recoup_edited.connect(repopulate_revenues)
	Sig.recoup_deleted.connect(repopulate_revenues)
	Sig.transaction_created.connect(repopulate_revenues)
	Sig.transaction_edited.connect(repopulate_revenues)
	Sig.transaction_deleted.connect(repopulate_revenues)
	Sig.revenue_created.connect(repopulate_revenues)
	Sig.revenue_edited.connect(repopulate_revenues)
	Sig.revenue_deleted.connect(repopulate_revenues)

@onready var empty_label: Label = %EmptyLabel
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var container : VBoxContainer = %DataContainer

func repopulate_revenues() -> void:
	for child : Node in container.get_children() :
		if child is RevenuePanelContainer:
			child.queue_free()
	populate_recoups()
	
	if Global.get_available_revenue_sources().is_empty() == true:
		empty_label.show()
		scroll_container.hide()
	else:
		empty_label.hide()
		scroll_container.show()

const REVENUE_PANEL_CONTAINER : Resource = preload("uid://ipl7n0r4375t")

func populate_recoups() -> void:
	for revenue_source : RevenueSourceData in Global.revenue_sources.values():
		if revenue_source.archived == true: # Don't instantiate if archived.
			continue
		var new_revenue_panel : RevenuePanelContainer = REVENUE_PANEL_CONTAINER.instantiate()
		new_revenue_panel.revenue_source = revenue_source
		container.add_child(new_revenue_panel)
		
		if not new_revenue_panel.is_node_ready():
			await new_revenue_panel.ready
		new_revenue_panel.init()
