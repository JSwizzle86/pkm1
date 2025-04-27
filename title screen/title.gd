extends Node2D

# Transition control
var fading := false
var fade_alpha := 0.0
var fade_speed := 1.5  # Faster fade by default
var target_scene_path := "res://Debug_Room/debug_room.tscn"
var fade_rect: ColorRect
var canvas: CanvasLayer

func _ready():
	# Create fade overlay system
	canvas = CanvasLayer.new()
	canvas.layer = 100  # Very high layer to ensure it's on top
	add_child(canvas)
	
	# Configure full-screen fade rectangle
	fade_rect = ColorRect.new()
	fade_rect.anchor_left = 0
	fade_rect.anchor_right = 1
	fade_rect.anchor_top = 0
	fade_rect.anchor_bottom = 1
	fade_rect.color = Color(0, 0, 0, 0)
	canvas.add_child(fade_rect)
	
	# Force update margins (important for Godot 4)
	fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade_rect.set_offsets_preset(Control.PRESET_FULL_RECT)

func _process(delta):
	if fading:
		# Update fade progress
		fade_alpha = min(fade_alpha + fade_speed * delta, 1.0)
		fade_rect.color = Color(0, 0, 0, fade_alpha)
		
		# When fully faded, change scene
		if fade_alpha >= 1.0:
			# Optional: Add a small delay for better effect
			await get_tree().create_timer(0.1).timeout
			get_tree().change_scene_to_file(target_scene_path)

func _input(event):
	if event is InputEventKey and event.pressed and not fading:
		start_fade()

func start_fade():
	if not fading:
		fading = true
		fade_alpha = 0.0  # Reset alpha when starting new fade
