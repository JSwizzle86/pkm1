extends MiniState

@export var speed: float = 35
@export var run_multiplier: float = 1.5

var current_speed: float = speed
var moving: bool = false
var grid_size: Vector2 = Vector2(Global.global_tile, Global.global_tile)
var target_position: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var new_direction: Vector2 = Vector2.ZERO
var animation_direction: Vector2 = Vector2.ZERO
var input_pressed: bool = false
var should_turn: bool = true
var tween : Tween

func _ready():
	state_machine.new_state.connect(set_state)

func _process(delta):
	if state_machine.current_mini_state == self:
		handle_input()
	else:
		new_direction = Vector2.ZERO
	if moving:
		current_speed = get_running_speed()
		move_player(delta)
	elif input_pressed:
		if state_machine.collision_handler.can_move_to(new_direction):
			start_moving()
		else:
			direction = new_direction
			reset_movement()

func handle_input():
	new_direction = Input.get_vector("Left", "Right", "Up", "Down").sign().normalized()
	if new_direction != Vector2.ZERO:
		animation_direction = new_direction
		input_pressed = true
	else:
		input_pressed = false
		
		

	update_direction()

func start_moving():
	moving = true

func reset_movement():
	moving = false
	input_pressed = false


func update_animation():
	state_machine.collision_handler.detect_direction_change(new_direction)
	state_machine.update_anim.emit()

func update_direction():
	if new_direction != direction and !moving:
		state_machine.collision_handler.detect_direction_change(new_direction)
		direction = new_direction

func snapped_position(position: Vector2) -> Vector2:
	return position.snapped(grid_size)

func move_player(delta):
	state_machine.actor.velocity = current_speed * new_direction
	state_machine.actor.move_and_slide()
	update_animation()
	if input_pressed:
		active = true
		if state_machine.collision_handler.can_move_to(new_direction):
			start_moving()
		else:
			active = false
	elif !input_pressed:
		active = false
	

func get_running_speed() -> float:
	if Input.is_action_pressed("run"):
		state_machine.current_state = StateMachine.State.Running
		return speed * run_multiplier
	state_machine.current_state = StateMachine.State.Walking
	return speed

func set_state(is_moving):
	if is_moving == "Moving":
		active = true
		state_machine.current_mini_state = self
		set_process(true)
		get_running_speed()
		update_animation()
	else:
		active = false
		set_process(false)
