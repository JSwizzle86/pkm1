extends CanvasLayer

@onready var sentence_animation: AnimationPlayer = %SentenceAnimation

func _apply_character_texture(texture: Texture2D) -> void:
	%Character.texture = texture
	pass

func _apply_sentence(sentence: String) -> void:
	%Sentence.text = sentence
	sentence_animation.play("talking_animation")
	pass
