class_name StaticNPC extends StaticBody2D

@export var dialogue_sentences: Array[String] = []

var is_entered: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Space") && is_entered:
		print("Talking")
		Dialog.show()
		for sentence in dialogue_sentences:
			Dialog._apply_sentence(sentence)
			await Dialog.sentence_animation.animation_finished
			print("ok ?")
			await Input.is_action_just_pressed("Space")
			print("down")
			
func _on_talk_area_body_entered(body: Node2D) -> void:
	
	if body.is_in_group("player") && !is_entered:
		$PopUp.show()
		is_entered = true
	
	pass

func _on_talk_area_body_exited(body: Node2D) -> void:
	
	if body.is_in_group("player") && is_entered:
		$PopUp.hide()
		is_entered = false
	
	pass
