class_name DialogueSystem extends CanvasLayer

@onready var sentence_animation: AnimationPlayer = %SentenceAnimation
@onready var character_texture: TextureRect = %Character
@onready var current_sentence: Label = %Sentence

var is_talking: bool = false
var is_last: bool = false

func _reset_dialogue() -> void:
	is_talking = false
	is_last = false
	
	character_texture.texture = null
	current_sentence.text = ""
	
	sentence_animation.play("RESET")
	sentence_animation.set_speed_scale(1.0)
	
	pass

func _apply_dialogue(texture: Texture2D, sentence: String, speed: float, last_sentence: bool) -> void:
	is_talking = true
	
	character_texture.texture = texture
	current_sentence.text = sentence
	
	sentence_animation.play("talking_animation")
	sentence_animation.set_speed_scale(speed)
	
	await sentence_animation.animation_finished
	
	if last_sentence:
		is_talking = false
		is_last = true
	else:
		is_talking = false
		is_last = false
	
	pass
