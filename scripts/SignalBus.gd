extends Node

# -----------------------------
# RECIPIENTS
# -----------------------------

signal recipient_created
func create_recipient() -> void:
	emit_signal("recipient_created")

signal recipient_edited
func edit_recipient() -> void:
	emit_signal("recipient_edited")

signal recipient_deleted
func delete_recipient() -> void:
	emit_signal("recipient_deleted")

# -----------------------------
# REV SHARES
# -----------------------------

signal rev_share_deleted_from_recipient
func delete_rev_share_from_recipient() -> void:
	emit_signal("rev_share_deleted_from_recipient")

signal rev_share_added_to_recipient
func add_rev_share_to_recipient() -> void:
	emit_signal("rev_share_added_to_recipient")

signal rev_share_modified
func modify_rev_share() -> void:
	emit_signal("rev_share_modified")

# -----------------------------
# REVENUE SOURCES
# -----------------------------

signal revenue_source_created
func create_revenue_source() -> void:
	emit_signal("revenue_source_created")

signal revenue_source_edited
func edit_revenue_source() -> void:
	emit_signal("revenue_source_edited")

signal revenue_source_deleted
func delete_revenue_source() -> void:
	emit_signal("revenue_source_deleted")

# -----------------------------
# RECOUP
# -----------------------------

signal recoup_created
func create_recoup() -> void:
	emit_signal("recoup_created")

signal recoup_deleted
func delete_recoup() -> void:
	emit_signal("recoup_deleted")

signal recoup_edited
func edit_recoup() -> void:
	emit_signal("recoup_edited")

# -----------------------------
# TRANSACTIONS
# -----------------------------

signal transaction_created
func create_transaction() -> void:
	emit_signal("transaction_created")

signal transaction_deleted
func delete_transaction() -> void:
	emit_signal("transaction_deleted")

signal transaction_edited
func edit_transaction() -> void:
	emit_signal("transaction_edited")
	

# -----------------------------
# REVENUES
# -----------------------------

signal revenue_created
func create_revenue() -> void:
	emit_signal("revenue_created")

signal revenue_deleted
func delete_revenue() -> void:
	emit_signal("revenue_deleted")

signal revenue_edited
func edit_revenue() -> void:
	emit_signal("revenue_edited")

# -----------------------------
# PAYMENTS
# -----------------------------

signal payment_created
func create_payment() -> void:
	emit_signal("payment_created")

signal payment_deleted
func delete_payment() -> void:
	emit_signal("payment_deleted")

signal payment_edited
func edit_payment() -> void:
	emit_signal("payment_edited")
