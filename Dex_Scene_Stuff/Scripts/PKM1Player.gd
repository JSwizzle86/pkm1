class_name Player extends CharacterBody2D

var enemy_in_attack_range : bool = false
var enemy_attack_cooldown : bool = true
var health : int = 18
var player_is_alive : bool = true

@onready var timer = $AttackCooldown

@export var movement_state : MiniState
@export var current_location : Node2D
var is_paused = false


func _ready() -> void:
	%StateMachine.movement_direction = Global.player_enter_room_direction
	%StateMachine.new_state.emit("Idle")
	
func _physics_process(delta: float) -> void:
	enemy_attack()
	
	#setting a "signal" to the enemy that they're attacking
	if Input.is_action_pressed("attack") and enemy_in_attack_range:
		Global.player_attack = true
		$AttackCooldown.start()

		
	if health <= 0:
		player_is_alive = false
		#Add endscreen/pokecenter logic here.
		print("Player killed!")
		health = 0

func player():
	pass

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = true


func _on_attack_area_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown:
		health = health - 1
		enemy_attack_cooldown = false
		timer.start()


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
	Global.player_attack = false
