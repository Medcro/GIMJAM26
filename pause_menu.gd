extends CanvasLayer

@onready var pause_menu = $PauseMenu
@onready var click_sound = $ClickSound  

func _ready():
<<<<<<< Updated upstream
	pause_menu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()

=======
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.visible = false

>>>>>>> Stashed changes
func _on_pause_button_pressed() -> void:
	get_tree().paused = true
	pause_menu.visible = true

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
<<<<<<< Updated upstream
=======

func _on_quit_button_pressed() -> void:
	get_tree().quit()
>>>>>>> Stashed changes
