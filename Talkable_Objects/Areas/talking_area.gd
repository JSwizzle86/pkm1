class_name TalkingArea extends Area2D

# Pop Up "Press btn to Intract"

func _on_body_entered(body: Player) -> void:
	get_parent().can_talk = true
	pass

func _on_body_exited(body: Player) -> void:
	get_parent().can_talk = false
	pass
