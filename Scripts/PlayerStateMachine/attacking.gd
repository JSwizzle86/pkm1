extends MiniState



# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.new_state.connect(set_state)

func set_state(is_attack):
	if is_attack == "Attacking":
		active = true
		state_machine.current_mini_state = self
		state_machine.current_state = StateMachine.State.Attacking
		state_machine.animation_handler.attack_anim(self)
		


func exist_state():
	active = false
