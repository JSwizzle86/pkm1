class_name  Player extends GameTile

@export var interact_enabled = true ##interaction toggle
@export var movement_enabled = true ##movement toggle
@export var walking_speed = 4 ## 1/input seconds to complete 1 square move
@export var running_speed = 8 ## 1/input seconds to complete 1 square move

var facingDir: StringName = "down"
var paused: bool = false

func _ready():
	super._ready()
	$PlayerSprites.play("down_idle")

func _process(_delta):
		var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var run_input: bool = Input.is_action_pressed("run")
		var interact_input: bool = Input.is_action_just_pressed("DialogueInteract")
		
		if movement_enabled:
			if facingDir != vector2Direction(input_direction):
				animate_move(input_direction, false)
				facingDir = vector2Direction(input_direction)
			else:
				$GridMovement.move(input_direction, running_speed if run_input else walking_speed)
				animate_move(input_direction, run_input)
		if interact_enabled:
			if interact_input: interact()

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

##Checks for interaction in the facing direction and activates it if there is
func interact() -> void:
	var ray: RayCast2D = $FacingDirection
	var direction: Vector2 = Vector2.DOWN
	
	if facingDir == "up": direction = Vector2.UP
	elif facingDir == "right": direction = Vector2.RIGHT
	elif facingDir=="left": direction = Vector2.LEFT
	
	ray.target_position = direction * Constants.TILE_SIZE
	ray.force_raycast_update() # Update the `target_position` immediately
	print("try to find area")
	var collisionArea: Area2D = ray.get_collider() if is_instance_of(ray.get_collider(), Area2D) else null
	if collisionArea != null:
		var areas = collisionArea.get_overlapping_areas()
		collisionArea.on_interact(self)
		print("found an area")
		for area in areas:
			if is_instance_of(area, GameTile) && area.global_position == collisionArea.global_position:
				print("additional area Found" + area.to_string())
				area.on_interact(self)

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
