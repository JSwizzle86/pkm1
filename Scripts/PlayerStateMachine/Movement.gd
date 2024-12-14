extends MiniState

@export var speed: float = 35
@export var run_multiplier: float = 1.5
@export var hit_box: CollisionShape2D
@export var ray: RayCast2D
@export var npcray: RayCast2D

var current_speed: float = speed
var moving: bool = false
var grid_size: Vector2 = Vector2(Global.global_tile, Global.global_tile)
var target_position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var new_direction: Vector2 = Vector2.ZERO
var animation_direction: Vector2 = Vector2.ZERO
var input_pressed: bool = false
var stopped_moving: bool = true
var should_turn: bool = true
var buffer_timer: Timer = Timer.new()
var buffer_active: bool = false
var buffer_duration: float = 0.08  # Time in seconds to delay movement

func _ready():
	add_child(buffer_timer)
	buffer_timer.timeout.connect(_on_buffer_finished)
	state_machine.new_state.connect(set_state)
	update_animation()  # Initialize animation state

func _process(delta):
	handle_input()
#	print(stopped_moving)
	if moving:
		current_speed = get_running_speed()
		move_player(delta)
	elif input_pressed && !buffer_active:
		if can_move_to():
			start_moving()
		else:
			direction = new_direction
			reset_movement()

func handle_input():
	if new_direction != Vector2.ZERO:
		if new_direction != animation_direction && !moving:
			var _throw_away = can_move_to()
			animation_direction = new_direction
			detect_direction_change()
			update_animation()
			
			

		if direction != new_direction and ! buffer_active && !moving:
			trigger_buffer()

		else:
			input_pressed = true
	else:
		input_pressed = false
		buffer_timer.stop()
		buffer_active = false

	if ray.is_colliding():
		reset_movement()
	update_direction()

func trigger_buffer():
	buffer_active = true
	buffer_timer.wait_time = buffer_duration
	buffer_timer.start()

func _on_buffer_finished():
	buffer_active = false
	if new_direction != Vector2.ZERO:
		input_pressed = true



func start_moving():
	moving = true
	target_position = snapped_position(state_machine.actor.position + direction * grid_size)
	stopped_moving = false

func reset_movement():
	moving = false
	input_pressed = false

func update_animation():
	detect_direction_change()
	set_state()
	state_machine.update_anim.emit()

func update_direction():
	if new_direction != direction and !moving:
		direction = new_direction

func snapped_position(position: Vector2) -> Vector2:
	return position.snapped(grid_size)

func can_move_to() -> bool:
	ray.target_position = new_direction * (grid_size / 2)
	npcray.target_position = new_direction * (grid_size )
	ray.force_raycast_update()
	npcray.force_raycast_update()
	return !ray.is_colliding() && !npcray.is_colliding()


func move_player(delta):
	var movement_vector = direction * current_speed * delta
	state_machine.actor.position += movement_vector

	if state_machine.actor.position.distance_to(target_position) < 1:
		state_machine.actor.position = target_position
		reset_movement()
		detect_direction_change()

		if input_pressed and can_move_to():
			start_moving()
		else:
			stopped_moving = true

func get_running_speed() -> float:
	if Input.is_action_pressed("run"):
		state_machine.current_state = StateMachine.State.Running
		return speed * run_multiplier

	state_machine.current_state = StateMachine.State.Walking
	return speed

func set_state():
	if direction != Vector2.ZERO:
		state_machine.current_mini_state = self

func detect_direction_change():
	if animation_direction.x == -1: 
		state_machine.movement_direction = 0
	if animation_direction.x == 1: 
		state_machine.movement_direction = 1
	if animation_direction.y == 1: 
		state_machine.movement_direction = 2
	if animation_direction.y == -1: 
		state_machine.movement_direction = 3

	update_hit_box(state_machine.movement_direction)

func update_hit_box(new_direction):
	match new_direction:
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
