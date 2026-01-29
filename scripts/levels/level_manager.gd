extends Node2D
class_name LevelManager

@export var next_level: String
@export var current_level: String

func go_to_next_lvl() ->  void:
	if load("res://scenes/levels/" + next_level + ".tscn") != null:
		LevelTransition.change_scene("res://scenes/levels/" + next_level + ".tscn")
	else:
		LevelTransition.change_scene("res://scenes/days/" + next_level + ".tscn")
