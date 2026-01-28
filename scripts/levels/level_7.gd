extends Node2D

@export var Player: player 

func _ready() -> void:
	$AnimationPlayer.play("awan_geser")

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	Player.is_moving = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Player.is_moving = false
