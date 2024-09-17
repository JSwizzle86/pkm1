class_name Player extends CharacterBody2D

const SPEED = 50.0  
const RUN_MULTIPLIER = 1.5  
const JUMP_VELOCITY = -400.0

var gravity = 0.0
var friction = 5.0
var looking = "UP"  #  current facing direction
var moving = false  # check if the character is moving
var current_speed = SPEED  
var is_running = false  # Toggle for running mode
var last_direction = ""  #  check  last movement for turns
var turning = false  # Checking if player is in the middle of a turn animation
var target_direction = ""  # The direction the character should face after turning

func _ready():
	# Connect the animation_finished signal to handle the completion of turn animations
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta):
	# stay on floor
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jumping idk if this being used?
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Handle running input
	if Input.is_action_pressed("run"):
		is_running = true  # Start running when the run button is held
	elif Input.is_action_just_released("run"):  # Use is_action_just_released
		is_running = false  # Stop running when the run button is released
	else:
		# Check if run toggle is active
		if Input.is_action_just_pressed("run_toggle"):
			is_running = not is_running  # Toggle run mode if run_toggle is pressed

	# running speed
	if is_running:
		current_speed = SPEED * RUN_MULTIPLIER
	else:
		current_speed = SPEED

	if not turning:
		# movement
		var direction = Input.get_axis("Left", "Right")
		if direction:
			velocity.x = direction * current_speed
		else:
			# Smoothly decelerate when no horizontal input
			velocity.x = move_toward(velocity.x, 0, current_speed / friction)
	
		move_up_and_down()  # Handle vertical movement
	
	move_and_slide()  # Apply movement and sliding

func move_up_and_down():
	# up and down movement
	if Input.is_action_pressed("Up"):
		if not Input.is_action_pressed("Down"):
			velocity.y = -current_speed  # Move up
	if not Input.is_action_pressed("Up") or not Input.is_action_pressed("Down"):
		# Smoothly decelerate when no vertical input
		velocity.y = move_toward(velocity.y, 0, current_speed / friction)
	if Input.is_action_pressed("Down"):
		if not Input.is_action_pressed("Up"):
			velocity.y = current_speed  # Move down

func _process(delta):
	# process movement
	if not turning:
		move_up_and_down()
	detect_direction_change()
	animation_control()

func detect_direction_change():
	# detect way player is facing to turn
	var current_direction = ""
	if Input.is_action_pressed("Left"):
		current_direction = "LEFT"
	elif Input.is_action_pressed("Right"):
		current_direction = "RIGHT"
	elif Input.is_action_pressed("Down"):
		current_direction = "DOWN"
	elif Input.is_action_pressed("Up"):
		current_direction = "UP"
	
	# Check if direction has changed and turn according to that only if running
	if current_direction != last_direction and last_direction != "":
		if is_running:
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
		turning = false  # allow normal play stuff again

func animation_control():
	# movement animations and inputs
	if turning:
		return
	
	if Input.is_action_pressed("Left"):
		looking = "LEFT"
		last_direction = "LEFT"
		if is_running:
			$AnimatedSprite2D.play("run_left")
		else:
			$AnimatedSprite2D.play("left")
	
	elif Input.is_action_pressed("Right"):
		looking = "RIGHT"
		last_direction = "RIGHT"
		if is_running:
			$AnimatedSprite2D.play("run_right")
		else:
			$AnimatedSprite2D.play("right")
	
	elif Input.is_action_pressed("Down"):
		looking = "DOWN"
		if is_running:
			$AnimatedSprite2D.play("run_down")  # Play running animation when running down
		else:
			$AnimatedSprite2D.play("down")
	
	elif Input.is_action_pressed("Up"):
		looking = "UP"
		if is_running:
			$AnimatedSprite2D.play("run_up")  # Play running animation when running up
		else:
			$AnimatedSprite2D.play("up")
	
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
