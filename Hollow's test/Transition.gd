extends AnimationPlayer

@onready var end_animation : bool = false

func _ready():
	current_animation = "Transition"

func _process(delta):
	#pause it when at half the animation length
	if !end_animation and is_playing() and current_animation_position == current_animation_length / 2:
		pause()
	#continue playing when we enable the bool
	if end_animation and get_playing_speed() == 0:
		play("Transition", current_animation_length / 2)
	#reset the animation when it ends
	if end_animation and current_animation_position == current_animation_length:
		end_animation = false
		stop()
