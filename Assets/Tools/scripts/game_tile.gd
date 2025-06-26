##GameTile is the base tile of the game, all other tiles inherit from this tile.
class_name GameTile extends Area2D

@export var collision = false ##Enables collision
@export var interactable = false ##Enables interaction if on_interact() is defined
@export var attackable = false ##Enables on_hit() if it is defined
@export var steppable = false ##Enables on_step() if it is defined

##Enforces adherence to the grid position
func _ready():
	position = position.snapped(Vector2.ONE * Constants.TILE_SIZE)
	position -= Vector2.ONE * (Constants.TILE_SIZE / 2)

##Define with an override to do actions on collision
func on_collision():
	return

##Define with an override to do actions on interact
func on_interact(player: Player):
	return

##Define with an override to do actions on hit
func on_hit():
	return

##Define with an override to do actions on step activation
func on_step(player: Player):
	return
