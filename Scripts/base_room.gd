extends Node2D

@export var players_in_room : Node2D

@export var max_cam_x = 10000000
@export var min_cam_x = -10000000
@export var max_cam_y = 10000000
@export var min_cam_y = -10000000

# Called when the node enters the scene tree for the first time.
func _ready():
	for player in players_in_room.get_children():
		player.get_node("Camera2D").limit_left = min_cam_x
		player.get_node("Camera2D").limit_right = max_cam_x
		player.get_node("Camera2D").limit_top = min_cam_y
		player.get_node("Camera2D").limit_bottom = max_cam_y
