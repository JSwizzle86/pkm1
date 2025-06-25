extends MiniState

@export var animation_handler : Node

func _ready():
	state_machine.new_state.connect(set_state)

func set_state(is_idle):
	if is_idle == "Turning":
		active = true
		state_machine.current_mini_state = self
		state_machine.current_state = StateMachine.State.Turning
		state_machine.collision_handler.update_hit_box(state_machine.movement_direction)
		animation_handler.play_turning(self)
	else:
		active = false

func exist_state():
	print("false")
	if Input.get_vector("Left", "Right", "Up", "Down"):
		state_machine.new_state.emit("Moving")
	else:
		state_machine.new_state.emit("Idle")
