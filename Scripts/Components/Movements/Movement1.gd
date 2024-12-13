extends MovementComponent

var steps_counter : int = 0
var current_direction : int = 0

@export var ray : RayCast2D
var current_speed : float = 35
var friction = 10.0
var moving : bool = false
var grid_size: Vector2 = Vector2(Global.global_tile, Global.global_tile)  # Size of each grid cell
var target_position: Vector2 = Vector2.ZERO  # Target position the player moves toward
# Movement direction
var direction: Vector2 = Vector2.ZERO
var new_direction: Vector2 = Vector2.ZERO  # For storing quick direction change
var step_counter : int = 0
var current_dir : int = 0

func _ready():
	area.body_entered.connect(stop_walking)
	area.body_exited.connect(start_walking)


# Called every frame
func _process(delta):
	handle_input()
	# If already moving, interpolate to the target position
	if moving:
		current_speed = is_running()
		move_player(delta)
	else:
		# Once the player reaches the grid position, they can start moving again
		if direction != Vector2.ZERO:
			# Check if the next position is valid before moving
			if can_move_to():
				moving = true
				target_position = actor.position + direction * grid_size
				
				steps_counter += 1
				
			else:
				# If can't move, reset the direction and stop the movement
				direction = new_direction
				moving = false
	if steps_counter >= steps:
		current_dir = wrap(current_dir + 1, 0, 4)
		steps_counter = 0
	steps_counter += 1

# Handle player input for quick direction changes
func handle_input():
	new_direction = Vector2.ZERO  # Reset direction each frame

	match current_dir:
		0:
			new_direction.y = -1
		1:
			new_direction.x = -1
			
		2:
			new_direction.y = 1
		3:
			new_direction.x = 1
		
	# If direction changes, but we're not moving yet, switch to the new direction
	if ray.is_colliding():
		moving = false
	
	check_dire()

# Check direction change logic
func check_dire():
	if new_direction != direction and not moving:
		direction = new_direction

# Check if the next position is valid (no collision)
func can_move_to() -> bool:
	ray.target_position = new_direction * (grid_size / 2)
	ray.force_raycast_update()
	return !ray.is_colliding()

func move_player(delta):
	var movement_vector = direction * current_speed * delta
	actor.position += movement_vector
	
	if actor.position.distance_to(target_position) < 1:
		actor.position = target_position
		moving = false
			
		'''
		if can_move_to():
			moving = true
			handle_input()
			direction = new_direction
			target_position = actor.position + direction * grid_size'''


func is_running() -> float:
	if running:
		return speed * run_multiplier
	else:
		return speed


func stop_walking(body : Object):
	if body is Player:
		if actor.get_real_velocity() != actor.velocity:
			set_process(false)


func start_walking(body : Object):
	if body is Player:
		set_process(true)
