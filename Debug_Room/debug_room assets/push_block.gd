class_name PushBlock extends GameTile

func on_interact(actor: GameTile):
	print("interaction started")
	var directions: Array[Vector2] = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	
	for direction in directions:
		$RayCast2D.target_position = direction * Constants.TILE_SIZE
		$RayCast2D.force_raycast_update()
		
		if $RayCast2D.is_colliding():
			print("found area around push")
			var collidedArea: Area2D = $RayCast2D.get_collider()
			var areas: Array[Area2D] = collidedArea.get_overlapping_areas()
			areas.push_back(collidedArea)
			for area in areas:
				if area.global_position == collidedArea.global_position and area.to_string() == actor.to_string():
					print("found pusher")
					$GridMovement.move((direction * -1), 4)
