class_name Player extends CharacterBody2D

const SPEED: int = 150
const FRICTION: float = 0.8

var looking_direction: String = "UP"
var can_control: bool = true

func _physics_process(delta: float):
	if can_control:
		handle_movement(delta)
	handle_animation()
	move_and_slide()

func handle_movement(delta: float):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("Up"):
		velocity.y = -SPEED
		looking_direction = "UP"
	elif Input.is_action_pressed("Down"):
		velocity.y = SPEED
		looking_direction = "DOWN"
	
	if Input.is_action_pressed("Left"):
		velocity.x = -SPEED
		looking_direction = "LEFT"
	elif Input.is_action_pressed("Right"):
		velocity.x = SPEED
		looking_direction = "RIGHT"
	
	velocity = velocity.lerp(Vector2.ZERO, FRICTION * delta)

func handle_animation():
	if velocity.length() > 0:
		if looking_direction == "UP":
			$AnimatedSprite2D.play("up")
		elif looking_direction == "DOWN":
			$AnimatedSprite2D.play("down")
		elif looking_direction == "LEFT":
			$AnimatedSprite2D.play("left")
		elif looking_direction == "RIGHT":
			$AnimatedSprite2D.play("right")
	else:
		$AnimatedSprite2D.play(looking_direction + "_idle")
