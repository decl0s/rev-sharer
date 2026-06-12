extends Node

signal recipient_created
func create_recipient() -> void:
	emit_signal("recipient_created")

signal recipient_deleted
func delete_recipient() -> void:
	emit_signal("recipient_deleted")

signal revenue_deleted_from_recipient
func delete_revenue_from_recipient() -> void:
	emit_signal("revenue_deleted_from_recipient")

signal revenue_added_to_recipient
func add_revenue_to_recipient() -> void:
	emit_signal("revenue_added_to_recipient")
