class_name TalkingArea extends Area2D

# Pop Up "Press btn to Intract"

func _on_body_entered(body: Object) -> void:
	if body is Player:
		get_parent().can_talk = true
		get_parent().player_node = body
		pass

func _on_body_exited(body: Object) -> void:
	if body is Player:
		get_parent().can_talk = false
		get_parent().player_node = null
		pass
