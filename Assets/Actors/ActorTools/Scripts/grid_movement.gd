class_name GridMovement extends Node2D

##parent node
@export var linked_tile: GameTile

var moving_direction: Vector2 = Vector2.ZERO


func _ready():
	# Set movement direction as DOWN by default
	$RayCast2D.target_position = Vector2.DOWN * Constants.TILE_SIZE

##Applies movement of the linked actor [br][br]
##[param direction] the direction vector of the movement input [br]
##[param speed] speed of the movement
func move(direction: Vector2, speed: float) -> void:
	var diagonal: bool = false
	var collided:bool = false
	var stepped: bool = false
	var collisionAreas: Array[Area2D] = []
	var stepAreas: Array[Area2D] = []
	
	direction = direction.normalized()
	if moving_direction.length() == 0 && direction.length() > 0:
		var movement = Vector2.DOWN
		if direction.y > 0.5: 
			movement = Vector2.DOWN
			if direction.x < -0.5: 
				movement += Vector2.LEFT
				diagonal = true
			elif direction.x > 0.5: 
				movement += Vector2.RIGHT
				diagonal = true
		elif direction.y < -0.5: 
			movement = Vector2.UP
			if direction.x < -0.5: 
				movement += Vector2.LEFT
				diagonal = true
			elif direction.x > 0.5: 
				movement += Vector2.RIGHT
				diagonal = true	
		elif direction.x > 0.5: movement = Vector2.RIGHT
		elif direction.x < -0.5: movement = Vector2.LEFT
		
		#check adjacent tile
		$RayCast2D.target_position = movement * Constants.TILE_SIZE
		$RayCast2D.force_raycast_update() # Update the `target_position` immediately
		var collidedArea:Area2D = $RayCast2D.get_collider() if is_instance_of($RayCast2D.get_collider(), Area2D) else null
		if collidedArea != null:
			var areas: Array[Area2D] = collidedArea.get_overlapping_areas()
			areas.append(collidedArea)
			for area in areas:
				if is_instance_of(area, GameTile) && area.global_position == collidedArea.global_position:
					if area.collision: 
						collided = true
						collisionAreas.push_back(area)
					elif area.steppable:
						print("stepped")
						stepAreas.push_back(area)
		
		# Allow movement only if no collision in next tile
		if!collided:
			moving_direction = movement
			var new_position = linked_tile.global_position + (moving_direction * Constants.TILE_SIZE)
			var tween = create_tween()
	
			tween.tween_property(linked_tile, "position", new_position, (1/speed) if !diagonal else (1/speed) / (sqrt(2)/2)).set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(func(): moving_direction = Vector2.ZERO)
			
			for area in stepAreas:
				area.on_step(linked_tile)
		else:
			for area in collisionAreas:
				area.on_collision(linked_tile)
