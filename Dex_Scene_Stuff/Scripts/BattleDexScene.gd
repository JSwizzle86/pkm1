extends Control

@onready var scene_transition = $SceneTransition
@onready var color_rect = $ColorRect

var dex_data = []

var menu_sequence = []

#just add new scenes into here if you want them
var dex_selection_scene = preload("res://Dex_Scene_Stuff/Scenes/dex_selection_scene.tscn")
var battle_data_scene = preload("res://Dex_Scene_Stuff/Scenes/battle_data_scene.tscn")
var map_scene = preload("res://Dex_Scene_Stuff/Scenes/map_scene.tscn")

@export var menu_forward : String = "ui_right"
@export var menu_select : String = "ui_select"
@export var menu_backwards : String = "ui_left"
@export var move_up : String = "ui_up"
@export var move_down : String = "ui_down"

var active_menu

func _ready():
	create_menus()
	open_menu()

func create_menus():
	var d = dex_selection_scene.instantiate()
	add_child(d)
	d.global_position = global_position
	menu_sequence.append(d)
	d.visible = false
	print(menu_sequence)
	
	var b = battle_data_scene.instantiate()
	add_child(b)
	b.global_position = global_position
	menu_sequence.append(b)
	b.visible = false
	
	var m = map_scene.instantiate()
	add_child(m)
	m.global_position = global_position
	menu_sequence.append(m)
	move_child(color_rect, get_children().size()-1)
	m.visible = false

func _unhandled_input(event):
	pass

func open_menu():
	scene_transition.play("Open")
	await scene_transition.animation_finished
	menu_sequence.front().visible = true
	scene_transition.play("Close")


func close_menu():
	pass
