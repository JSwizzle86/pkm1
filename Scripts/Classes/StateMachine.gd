extends Node
class_name StateMachine

signal new_state
signal update_anim


enum State {
	Idle,
	Walking,
	Running,
	Turning,
	Attacking,
	Defending,
}


enum StatusCondition {
	None,
	Paralyzed,
	Frozen,
	Burn,
	Poison,
	Sleep,
}

@export var actor : Node
@export var current_state : State
@export var status_condition : StatusCondition
@export var collision_handler : Node
@export var animation_handler : Node

var current_mini_state = null
var movement_direction : Vector2 = Vector2.ZERO
