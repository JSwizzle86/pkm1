class_name StaticNPC extends CharacterBody2D

@export var NPC_data: TalkableObjectResource = null
var can_talk: bool = false
var is_talking: bool = false

func _input(event):
	if can_talk and event.is_action_pressed("DialogueInteract") and !is_talking:
		can_talk = false
		is_talking = true
		DialogueLoad._start_dialogue(NPC_data, self)
