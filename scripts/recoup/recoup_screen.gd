extends Control

func _ready() -> void:
	repopulate_recoups()
	
	Sig.revenue_source_deleted.connect(repopulate_recoups)
	Sig.revenue_source_created.connect(repopulate_recoups)
	Sig.rev_share_modified.connect(repopulate_recoups)
	Sig.rev_share_added_to_recipient.connect(repopulate_recoups)
	Sig.rev_share_deleted_from_recipient.connect(repopulate_recoups)
	Sig.recoup_created.connect(repopulate_recoups)
	Sig.recoup_edited.connect(repopulate_recoups)
	Sig.recoup_deleted.connect(repopulate_recoups)

@onready var empty_label: Label = %EmptyLabel
@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var container : VBoxContainer = %DataContainer

func repopulate_recoups() -> void:
	for child : Node in container.get_children() :
		if child is RecoupPanelContainer:
			child.queue_free()
	populate_recoups()
	
	if Global.get_available_revenue_sources().is_empty() == true:
		empty_label.show()
		scroll_container.hide()
	else:
		empty_label.hide()
		scroll_container.show()

const RECOUP_PANEL_CONTAINER : Resource = preload("uid://bxqlnd7lvcnn1")

func populate_recoups() -> void:
	for revenue_source : RevenueSourceData in Global.revenue_sources.values():
		if revenue_source.archived == true: # Don't instantiate if archived.
			continue
		var new_recoup_panel : RecoupPanelContainer = RECOUP_PANEL_CONTAINER.instantiate()
		new_recoup_panel.revenue_source = revenue_source
		container.add_child(new_recoup_panel)
		
		if not new_recoup_panel.is_node_ready():
			await new_recoup_panel.ready
		new_recoup_panel.init()
