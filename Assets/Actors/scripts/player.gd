class_name Player extends Area2D

var facingDir: StringName = "down"
var paused: bool = false

func _ready():
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)
	$PlayerSprites.play("down_idle")

func _process(_delta):
	if !paused:
		var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var run_input: bool = Input.is_action_pressed("run")
		var interact_input: bool = Input.is_action_just_pressed("DialogueInteract")
		var magnitude = 2 if run_input else 1
		
		if facingDir != vector2Direction(input_direction):
			animate_move(input_direction, false)
			facingDir = vector2Direction(input_direction)
		else:	
			$GridMovement.move(input_direction, magnitude)
			animate_move(input_direction, run_input)
		
		if interact_input: act()

##Animates the movement of the actor [br][br]
##[param input_direction] the vector of the input[br]
##[param running] the input of the running state
func animate_move(input_direction:Vector2, running: bool) -> void:
	var animation_state: StringName = ""
	var moving_direction: Vector2 = $GridMovement.moving_direction
	var vectorDirection = vector2Direction(moving_direction)
	
	if moving_direction.length() > 0:
		if running: animation_state = vectorDirection + "_run"
		else: animation_state = vectorDirection + "_walk"
	else:
		if input_direction.length() > 0:
			vectorDirection = vector2Direction(input_direction)
			animation_state = vectorDirection + "_idle"
		else:
			animation_state = vectorDirection + "_idle"
			
	$PlayerSprites.play(animation_state)

func act() -> void:
	var ray: RayCast2D = $FacingDirection
	var direction: Vector2 = Vector2.DOWN
	
	if facingDir == "up": direction = Vector2.UP
	elif facingDir == "right": direction = Vector2.RIGHT
	elif facingDir=="left": direction = Vector2.LEFT
	
	ray.target_position = direction * Constants.TILE_SIZE
	ray.force_raycast_update() # Update the `target_position` immediately
	print("try to find area")
	var collisionArea: Area2D = ray.get_collider() if is_instance_of(ray.get_collider(), Area2D) else null
	if collisionArea != null && is_instance_of(collisionArea, Area2D):
		var areas = collisionArea.get_overlapping_areas()
		print("found some areas")
		for area in areas:
			if area.has_method("interact"):
				print("area Found")
				area.interact(self)

##Returns a string description of the direction of the given vector. [br][br]
##[param vec] vector to proccess
func vector2Direction(vec: Vector2) -> String:
	var direction = facingDir
	
	if vec.y > 0.5:
		direction = "down"
		if vec.x > 0.5:
			if facingDir == "left" || facingDir == "up": direction = "right"
		elif vec.x < -0.5:
			if facingDir == "right" || facingDir =="up": direction = "left"
			
	elif vec.y < -0.5:
		direction = "up"
		if vec.x > 0.5:
			if facingDir == "left" || facingDir == "down": direction = "right"
		elif vec.x < -0.5:
			if facingDir == "right" || facingDir =="down": direction = "left"
			
	elif vec.x > 0.5:
		direction = "right"
		
	elif vec.x < -0.5:
		direction = "left"
		
	return direction
