extends Node

signal room_entered

var global_tile : int = 24
var player_node : Player
var player_enter_room_direction : Vector2 = Vector2.DOWN
var dialogue
var player_attack : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_dialog = preload("res://Scripts/Components/Talkable_Objects/Dialogue/dialogue.tscn")
	dialogue = new_dialog.instantiate()
	add_child(dialogue)
	
	var new_window_size : Vector2 = DisplayServer.screen_get_size()/2
	get_window().size = Vector2i(new_window_size)
	get_window().position = new_window_size/2

#function to add the scene as a child, function called in individual rooms at "exits"
func _add_scene_manually(scene: Node2D, spawn_position: Vector2):
	get_tree().root.add_child(scene)
	
	#Spawns player in a specific position based on incoming data
	var player = get_node("res://Objects/PlayerObject/pkm_1_player.tscn")
	if player:
		player.position = spawn_position
	
#function to remove the scene from the tree, pauses all node processes but does not delete them
func _remove_scene_manually(scene: Node2D):
	get_tree().root.remove_child(scene)
	
