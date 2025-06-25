extends CanvasLayer

var timer : Timer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = 2
	timer.timeout.connect(hide_panel)
	add_child(timer)

	Global.room_entered.connect(show_room_name)

func show_room_name(room_name : String):
	if !timer.is_stopped():
		timer.stop()
	%RoomName.hide()
	%RoomNameLabel.text = room_name
	%RoomName.show()
	timer.start()

func hide_panel():
	%RoomName.hide()
