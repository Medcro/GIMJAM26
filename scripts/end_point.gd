extends Area2D

@onready var level_manager: LevelManager = get_parent()
@onready var Player: player = $"../Player"

@onready var dialogue_resource: DialogueResource = load("res://assets/dialogue/death.dialogue")

func _on_body_entered(body: Node2D) -> void:
	if body is player or body is PlayerLevel7:
		Player.is_in_endpoint = true
		if Player.has_collected_memory:
			SaveManager.unlocked_levels[level_manager.current_level] = true
			SaveManager.save_game()
			level_manager.go_to_next_lvl()
		else:
			DialogueManager.show_dialogue_balloon(dialogue_resource, "fail_to_exit")
			get_tree().reload_current_scene()
