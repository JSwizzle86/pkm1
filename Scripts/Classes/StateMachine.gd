extends Node
class_name StateMachine

signal new_state
signal update_anim


enum State {
	Idle,
	Walking,
	Running,
	Turning,
}

enum FightState {
	None,
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
@export var fight_state : FightState
@export var status_condition : StatusCondition

var current_mini_state = null
var movement_direction : int = 0
