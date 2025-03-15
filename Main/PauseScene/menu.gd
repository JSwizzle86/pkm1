extends Control

@onready var select_arrow = $NinePatchRect/TextureRect
@onready var menu = $"."
@onready var player = $"PlayerHolder/PKM!Player"

enum ScreenLoaded {NOTHING, JUST_MENU, DEX, USERINFO, INVENTORY, SAVE, SETTINGS, EXIT}
var screen_loaded = ScreenLoaded.NOTHING

var selected_option: int = 0
var columns = 7
var row = selected_option / columns


func _ready():
	grab_focus()
	menu.visible = false
	select_arrow.position.y = row * 22 + (22 - 41) / 2

	
func _process(delta):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if Input.is_action_just_pressed("pause"):
				print(player)
				if !player.is_moving():	
					player._process(false)
					menu.visible = true
					screen_loaded = ScreenLoaded.JUST_MENU
				
		ScreenLoaded.JUST_MENU:
			if Input.is_action_just_pressed("pause") or Input.is_action_pressed("Back"):
				player._process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
			elif Input.is_action_pressed("ui_down"):
				selected_option += 1
				row = selected_option / columns
				select_arrow.position.y = row * 22 + (22 - 41) / 2
			elif Input.is_action_pressed("ui_up"):
				if selected_option == 0:
					selected_option = 6
					row = selected_option / columns
				else:
					selected_option -= 1
					row = selected_option / columns
				select_arrow.position.y = row * 22 + (22 - 41) / 2
	
	
