extends Control

@onready var pause_menu = $PauseMenu

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.visible = false

func _on_pause_button_pressed() -> void:
	$ButtonClicked.play()
	get_tree().paused = true
	pause_menu.visible = true

func _on_resume_button_pressed() -> void:
	$ButtonClicked.play()
	get_tree().paused = false
	pause_menu.visible = false
	
func _on_quit_button_pressed() -> void:
	$ButtonClicked.play()
	get_tree().paused = false
	LevelTransition.change_scene("res://scenes/main menu/level_select.tscn")

func _on_resume_button_mouse_entered() -> void:
	$ButtonHover.play()
	
func _on_quit_button_mouse_entered() -> void:
	$ButtonHover.play()

func _on_pause_button_mouse_entered() -> void:
	$ButtonHover.play()
