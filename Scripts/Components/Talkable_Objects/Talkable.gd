extends Component

var can_talk : bool = false
var is_talking: bool = false
@export var talk_data : TalkableObjectData
@export var movement_comp : MovementComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	area.body_entered.connect(start_interaction)
	area.body_exited.connect(stop_interaction)

func start_interaction(body : Object):
	if body is Player:
		set_process_input(true)
		Global.player_node = body
		can_talk = true

func stop_interaction(body : Object):
	if body is Player:
		set_process_input(false)
	#	Global.player_node = null
		can_talk = false

func _input(event):
	if talk_data:
		if can_talk and event.is_action_pressed("DialogueInteract") and !is_talking:
			can_talk = false
			is_talking = true
			Global.dialogue._start_dialogue(talk_data, self)
			if movement_comp:
				movement_comp.set_process(false)
				movement_comp.set_physics_process(false)
