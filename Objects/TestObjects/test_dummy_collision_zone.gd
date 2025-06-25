extends Area2D

var damage: int = 0
var HP: int = 100


func take_damage(damage: int):
	HP -= damage
	
	if HP <= 0:
		die()
	
	print(HP)
func die():
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "pkm1 player":
		take_damage(5)
