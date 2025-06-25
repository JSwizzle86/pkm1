extends MovementComponent

@export var nav : NavigationAgent2D
@export var ray : Area2D
var touching_player : bool = false

func _ready() -> void:
	rand_pos()
	nav.target_reached.connect(target_reached)
	ray.body_entered.connect(ray_body_entered)
	ray.body_exited.connect(ray_body_exited)

func _process(delta):
	var dir = actor.position.direction_to(nav.target_position)
	if actor.position.distance_to(nav.target_position) < 1.0:
		target_reached()
		return
	actor.velocity = dir * speed
	actor.move_and_slide()

func target_reached():
	set_process(false)
	await get_tree().create_timer(1).timeout
	rand_pos()
	set_process(true)

func rand_pos():
	var pos = Vector2(actor.position.x + randi_range(-20, 20),actor.position.y + randi_range(-20, 20))
	nav.target_position = pos
	if !nav.is_target_reachable():
		await get_tree().create_timer(1).timeout
		rand_pos()


func ray_body_entered(body : Object):
	if body is Player:
		touching_player = true
		set_process(false)
		set_physics_process(false)

func ray_body_exited(body : Object):
	if body is Player:
		if Global.dialogue.talkable_object != actor:
			touching_player = false
			await get_tree().create_timer(0.5).timeout
			set_process(true)
			set_physics_process(true)


func set_processes():
	if touching_player:
		return
	
	set_process(true)
	set_physics_process(true)
