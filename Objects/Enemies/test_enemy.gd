extends CharacterBody2D

var speed :int = 100
var player_chase : bool = false
var player = null
var health : int = 10
var player_in_attack_range : bool = false

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position) / speed
		
		if (player.position.x - position.x) < 0:
			animated_sprite.play("left")
		elif (player.position.x - position.x) > 0:
			animated_sprite.play("right")
		
		


func _on_detection_zone_body_entered(body: Node2D) -> void:
	if body.name == "pkm1 player":
		player = body
		player_chase = true


func _on_detection_zone_body_exited(body: Node2D) -> void:
	if body.name == "pkm1 player":
		player = null
		player_chase = false
		
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_range = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_attack_range = false
		
func knockback():
	position.x = position.x - 10
	position.y = position.y - 10
	
func deal_with_damage():
	if player_in_attack_range and Global.player_attack:
		health = health - 1
		print("Enemy took ", 1, " damage!")
		knockback()
		if health <= 0:
			self.queue_free()
