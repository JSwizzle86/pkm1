extends Node2D

@export var players_in_room : Node2D


func redo_limits(min_cam_x, max_cam_x, min_cam_y, max_cam_y):
	for player in $PlayerHolder.get_children():
		player.get_node("Camera2D").limit_left = min_cam_x
		player.get_node("Camera2D").limit_right = max_cam_x
		player.get_node("Camera2D").limit_top = min_cam_y
		player.get_node("Camera2D").limit_bottom = max_cam_y
