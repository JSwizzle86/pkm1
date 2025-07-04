class_name NPC extends GameTile

@export var dialogue: TalkableObjectData
@export var wander: bool = false
@export var wanderRate: float = 1.0

var directions: Array[Vector2] = [Vector2(0, 1), Vector2(1, 0), Vector2(0, -1), Vector2(-1, 0)]
var facingDir = "down"

func _ready():
	super._ready()
	$AnimatedSprite2D.play("down_idle")
	
func _process(_delta):
	if wander && DialogueLoad.finished: meander()

func on_interact(actor: GameTile):
	if is_instance_of(actor, Player):
		
		for direction in directions:
			$RayCast2D.target_position = direction * Constants.TILE_SIZE
			$RayCast2D.force_raycast_update()
			
			if $RayCast2D.is_colliding():
				var collidedArea: Area2D = $RayCast2D.get_collider()
				var areas: Array[Area2D] = collidedArea.get_overlapping_areas()
				areas.push_back(collidedArea)
				for area in areas:
					if area.to_string() == actor.to_string() && area.global_position == collidedArea.global_position:
						facingDir = vector2Direction(direction)
						$AnimatedSprite2D.play(facingDir + "_idle")
						DialogueLoad._start_dialogue(dialogue, actor)
						
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
	
func meander():
	var direction: Vector2 = Vector2.DOWN
	if $Timer.time_left <= 0:
		print("start npc move")
		while true:
			var collide = false
			direction = directions[randi() % 4]
			
			$RayCast2D.target_position = direction * Constants.TILE_SIZE
			$RayCast2D.force_raycast_update()
			
			if $RayCast2D.is_colliding():
				var collidedArea: Area2D = $RayCast2D.get_collider()
				var areas: Array[Area2D] = collidedArea.get_overlapping_areas()
				areas.push_back(collidedArea)
				for area in areas:
					if is_instance_of(area, GameTile) && area.global_position == collidedArea.global_position:
						if area.collision : collide = true
						
			if !collide : break
		facingDir = vector2Direction(direction)
		$AnimatedSprite2D.play(facingDir + "_walk")
		movingDir = $GridMovement.moving_direction
		$GridMovement.move(direction, 4)
		$Timer.start(wanderRate)
		
	elif $GridMovement.moving_direction.length() == 0: $AnimatedSprite2D.play(facingDir + "_idle")
