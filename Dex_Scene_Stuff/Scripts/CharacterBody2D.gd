extends CharacterBody2D

const SPEED = 50
const RUN_MULTIPLIER = 1.5  
const JUMP_VELOCITY = -400.0

var gravity = 0
var friction = 5
#the lower the friction is the stronger it is
var looking = "UP"
var moving = false
var current_speed = SPEED  

func _physics_process(delta):

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	if Input.is_action_pressed("run"):  
		current_speed = SPEED * RUN_MULTIPLIER
	else:
		current_speed = SPEED

	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed / friction)

	move_and_slide()

func move_up_and_down():
	if Input.is_action_pressed("Up"):
		if not Input.is_action_pressed("Down"):
			velocity.y = -current_speed
	if  not Input.is_action_pressed("Up") or not Input.is_action_pressed("Down"):
		velocity.y = move_toward(velocity.y, 0, current_speed / friction)
	if Input.is_action_pressed("Down"):
		if not Input.is_action_pressed("Up"):
			velocity.y = current_speed

func _process(delta):
	move_up_and_down()
	animation_control()

func animation_control():
	if Input.is_action_pressed("Left"):
		looking = "LEFT"
		$AnimatedSprite2D.play("left")
	
	if Input.is_action_pressed("Right"):
		looking = "RIGHT"
		$AnimatedSprite2D.play("right")
	
	if Input.is_action_pressed("Down"):
		looking = "DOWN"
		$AnimatedSprite2D.play("down")
	
	if Input.is_action_pressed("Up"):
		looking = "UP"
		$AnimatedSprite2D.play("up ")
