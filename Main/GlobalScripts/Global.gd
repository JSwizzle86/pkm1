extends Node

var global_tile : int = 16


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_window_size : Vector2 = DisplayServer.screen_get_size()/2
	get_window().size = Vector2i(new_window_size)
	get_window().position = new_window_size/2

