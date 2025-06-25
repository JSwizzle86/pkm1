extends Area2D

@export var spawn_position: Vector2 = Vector2(0,100)
@onready var current_scene = $"../../../../.."
var tideshore = preload("res://Rooms/Tideshore_Park/Tideshore_Park.tscn").instantiate()


func _on_body_entered(body: Node2D) -> void:
		if body.name == "PKM!Player":
			Global._add_scene_manually(tideshore, spawn_position)
			Global._remove_scene_manually(current_scene)
