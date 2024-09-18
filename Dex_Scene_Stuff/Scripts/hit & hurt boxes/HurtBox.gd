extends Area2D
## a class represent the hurt box of an object
class_name HurtBox




signal hit(damage: int)


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area: Hitbox) -> void:
	hit.emit(area.damage) 
