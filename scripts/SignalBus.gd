extends Node

signal recipient_created
func create_recipient() -> void:
	emit_signal("recipient_created")

signal recipient_edited
func edit_recipient() -> void:
	emit_signal("recipient_edited")

signal recipient_deleted
func delete_recipient() -> void:
	emit_signal("recipient_deleted")

signal revenue_deleted
func delete_revenue() -> void:
	emit_signal("revenue_deleted")

signal rev_share_deleted_from_recipient
func delete_rev_share_from_recipient() -> void:
	emit_signal("rev_share_deleted_from_recipient")

signal rev_share_added_to_recipient
func add_rev_share_to_recipient() -> void:
	emit_signal("rev_share_added_to_recipient")

signal rev_share_modified
func modify_rev_share() -> void:
	emit_signal("rev_share_modified")

signal created_revenue_source
func create_revenue_source() -> void:
	emit_signal("created_revenue_source")

signal revenue_source_edited
func edit_revenue_source() -> void:
	emit_signal("revenue_source_edited")
