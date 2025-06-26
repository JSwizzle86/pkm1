class_name GridMovement extends Node2D

##parent node
@export var linked_tile: GameTile
##Walk Speed, the lower the value the higher the speed[br]
##default: 25
@export var walkSpeed: float = 25
##Run Speed, the lower the value the higher the speed[br]
##default: 12.5
@export var runSpeed: float = 12.5

var moving_direction: Vector2 = Vector2.ZERO
var diagonal: bool = false
var collided:bool = false

func _ready():
	# Set movement direction as DOWN by default
	$RayCast2D.target_position = Vector2.DOWN * Constants.TILE_SIZE

##Applies movement of the linked actor [br][br]
##[param direction] the direction vector of the movement input [br]
##[param running] if running
func move(direction: Vector2, running: bool) -> void:
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
			var areas = collidedArea.get_overlapping_areas()
			if collidedArea.collision:
				collided = true
				collidedArea.on_collision(linked_tile)
			elif collidedArea.steppable:
				print("stepped")
				collidedArea.on_step(linked_tile)
			for area in areas:
				if is_instance_of(area, GameTile) && area.global_position == collidedArea.global_position:
					if area.collision: 
						collided = true
						area.on_collision(linked_tile)
					elif area.steppable:
						print("stepped")
						area.on_step(linked_tile)
		
		# Allow movement only if no collision in next tile
		if!collided:
			moving_direction = movement
			var new_position = linked_tile.global_position + (moving_direction * Constants.TILE_SIZE)
			var tween = create_tween()
			var speed = runSpeed/100 if running else walkSpeed/100
	
			tween.tween_property(linked_tile, "position", new_position, speed if !diagonal else speed / (sqrt(2)/2)).set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(func(): moving_direction = Vector2.ZERO)
			
	diagonal = false
	collided = false
