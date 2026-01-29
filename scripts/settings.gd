extends Control

@onready var music_slider: HSlider = $MusicControl
@onready var sfx_slider: HSlider = $SFXControl

var music_bus_id
var sfx_bus_id

func _ready():
	music_bus_id = AudioServer.get_bus_index("Music")
	sfx_bus_id = AudioServer.get_bus_index("SFX")
	
	music_slider.value = GlobalSettings.music_volume
	sfx_slider.value = GlobalSettings.sfx_volume

func _on_music_control_value_changed(value: float) -> void:
	if music_bus_id != -1:
		AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	GlobalSettings.music_volume = value

func _on_music_control_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalSettings.save_settings()

func _on_sfx_control_value_changed(value: float) -> void:
	if sfx_bus_id != -1:
		AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	GlobalSettings.sfx_volume = value

func _on_sfx_control_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GlobalSettings.save_settings()

func _on_reset_data_pressed() -> void:
	SaveManager.reset_data()
