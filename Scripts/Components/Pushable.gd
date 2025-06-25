extends Component


@export var friction = 1000

func _process(_delta):
	for i in actor.get_colliding_bodies():
		if i is Player:
			actor.add_central_impulse(actor.get_collider().velocity/1000)
