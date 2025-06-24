class_name Sign extends Area2D

func _ready():
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)

func interact():
	$TalkableArea.interact()
