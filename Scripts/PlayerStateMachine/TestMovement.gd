extends MiniState


@export var walk_speed = 4.0
var TILE_SIZE = Global.global_tile
var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0
@export var ray : RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = state_machine.actor.position
	
func _physics_process(delta):
	if is_moving == false:
		process_player_movement_input()
	elif input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false
func process_player_movement_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
#	detect_direction_change()
	if input_direction != Vector2.ZERO:
		initial_position = state_machine.actor.position
		is_moving = true

func move(delta):
	percent_moved_to_next_tile += walk_speed * delta
	if percent_moved_to_next_tile >= 1.0:
		state_machine.actor.position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
	var desired_step: Vector2 = input_direction * TILE_SIZE / 3.5
	ray.target_position = desired_step
	ray.force_raycast_update()
	if !ray.is_colliding():
		percent_moved_to_next_tile += walk_speed * delta
		if percent_moved_to_next_tile >= 1.0:
			state_machine.actor.position = initial_position + (input_direction * TILE_SIZE)
			percent_moved_to_next_tile = 0.0
			is_moving = false
		else:
			state_machine.actor.position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)
	else:
		percent_moved_to_next_tile = 0
		is_moving = false

func detect_direction_change():
	# Check for a change in direction to potentially trigger a turn animation
	if Input.is_action_pressed("Left"):
		state_machine.movement_direction = 0
	elif Input.is_action_pressed("Right"):
		state_machine.movement_direction = 1
	elif Input.is_action_pressed("Down"):
		state_machine.movement_direction = 2
	elif Input.is_action_pressed("Up"):
		state_machine.movement_direction = 3
	
	interaction_collision_direction(state_machine.movement_direction)

func interaction_collision_direction(new_current_direction):
	match new_current_direction:
		0:
	#		hit_box.position = Vector2(-10, 0)
	#		hit_box.rotation = deg_to_rad(90)
			ray.rotation = deg_to_rad(90)
		1:
		#	hit_box.position = Vector2(10, 0)
		#	hit_box.rotation = deg_to_rad(-90)
			ray.rotation = deg_to_rad(-90)
		2:
		#	hit_box.position = Vector2(0, 8)
		#	hit_box.rotation = deg_to_rad(0)
			ray.rotation = deg_to_rad(0)
		3:
		#	hit_box.position = Vector2(0, -8)
		#	hit_box.rotation = deg_to_rad(180)
			ray.rotation = deg_to_rad(180)
