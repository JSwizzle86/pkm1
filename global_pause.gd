extends Node

var last_scene_path: String = ""
	
func _input(event):
	if event.is_action_pressed("Pause"):
		toggle_pause()
		
func toggle_pause():
	get_tree().paused = true
	last_scene_path = get_tree().current_scene.get_scene_file_path()
	get_tree().change_scene_to_file("res://Main/PauseScene/Pause_Scene.tscn")
	
func toggle_unpause():
	print("toggle_unpause has started")
	get_tree().paused = false
	get_tree().change_scene_to_file(last_scene_path)
	
