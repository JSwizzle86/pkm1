class_name TalkableObject2D extends Area2D

@export var object_data: TalkableObjectData = null

func interact() -> void:
	DialogueLoad._start_dialogue(object_data, self)
