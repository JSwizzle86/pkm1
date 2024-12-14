extends Node

@export var state_machine : StateMachine
@export var animation : AnimatedSprite2D

func _ready():
	state_machine.update_anim.connect(change_anim)
	change_anim()


func change_anim():
	if state_machine.current_state == StateMachine.State.Idle:
		idle_anim()
		set_process(false)
	elif state_machine.current_state == StateMachine.State.Running or state_machine.current_state == StateMachine.State.Walking:
		set_process(true)

func _process(_delta):
	if state_machine.current_state == StateMachine.State.Walking:
		walk_anim()
	elif state_machine.current_state == StateMachine.State.Running:
		run_anim()

func walk_anim():
	match state_machine.movement_direction:
		0:
			animation.play("left")
		1:
			animation.play("right")
		2:
			animation.play("down")
		3:
			animation.play("up")

func run_anim():
	match state_machine.movement_direction:
		0:
			animation.play("run_left")
		1:
			animation.play("run_right")
		2:
			animation.play("run_down")
		3:
			animation.play("run_up")

func idle_anim():
	match state_machine.movement_direction:
		0:
			animation.play("left")
			animation.pause()
			animation.frame = 0
		1:
			animation.play("right")
			animation.pause()
			animation.frame = 0
		2:
			if animation.animation != "stop_down":
				animation.play("stop_down")
		3:
			animation.play("up")
			animation.pause()
			animation.frame = 0
