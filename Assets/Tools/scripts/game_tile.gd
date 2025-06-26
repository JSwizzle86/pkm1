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

##Define with an override to do actions on collision[br]
##[param actor] the triggering actor
func on_collision(actor: GameTile):
	##[param actor] the triggering actor
	return

##Define with an override to do actions on interact[br]
##[param actor] the triggering actor
func on_interact(actor: GameTile):
	return

##Define with an override to do actions on hit[br]
##[param actor] the triggering actor
func on_hit(actor: GameTile):
	return

##Define with an override to do actions on step activation[br]
##[param actor] the triggering actor
func on_step(actor: GameTile):
	return
