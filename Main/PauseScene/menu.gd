extends Control

@onready var menu = $PanelContainer  # Reference to the menu container
@onready var default_button = $PanelContainer/MarginContainer/VBoxContainer/Pokedex  # Default button to focus on

var is_paused = false  # Track pause state

func _ready():
	# Ensure the menu is hidden at the start
	menu.visible = false
	# Set the menu to process input even when the game is paused
	menu.process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	# Toggle pause when the "pause" action is pressed
	if event.is_action_pressed("pause"):
		toggle_pause()


func toggle_pause():
	# Toggle pause state
	is_paused = !is_paused
	get_tree().paused = is_paused
	menu.visible = is_paused

	# Set focus to the default button when pausing
	if is_paused:
		default_button.grab_focus()
