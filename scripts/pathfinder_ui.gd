extends CanvasLayer

signal reset_requested

func _on_reset_button_pressed():
	reset_requested.emit()
