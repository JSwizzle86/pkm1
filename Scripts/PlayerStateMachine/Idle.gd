extends MiniState

@export var movement_state : MiniState

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.new_state.connect(set_state)
	set_state()

func set_state():
	if movement_state.direction == Vector2.ZERO:
		state_machine.current_mini_state = self
		state_machine.current_state = StateMachine.State.Idle
		state_machine.update_anim.emit()
#		print("Idle")
