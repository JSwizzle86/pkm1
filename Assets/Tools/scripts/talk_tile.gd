class_name TalkTile extends GameTile

@export var object_data: TalkableObjectData

##Define this function for needed interaction
func on_interact(actor: GameTile):
	if is_instance_of(actor, Player):
		DialogueLoad._start_dialogue(object_data, actor)
