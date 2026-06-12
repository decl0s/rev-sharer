extends HBoxContainer

func _ready() -> void:
	reset_new_recipient_inputs()
	
	%AddRecipient.pressed.connect(_on_add_recipient_pressed)
	%CancelNewRecipient.pressed.connect(_on_cancel_recipient_pressed)
	%RecipientName.text_changed.connect(_on_text_changed)

func create_new_recipient() -> void:
	var new_rec : RecipientData = RecipientData.new()
	new_rec.name = %RecipientName.text
	new_rec.minimum_payout = %MinimumAmount.value
	Global.create_recipient(new_rec)

func _on_text_changed(str : String) -> void:
	%RecipientName.modulate = Color("fff")

func reset_new_recipient_inputs() -> void:
	%RecipientName.text = ""
	%RecipientName.modulate = Color("fff")
	%MinimumAmount.value = 0

func _on_cancel_recipient_pressed() -> void:
	%Name.hide()
	%MinimumAmountInput.hide()
	%CancelNewRecipient.hide()
	is_creating_recipient = false
	reset_new_recipient_inputs()

var is_creating_recipient : bool = false
func _on_add_recipient_pressed() -> void:
	if is_creating_recipient == false:
		is_creating_recipient = true
		%Name.show()
		%MinimumAmountInput.show()
		%CancelNewRecipient.show()
		return
	if is_creating_recipient == true:
		if %RecipientName.text == "": # Error red highlight if no name input.
			%RecipientName.modulate = Color(Colors.red_tint)
			return
		create_new_recipient()
		is_creating_recipient = false
		%Name.hide()
		%MinimumAmountInput.hide()
		%CancelNewRecipient.hide()
		reset_new_recipient_inputs()
		return
