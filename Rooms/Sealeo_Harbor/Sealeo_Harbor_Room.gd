extends BaseRoom


var current_scene = "res://Rooms/Sealeo_Harbor/sealeo_harbor_room.tscn"
var tideshore = preload("res://Rooms/Tideshore_Park/Tideshore_Park.tscn").instantiate()

func _ready() -> void:
	super._ready()
