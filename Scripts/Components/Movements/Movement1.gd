extends MovementComponent

var steps_counter : int = 0
var current_direction : int = 0

func _ready():
	area.body_entered.connect(stop_walking)
	area.body_exited.connect(start_walking)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if steps_counter <= steps:
		match current_direction:
			0:
				actor.velocity = Vector2.RIGHT * speed
			1:
				actor.velocity = Vector2.UP * speed
			2:
				actor.velocity = Vector2.LEFT * speed
			3:
				actor.velocity = Vector2.DOWN * speed
		
		
		actor.move_and_slide()
		steps_counter += 1
	else:
		current_direction = wrap(current_direction + 1, 0, 4)
		steps_counter = 0

func stop_walking(body : Object):
	if body is Player:
		if actor.get_real_velocity() != actor.velocity:
			set_process(false)


func start_walking(body : Object):
	if body is Player:
		set_process(true)
