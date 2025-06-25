extends MiniState


# make sure to edit the script name to the correct one, godot will automatically update it in the node, so don't worry
func _ready():
	state_machine.new_attack_state.connect(set_state)

func set_state(is_attack):
	if is_attack == "Attacking4": #<- make sure to change the name when editing the code and emitted signals
		attack_active = true
	#	state_machine.attacking_state = StateMachine.Attack.(Attack name here)   <- make sure to add the attack to enum in StateMachine script


func exist_state():
	state_machine.attacking_state = StateMachine.Attack.None
	attack_active = false
	state_machine.update_anim.emit()
