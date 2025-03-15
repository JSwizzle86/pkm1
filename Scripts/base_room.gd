extends Node2D

class_name BaseRoom

@export var room_name : String = "placeholder"
@export var max_cam_x = 10000000
@export var min_cam_x = -10000000
@export var max_cam_y = 10000000
@export var min_cam_y = -10000000


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_tree().get_root().has_node("Main"):
		get_tree().get_root().get_node("Main").redo_limits(min_cam_x, max_cam_x, min_cam_y, max_cam_y)
		

func _on_enter_area_collision_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.room_entered.emit(room_name)
		body.get_node("CollisionHandler").tile_map = %TileMap
	#	body.movement_state._initialize_astar_grid()
