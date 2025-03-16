extends Control

@onready var select_arrow = $NinePatchRect/TextureRect
@onready var menu = $"."
@onready var player: Player = $"/root/Main/PlayerHolder/PKM!Player"

enum ScreenLoaded {NOTHING, JUST_MENU, DEX, USERINFO, INVENTORY, SAVE, SETTINGS, EXIT}
var screen_loaded = ScreenLoaded.NOTHING

var selected_option: int = 0
var columns = 7
var row = selected_option / columns


func _ready():
	grab_focus()
	menu.visible = false
	updateArrowPosition()

	
func _process(delta):
	match screen_loaded:
		ScreenLoaded.NOTHING:
			if Input.is_action_just_pressed("pause"):
				if player.state_machine.current_state == player.state_machine.State.Idle:
					player.set_process(false)
					player.set_physics_process(false)
					menu.visible = true
					screen_loaded = ScreenLoaded.JUST_MENU
				
		ScreenLoaded.JUST_MENU:
			if Input.is_action_just_pressed("pause") or Input.is_action_pressed("Back"):
				player.set_process(true)
				player.set_physics_process(true)
				menu.visible = false
				screen_loaded = ScreenLoaded.NOTHING
			elif Input.is_action_pressed("ui_down"):
				selected_option += 1
				row = selected_option / columns
				updateArrowPosition()
			elif Input.is_action_pressed("ui_up"):
				if selected_option == 0:
					selected_option = 6
					row = selected_option / columns
				else:
					selected_option -= 1
					row = selected_option / columns
				updateArrowPosition()
	
func updateArrowPosition():
	select_arrow.position.y = row * 22 + (22 - 41) / 2
