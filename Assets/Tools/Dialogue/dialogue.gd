class_name Dialogue extends CanvasLayer

var player_tile:Player

@onready var name_label: Label = %Name
@onready var char_texture: TextureRect = %CharacterTexture
@onready var sentence_label: Label = %Sentence
@onready var typing_timer: Timer = %TypingSpeedTimer
var sentences: Array[String] = []

@export var normal_speed: float = 0.05
@export var fast_speed: float = 0.01
var typing_speed: float = normal_speed

var current_sentence_index: int = 0
var full_text: String = ""
var current_text: String = ""
var char_index: int = 0
var talking: bool = false
var finished: bool = true

func _ready() -> void:
	_reset_dialogue()

func _reset_dialogue() -> void:
	set_process_input(false)
	name_label.text = ""
	char_texture.texture = null
	sentences = []
	current_sentence_index = 0
	typing_speed = normal_speed
	sentence_label.text = ""

func _start_dialogue(resource: TalkableObjectData, player: Player) -> void:
	finished = false
	player_tile = player
	show()
	set_process_input(true)
	sentences = resource._sentences
	
	# Simple way. to make player can't control.
	player_tile.set_process(false)
	
	if sentences.size() > 0:
		current_sentence_index = 0
		name_label.text = resource._name
		char_texture.texture = resource._texture
		show_sentence()

func show_sentence():
		full_text = sentences[current_sentence_index]
		current_text = ""
		char_index = 0
		sentence_label.text = ""
		talking = true
		typing_timer.start(typing_speed)

func _on_typing_speed_timer_timeout() -> void:
	if talking and char_index < full_text.length():
		current_text += full_text[char_index]
		sentence_label.text = current_text
		char_index += 1
		typing_timer.start(typing_speed)
	else:
		talking = false

func _input(event: InputEvent):
	if event.is_action_pressed("DialogueInteract") and talking:
		typing_speed = fast_speed
	
	elif event.is_action_pressed("DialogueInteract") and !talking and !finished:
		typing_speed = normal_speed
		print("input detected 1")
		if current_sentence_index < sentences.size() - 1:
			current_sentence_index += 1
			show_sentence()
		else:
			finished = true
			hide()
	elif finished:
		print("input detected 2")
		player_tile.set_process(true)
		_finish_dialogue()
		
	elif event.is_action_pressed("DialogueSkip"):
		skip_dialogue()

func skip_dialogue():
	current_sentence_index = sentences.size() - 1
	talking = false
	sentence_label.text = sentences[current_sentence_index]

func _finish_dialogue() -> void:
	hide()
	_reset_dialogue()
	
