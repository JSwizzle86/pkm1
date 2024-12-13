extends Node

var global_tile : int = 24
var player_node : Player

var dialogue 


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_dialog = preload("res://Scripts/Components/Talkable_Objects/Dialogue/dialogue.tscn")
	dialogue = new_dialog.instantiate()
	add_child(dialogue)
	
	var new_window_size : Vector2 = DisplayServer.screen_get_size()/2
	get_window().size = Vector2i(new_window_size)
	get_window().position = new_window_size/2
