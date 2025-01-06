extends Control

@onready var quit_button = $Quit
@onready var resume_button = $Resume

func _ready():
	#Solution to force buttons to work while game is paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))
	resume_button.connect("pressed", Callable(self, "_on_resume_pressed"))
	
func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed():
	GlobalPause.toggle_unpause()
