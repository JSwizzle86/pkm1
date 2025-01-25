extends MovementComponent

var steps_counter : int = 0
var current_direction : int = 0

@export var ray : Area2D

var current_speed : float = 20
var friction = 10.0
var moving : bool = false
var grid_size: Vector2 = Vector2(Global.global_tile, Global.global_tile)  
var target_position: Vector2 = Vector2.ZERO 
var direction: Vector2 = Vector2.ZERO
var new_direction: Vector2 = Vector2.ZERO 
var step_counter : int = 0
var current_dir : int = 0
var touching_player : bool = false

func _ready():
	ray.body_entered.connect(ray_body_entered)
	ray.body_exited.connect(ray_body_exited)

# Called every frame
func _process(delta):
	if moving:
		if steps_counter > steps-1:
			current_dir = wrap(current_dir + 1, 0, 4)
			steps_counter = 0
		current_speed = is_running()
		move_player(delta)
		
	else:
		handle_input()
		if !moving:
			target_position = actor.position + direction * grid_size
			
			moving = true
			
		else:
			direction = new_direction
			
			moving = false
				

func handle_input():
	new_direction = Vector2.ZERO 

	match current_dir:
		0:
			new_direction.y = -1
			ray.get_node("Ray").rotation = deg_to_rad(180)
		1:
			new_direction.x = -1
			ray.get_node("Ray").rotation = deg_to_rad(90)
		2:
			new_direction.y = 1
			ray.get_node("Ray").rotation = deg_to_rad(0)
		3:
			new_direction.x = 1
			ray.get_node("Ray").rotation = deg_to_rad(-90)
	check_dire()

# Check direction change logic
func check_dire():
	if new_direction != direction and not moving:
		direction = new_direction

func move_player(delta):
	var movement_vector = direction * current_speed * delta
	actor.position = actor.position + movement_vector

	if actor.position.distance_to(target_position) < 1:
		
		actor.position = target_position.snapped(grid_size)
		steps_counter += 1
		moving = false

func is_running() -> float:
	if running:
		return speed * run_multiplier
	else:
		return speed

func ray_body_entered(body : Object):
	if body is Player:
		touching_player = true
		set_process(false)
		set_physics_process(false)

func ray_body_exited(body : Object):
	if body is Player:
		if Global.dialogue.talkable_object != actor:
			touching_player = false
			await get_tree().create_timer(0.5).timeout
			set_process(true)
			set_physics_process(true)

func set_processes():
	if touching_player:
		return
	
	set_process(true)
	set_physics_process(true)
