extends Control

@onready var menu = $"."

var input_pause = false

##Needs an overhaul to work with current design constraints

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Pokedex.grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and input_pause == false:
		input_pause = true
		get_tree().paused = true
	elif event.is_action_pressed("pause") and input_pause == true:
		input_pause = false
		get_tree().paused = false
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		get_viewport().set_input_as_handled()
		
func _process(delta):
	if input_pause == true:
		menu.visible = true
	else:
		menu.visible = false
