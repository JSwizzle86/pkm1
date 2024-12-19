class_name Player extends CharacterBody2D

@export var movement_state : MiniState


func _ready() -> void:
	%StateMachine.movement_direction = Global.player_enter_room_direction
	%StateMachine.new_state.emit("Idle")
