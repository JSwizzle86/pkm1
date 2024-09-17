class_name TalkableObject2D extends CharacterBody2D

var player_node: Player =  null

@export var object_data: TalkableObjectData = null
var can_talk: bool = false
var is_talking: bool = false

func _input(event):
	if can_talk and event.is_action_pressed("DialogueInteract") and !is_talking:
		can_talk = false
		is_talking = true
		DialogueLoad._start_dialogue(object_data, self)
