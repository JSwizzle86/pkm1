extends MiniState



# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.new_attack_state.connect(set_state)

func set_state(is_attack):
	if is_attack == "WindAttack":
		attack_active = true
		state_machine.attacking_state = StateMachine.Attack.WindAttacking
		state_machine.animation_handler.attack_anim(self)

		


func exist_state():
	state_machine.attacking_state = StateMachine.Attack.None
	attack_active = false
	state_machine.update_anim.emit()
