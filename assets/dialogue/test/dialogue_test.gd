extends Node2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@onready var bg_sprite: TextureRect = $Background

func _ready() -> void:
	start_story()

func set_bg(img_name: String) -> void:
	var new_tex = load("res://assets/levels/test/" + img_name + ".png")
	
	var tween = create_tween()
	# Fade out current bg
	tween.tween_property(bg_sprite, "modulate:a", 0.0, 0.5)
	# Switch texture and fade back in
	tween.tween_callback(func(): bg_sprite.texture = new_tex)
	tween.tween_property(bg_sprite, "modulate:a", 1.0, 0.5)

func start_story():
	var resource = load("res://assets/dialogue/test/test.dialogue")
	DialogueManager.show_dialogue_balloon(resource, "start", [self])
