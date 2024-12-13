extends MiniState

@export var speed : float = 1000.0
@export var run_multiplier : float = 1.5 
@export var hit_box : CollisionShape2D
@export var ray : RayCast2D
@export var npcray : RayCast2D
var current_speed : float = 1000.0
var friction = 10.0
var moving : bool = false
var grid_size: Vector2 = Vector2(Global.global_tile, Global.global_tile) 
var target_position: Vector2 = Vector2.ZERO 

var direction: Vector2 = Vector2.ZERO
var new_direction: Vector2 = Vector2.ZERO 
var input_pressed : bool = false
var stopped_moving : bool = true
var button_pressed : bool = false



func _ready():
	state_machine.new_state.connect(set_state)


func _process(delta):
	handle_input()
	
	if moving:
		current_speed = running()
		move_player(delta)
	else:
		if direction != Vector2.ZERO and input_pressed:
			if can_move_to():
				moving = true
				target_position = state_machine.actor.position + direction * grid_size
				stopped_moving = false
				
			else:
				direction = new_direction
				moving = false
				input_pressed = false
		else:
			if !stopped_moving:
				state_machine.new_state.emit()
				state_machine.update_anim.emit()
				stopped_moving = true
				


func handle_input():
	new_direction = Vector2.ZERO 

	# Moving up
	if Input.is_action_pressed("Up"):
		new_direction.y = -1
		input_pressed = true
		walk_anim_check()
	# Moving down
	elif Input.is_action_pressed("Down"):
		new_direction.y = 1
		input_pressed = true
		walk_anim_check()
	# Moving left
	elif Input.is_action_pressed("Left"):
		new_direction.x = -1
		input_pressed = true
		walk_anim_check()
	# Moving right
	elif Input.is_action_pressed("Right"):
		new_direction.x = 1
		input_pressed = true
		walk_anim_check()

	# Check for diagonal directions (combine up/down and left/right)
	if Input.is_action_pressed("Up") and Input.is_action_pressed("Left"):
		new_direction = Vector2(-1, -1)
		input_pressed = true
		walk_anim_check()
	elif Input.is_action_pressed("Up") and Input.is_action_pressed("Right"):
		new_direction = Vector2(1, -1)
		input_pressed = true
		walk_anim_check()
	elif Input.is_action_pressed("Down") and Input.is_action_pressed("Left"):
		new_direction = Vector2(-1, 1)
		input_pressed = true
		walk_anim_check()
	elif Input.is_action_pressed("Down") and Input.is_action_pressed("Right"):
		new_direction = Vector2(1, 1)
		input_pressed = true
		walk_anim_check()

	if new_direction == Vector2.ZERO:
		input_pressed = false

	# If direction changes, but we're not moving yet, switch to the new direction
	
	if ray.is_colliding():
		moving = false
	
	check_dire()


func walk_anim_check():
	if !button_pressed:
		detect_direction_change()
		set_state()
		running()
		state_machine.update_anim.emit()
		button_pressed = true


func check_dire():
	if new_direction != direction and not moving:
		direction = new_direction
		

func can_move_to() -> bool:
	ray.target_position = new_direction * (grid_size / 2)
	npcray.target_position = new_direction * (grid_size)
	ray.force_raycast_update()
	npcray.force_raycast_update()
	return !ray.is_colliding() && !npcray.is_colliding()

func move_player(delta):
	var movement_vector = direction * current_speed * delta
	state_machine.actor.position += movement_vector
	
	
	if state_machine.actor.position.distance_to(target_position) < 1:
		state_machine.actor.position = target_position
		moving = false
		
		detect_direction_change()
		if input_pressed:
			if can_move_to():
				moving = true
				button_pressed = true
				stopped_moving = false
				handle_input()
				direction = new_direction
				target_position = state_machine.actor.position + direction * grid_size
				set_state()
				state_machine.update_anim.emit()
		else:
			button_pressed = false
				



func running() -> float:
	if Input.is_action_pressed("run"):
		state_machine.current_state = StateMachine.State.Running
		return speed * run_multiplier
	else:
		state_machine.current_state = StateMachine.State.Walking
		return speed

func set_state():
	if direction != Vector2.ZERO:
		state_machine.current_mini_state = self

func detect_direction_change():
	if new_direction.x == -1:
		state_machine.movement_direction = 0
	elif new_direction.x == 1:
		state_machine.movement_direction = 1
	elif new_direction.y == 1:
		state_machine.movement_direction = 2
	elif new_direction.y == -1:
		state_machine.movement_direction = 3
	
	interaction_collision_direction(state_machine.movement_direction)

func interaction_collision_direction(new_current_direction):
	match new_current_direction:
		0:
			hit_box.position = Vector2(-10, 0)
			hit_box.rotation = deg_to_rad(90)
		1:
			hit_box.position = Vector2(10, 0)
			hit_box.rotation = deg_to_rad(-90)
		2:
			hit_box.position = Vector2(0, 8)
			hit_box.rotation = deg_to_rad(0)
		3:
			hit_box.position = Vector2(0, -8)
			hit_box.rotation = deg_to_rad(180)
