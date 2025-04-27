extends Node2D


var fading := false
var fade_alpha := 0.0
var fade_speed := 1.5  
var target_scene_path := "res://Debug_Room/debug_room.tscn"
var fade_rect: ColorRect
var canvas: CanvasLayer

func _ready():
	
	canvas = CanvasLayer.new()
	canvas.layer = 100  
	add_child(canvas)
	
	
	fade_rect = ColorRect.new()
	fade_rect.anchor_left = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_top = 0
	fade_rect.anchor_bottom = 1
	fade_rect.color = Color(0, 0, 0, 0)
	canvas.add_child(fade_rect)
	
	
	fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade_rect.set_offsets_preset(Control.PRESET_FULL_RECT)

func _process(delta):
	if fading:
		
		fade_alpha = min(fade_alpha + fade_speed * delta, 1.0)
		fade_rect.color = Color(0, 0, 0, fade_alpha)
		
		
		if fade_alpha >= 1.0:
			
			await get_tree().create_timer(0.1).timeout
			get_tree().change_scene_to_file(target_scene_path)

func _input(event):
	if event is InputEventKey and event.pressed and not fading:
		start_fade()

func start_fade():
	if not fading:
		fading = true
		fade_alpha = 0.0  
