extends HBoxContainer
class_name ProcessLayerContainer

@export var layer_recipients : Array[RecipientData] = []
@export var rev_source : RevenueSourceData
@export var layer : int 

const RECIPIENT_LINE : Resource = preload("uid://7qd8p64mqw0h")

func _ready() -> void:
	while rev_source == null:
		await get_tree().process_frame
	
	%RecoupLevel.text = str(layer)
	
	var id : int = 0
	var amount_of_recipients : int = layer_recipients.size()
	
	for recipient : RecipientData in layer_recipients:
		var new_line : ProcessRecipientLine = RECIPIENT_LINE.instantiate()
		new_line.id = id
		if id == amount_of_recipients - 1:
			new_line.is_last = true
		
		new_line.recipient = recipient
		new_line.rev_source = rev_source
		
		%RecipientLineContainer.add_child(new_line)
		
		id += 1
	
	
