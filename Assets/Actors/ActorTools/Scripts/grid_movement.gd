class_name GridMovement extends Node2D

##parent node
@export var self_node: Node2D
##movement speed
@export var speed: float = 0.25

var moving_direction: Vector2 = Vector2.ZERO
var diagonal: bool = false

func _ready():
	# Set movement direction as DOWN by default
	$RayCast2D.target_position = Vector2.DOWN * Constants.TILE_SIZE

##Applies movement of the linked actor [br][br]
##[param direction] the direction vector of the movement input [br]
##[param magnitude] the number of grid spaces the movement takes
func move(direction: Vector2, magnitude: int) -> void:
	var magHold = magnitude
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
		
		#check range
		for i in range(magnitude):
			$RayCast2D.target_position = movement * Constants.TILE_SIZE * (magnitude - i)
			$RayCast2D.force_raycast_update() # Update the `target_position` immediately
			if $RayCast2D.is_colliding():
				magnitude -= i + 1
		
		#check adjacent tile
		$RayCast2D.target_position = movement * Constants.TILE_SIZE * magnitude
		$RayCast2D.force_raycast_update() # Update the `target_position` immediately
		
		# Allow movement only if no collision in next tile
		if magnitude > 0 && !$RayCast2D.is_colliding():
			moving_direction = movement * magnitude
			var new_position = self_node.global_position + (moving_direction * Constants.TILE_SIZE)
			var tween = create_tween()
			
			#Keep speed constant in different movement modes
			if magHold > magnitude:
				tween.tween_property(self_node, "position", new_position, speed / magHold if !diagonal else speed / magHold / (sqrt(2)/2)).set_trans(Tween.TRANS_LINEAR)
			else:
				tween.tween_property(self_node, "position", new_position, speed if !diagonal else speed / (sqrt(2)/2)).set_trans(Tween.TRANS_LINEAR)
			tween.tween_callback(func(): moving_direction = Vector2.ZERO)
	diagonal = false
