class_name Player extends CharacterBody2D

const SPEED = 50.0  
const RUN_MULTIPLIER = 1.5  

var friction = 5.0
var looking = "UP"  # current facing direction
var moving = false  # check if the character is moving
var current_speed = SPEED  

# Underlying variable to store running state
var _is_running = false

# Use the setter for running mode
var is_running = false:
	set(value):
		_is_running = value
		# Adjust running speed when toggled
		if _is_running:
			current_speed = SPEED * RUN_MULTIPLIER
		else:
			current_speed = SPEED

var last_direction = ""  # check last movement for turns
var turning = false  # Checking if player is in the middle of a turn animation
var target_direction = ""  # The direction the character should face after turning

func _ready():
	# Connect the animation_finished signal to handle the completion of turn animations
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	# Block input processing during turn
	if turning:
		return  # Ignore inputs while turning
	
	# Handle running input
	if Input.is_action_pressed("run"):
		is_running = true  # Start running when the run button is held
	elif Input.is_action_just_released("run"):  # Stop running when the run button is released
		is_running = false  
	else:
		# Check if the run toggle is active
		if Input.is_action_just_pressed("run_toggle"):
			is_running = not _is_running  # Toggle run mode correctly by setting the property

	handle_movement()  # Handle movement
	move_and_slide()  # Apply movement and sliding

func handle_movement():
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Disable vertical movement in case of turning
	if turning: input_dir.x = 0.0
	
	if input_dir:
		velocity = input_dir.normalized() * current_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction)

func _process(delta):
	# Process vertical movement outside of physics
	if not turning:
		pass
	detect_direction_change()
	animation_control()

func detect_direction_change():
	# Check for a change in direction to potentially trigger a turn animation
	var current_direction = ""
	if Input.is_action_pressed("Left"):
		current_direction = "LEFT"
	elif Input.is_action_pressed("Right"):
		current_direction = "RIGHT"
	elif Input.is_action_pressed("Down"):
		current_direction = "DOWN"
	elif Input.is_action_pressed("Up"):
		current_direction = "UP"
	
	# If the direction has changed and the player is running, handle the turn
	if current_direction != last_direction and last_direction != "":
		if _is_running:
			if (last_direction == "LEFT" and current_direction == "RIGHT") or (last_direction == "RIGHT" and current_direction == "LEFT"):
				# Horizontal direction change (left-right)
				if last_direction == "LEFT":
					play_turn_animation("turn_right", "RIGHT")
				else:
					play_turn_animation("turn_left", "LEFT")
			elif (last_direction == "UP" and current_direction == "DOWN") or (last_direction == "DOWN" and current_direction == "UP"):
				# Vertical direction change (up-down)
				if last_direction == "UP":
					play_turn_animation("turn_down", "DOWN")
				else:
					play_turn_animation("turn_up", "UP")
			else:
				# Non-opposite direction changes (e.g., diagonal)
				looking = current_direction
		else:
			# When not running, just update the facing direction without turning
			looking = current_direction
		last_direction = current_direction

func play_turn_animation(turn_animation, new_direction):
	# Play the turn animation 
	if not turning:
		$AnimatedSprite2D.play(turn_animation)
		target_direction = new_direction
		turning = true  # Block other animations and movement updates during the turn

func _on_animation_finished():
	# Update way player is facing after turn animation finishes and resume normal player movement
	if turning:
		looking = target_direction
		turning = false  # Re-enable inputs after the turn finishes

func animation_control():
	# Block animation control if turning
	if turning:
		return
	
	if Input.is_action_pressed("Left"):
		looking = "LEFT"
		last_direction = "LEFT"
		if _is_running:
			$AnimatedSprite2D.play("run_left")
		else:
			$AnimatedSprite2D.play("left")
	
	elif Input.is_action_pressed("Right"):
		looking = "RIGHT"
		last_direction = "RIGHT"
		if _is_running:
			$AnimatedSprite2D.play("run_right")
		else:
			$AnimatedSprite2D.play("right")
	
	elif Input.is_action_pressed("Down"):
		looking = "DOWN"
		if _is_running:
			$AnimatedSprite2D.play("run_down")  # Play running animation when running down
		else:
			$AnimatedSprite2D.play("down")
	
	elif Input.is_action_pressed("Up"):
		looking = "UP"
		if _is_running:
			$AnimatedSprite2D.play("run_up")  # Play running animation when running up
		else:
			$AnimatedSprite2D.play("up ")
	
	else:
		# Idle animations when there's no input
		if looking == "LEFT":
			$AnimatedSprite2D.play("left_idle")
		elif looking == "RIGHT":
			$AnimatedSprite2D.play("right_idle")
		elif looking == "DOWN":
			$AnimatedSprite2D.play("down_idle")
		elif looking == "UP":
			$AnimatedSprite2D.play("up_idle")
