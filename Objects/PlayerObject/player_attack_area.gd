extends Area2D


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("attack"):
		visible = true
	else:
		visible = false
