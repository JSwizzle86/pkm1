extends MiniState

var timer : Timer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(play_rand)
	add_child(timer)
	state_machine.new_state.connect(set_state)


func set_state(is_idle):
	if is_idle == "Idle":
		active = true
		state_machine.current_mini_state = self
		state_machine.current_state = StateMachine.State.Idle
		state_machine.animation_handler.idle_anim()
		state_machine.collision_handler.update_hit_box(state_machine.movement_direction)
		timer.wait_time = randf_range(8,12)
		timer.start()
	else:
		active = false

func _process(delta: float) -> void:
	handle_attacks()
	handle_input()
	

func handle_input():
	if state_machine.current_mini_state == self && active:
		if Input.get_vector("Left", "Right", "Up", "Down"):
			state_machine.new_state.emit("Moving")
			print("Moving")
			timer.stop()
	else:
		if state_machine.current_mini_state != self && !state_machine.current_mini_state.active:
			state_machine.new_state.emit("Idle")
			print("back to Idle")
	


func handle_attacks():
	if Input.is_action_just_pressed("attack"):
		state_machine.new_attack_state.emit("Attacking")
		print("Speeen (Atacking)")
		timer.stop()


func play_rand():
	state_machine.animation_handler.play_other_idle(self)
	timer.wait_time = randf_range(10,20)
