extends Node2D

@export var next_level: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func go_to_next_lvl() ->  void:
	if load("res://scenes/levels/" + next_level + ".tscn") != null:
		get_tree().change_scene_to_file("res://scenes/levels/" + next_level + ".tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/days/" + next_level + ".tscn")
