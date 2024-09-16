class_name StaticNPC extends StaticBody2D

# Can Talk Prepering.

@export_multiline var dialogue_sentences: Array[String] = []
@export var character_texture: Texture2D = null
@export var sentence_animation_speed: float = 1.0
var current_index: int = 0
var current_sentence: String = ""
var last_sentence: bool = false
var can_talk: bool = false

func _input(event):
	if can_talk and event.is_action_pressed("DialogueAccept") and !Dialog.is_talking:
		if Dialog.is_last:
			Dialog._reset_dialogue()
			Dialog.hide()
		else:
			Dialog.show()
			talk()

func talk():
	if current_index < dialogue_sentences.size():
		if (dialogue_sentences.size() - current_index) == 1:
			current_sentence = dialogue_sentences[current_index]
			
			Dialog._apply_dialogue(character_texture, current_sentence, sentence_animation_speed, true)
			current_index = 0
		elif (dialogue_sentences.size() - current_index) > 1:
			current_sentence = dialogue_sentences[current_index]
			
			Dialog._apply_dialogue(character_texture, current_sentence, sentence_animation_speed, false)
			
			current_index += 1

func _on_talk_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player") && !can_talk:
		$PopUp.show()
		can_talk = true
	
	pass

func _on_talk_area_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("player") && can_talk:
		$PopUp.hide()
		can_talk = false
	
	pass
