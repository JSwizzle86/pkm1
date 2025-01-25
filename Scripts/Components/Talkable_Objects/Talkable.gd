extends Component

var can_talk : bool = false
var is_talking: bool = false
@export var talk_data : TalkableObjectData
@export var movement_comp : MovementComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	area.area_entered.connect(start_interaction)
	area.area_exited.connect(stop_interaction)
	

func start_interaction(area : Area2D):
	print(area)
	if area.name == "NpcRay":
		set_process_input(true)
		Global.player_node = area.get_parent().get_parent()
		can_talk = true

func stop_interaction(area : Area2D):
	if area.name == "NpcRay":
		set_process_input(false)
		can_talk = false

func _input(event):
	if talk_data:
		if can_talk and event.is_action_pressed("DialogueInteract") and !is_talking:
	#		can_talk = false
			is_talking = true
			Global.dialogue._start_dialogue(talk_data, self)
			if movement_comp:
				movement_comp.set_process(false)
				movement_comp.set_physics_process(false)
