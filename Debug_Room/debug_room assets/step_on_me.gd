class_name StepOnMe extends GameTile

@export var object_data: TalkableObjectData

func on_step(actor: GameTile):
	if is_instance_of(actor, Player):
		DialogueLoad._start_dialogue(object_data, actor)
