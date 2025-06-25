extends Node

@export var state_machine : StateMachine
@export var animation : AnimatedSprite2D
@export var turn_node : MiniState
func _ready():
	state_machine.update_anim.connect(change_anim)
	animation.animation_finished.connect(animation_finished)
	change_anim()


func change_anim():
	if state_machine.attacking_state == StateMachine.Attack.None:
		if state_machine.current_state == StateMachine.State.Idle && state_machine.attacking_state == StateMachine.Attack.None:
			idle_anim()
			set_process(false)
		
		if state_machine.current_state == StateMachine.State.Running or state_machine.current_state == StateMachine.State.Walking:
			set_process(true)
	elif state_machine.attacking_state != StateMachine.Attack.None:
		set_process(false)

func _process(_delta):
	if state_machine.current_state == StateMachine.State.Walking:
		walk_anim()
	elif state_machine.current_state == StateMachine.State.Running:
		run_anim()

func walk_anim():
	match state_machine.movement_direction:
		Vector2.LEFT:
			animation.play("left")
		Vector2.RIGHT:
			animation.play("right")
		Vector2.DOWN:
			animation.play("down")
		Vector2.UP:
			animation.play("up")

func run_anim():
	match state_machine.movement_direction:
		Vector2.LEFT:
			animation.play("run_left")
		Vector2.RIGHT:
			animation.play("run_right")
		Vector2.DOWN:
			animation.play("run_down")
		Vector2.UP:
			animation.play("run_up")

func idle_anim():
	match state_machine.movement_direction:
		Vector2.LEFT:
			animation.play("left")
			animation.pause()
			animation.frame = 1
		Vector2.RIGHT:
			animation.play("right")
			animation.pause()
			animation.frame = 1
		Vector2.DOWN:
			if animation.animation != "stop_down":
				animation.play("stop_down")
		Vector2.UP:
			animation.play("up")
			animation.pause()
			animation.frame = 1


func attack_anim(attack_node : MiniState):
	match state_machine.movement_direction:
		Vector2.LEFT:
			animation.play("attack_left")
		Vector2.RIGHT:
			animation.play("attack_right")
		Vector2.DOWN:
			animation.play("attack_down")
		Vector2.UP:
			animation.play("attack_up")
	
	if animation.is_playing():
		await animation.animation_finished
		attack_node.exist_state()

func play_other_idle(_idle_node : MiniState):
	if state_machine.movement_direction == Vector2.DOWN:
		animation.play("idle_down")
		print("test")


func play_turning(turn):
	turn_node = turn
	match state_machine.movement_direction:
		Vector2.LEFT:
			animation.play("turn_left")
		Vector2.RIGHT:
			animation.play("turn_right")
		Vector2.DOWN:
			animation.play("turn_down")
		Vector2.UP:
			animation.play("turn_up")


func animation_finished():
	if animation.animation in ["turn_left", "turn_right","turn_down", "turn_up"]:
		turn_node.exist_state()
