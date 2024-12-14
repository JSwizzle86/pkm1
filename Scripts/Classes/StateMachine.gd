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

@export var idle : MiniState
@export var moving : MiniState
@export var dash : MiniState

var actor_moving : bool = false

func _process(delta: float) -> void:
	handle_input()
	if !actor_moving && moving.stopped_moving:
		idle.set_state()
	%AnimationHandler.change_anim()



func handle_input():
	actor_moving = moving.new_direction != Vector2.ZERO
	moving.new_direction = Input.get_vector("Left", "Right", "Up", "Down").sign()
