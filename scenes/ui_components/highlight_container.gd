@tool
extends PanelContainer

enum ColorStyle {
	White,
	Red,
	Orange,
	Green,
	Blue,
	Purple,
	Pink
}

@onready var label: Label = %Label

@export var color : ColorStyle:
	set(value):
		color = value
		#update_colors()

@export var text : String:
	set(value):
		text = value
		#set_text()

func set_text(string : String = text) -> void:
	label.text = string

func _ready() -> void:
	update_colors()
	set_text()

func update_colors() -> void:
	match color:
		ColorStyle.White:
			change_color(Colors.white)
		ColorStyle.Red :
			change_color(Colors.red)
		ColorStyle.Orange :
			change_color(Colors.orange)
		ColorStyle.Green :
			change_color(Colors.green)
		ColorStyle.Blue :
			change_color(Colors.blue)
		ColorStyle.Purple :
			change_color(Colors.purple)
		ColorStyle.Pink :
			change_color(Colors.pink)

func change_color(color: String) -> void:
	label.modulate = Color(color)
	self_modulate = Color(color)
