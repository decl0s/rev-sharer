extends Button

signal deletion_requested

var want_to_delete : bool = false
func _on_delete_pressed() -> void:
	if want_to_delete == false:
		modulate = Color("ff8c8c")
		want_to_delete = true
		%delete_reset.start()
		return
	if want_to_delete == true:
		reset_delete_state()
		emit_signal("deletion_requested")

func _on_delete_reset_timeout() -> void:
	reset_delete_state() 

func reset_delete_state() -> void:
	modulate = Color("fff")
	want_to_delete = false
