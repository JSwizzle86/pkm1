class_name TalkableObject2D extends Area2D

#@export var object_data: TalkableObjectData
var player_node: Player
var is_talking: bool = false

func _interact(object_data: TalkableObjectData, player: Player) -> void:
	player_node = player
	DialogueLoad._start_dialogue(object_data, self)
