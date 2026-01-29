@export_file("*.tscn") var next_scene_path: String

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if GlobalSettings.word >= 1:
			trigger_win()
		else:
			print("Kumpulkan item terlebih dahulu!")

func trigger_win():
	GlobalSettings.reset_level_data()
	
	# Harusnya ini ganti level
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("Error!")
