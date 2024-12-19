extends Node

@export var hit_box: CollisionShape2D
@export var state_machine : StateMachine
@export var ray: RayCast2D
@export var npcray: RayCast2D
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
			hit_box.rotation = deg_to_rad(90)
		Vector2.RIGHT:
			hit_box.position = Vector2(10, 0)
			hit_box.rotation = deg_to_rad(-90)
		Vector2.DOWN:
			hit_box.position = Vector2(0, 8)
			hit_box.rotation = deg_to_rad(0)
		Vector2.UP:
			hit_box.position = Vector2(0, -8)
			hit_box.rotation = deg_to_rad(180)
	
	can_move_to(new_direction)

func can_move_to(new_direction) -> bool:
	ray.target_position = new_direction * (grid_size)
	npcray.target_position = new_direction * (grid_size*0.8)
	ray.force_raycast_update()
	npcray.force_raycast_update()
	return !ray.is_colliding() && !npcray.is_colliding()
