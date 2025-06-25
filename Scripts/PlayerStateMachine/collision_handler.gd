extends Node

@export var hit_box: CollisionShape2D
@export var state_machine : StateMachine
@export var npcray: Area2D
var grid_size: Vector2 = Vector2(Global.global_tile, Global.global_tile)
var tile_map : TileMap

func detect_direction_change(animation_direction):
	if animation_direction.x == -1: 
		state_machine.movement_direction = Vector2.LEFT
	if animation_direction.x == 1: 
		state_machine.movement_direction = Vector2.RIGHT
	if animation_direction.y == 1: 
		state_machine.movement_direction = Vector2.DOWN
	if animation_direction.y == -1: 
		state_machine.movement_direction = Vector2.UP
	update_hit_box(state_machine.movement_direction)

func update_hit_box(new_direction):
	match new_direction:
		Vector2.LEFT:
			hit_box.position = Vector2(-10, 0)

		Vector2.RIGHT:
			hit_box.position = Vector2(10, 0)

		Vector2.DOWN:
			hit_box.position = Vector2(0, 8)

		Vector2.UP:
			hit_box.position = Vector2(0, -8)

	
	can_move_to(new_direction)

func can_move_to(new_direction) -> bool:
	npcray.rotation = atan2(new_direction.y,new_direction.x)
	return true
