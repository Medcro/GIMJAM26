extends Node2D
class_name dialogue

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var num_day: String = "2"
@export var current_level: String

@onready var bg_sprite: TextureRect = $Background
@onready var flashback_ui: ColorRect = %FlashbackEffect
@onready var balloon_node = DialogueManager.show_dialogue_balloon(dialogue_resource, "start")

func _ready() -> void:
	balloon_node.dialogue_skipped.connect(go_to_next_lvl)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	start_story()

func set_bg(img_name: String) -> void:
	var new_tex = load("res://assets/levels/day " + num_day + "/" + img_name + ".png")
	
	var tween = create_tween()
	# Fade out current bg
	tween.tween_property(bg_sprite, "modulate:a", 0.0, 0.5)
	# Switch texture and fade back in
	tween.tween_callback(func(): bg_sprite.texture = new_tex)
	tween.tween_property(bg_sprite, "modulate:a", 1.0, 0.5)

func set_flashback(active: bool) -> void:
	var tween = create_tween()
	if active:
		# Change color to Sepia or Light Gray
		flashback_ui.color = Color(0.7, 0.6, 0.4, 0.3) # Vintage Sepia
		tween.tween_property(flashback_ui, "self_modulate:a", 1.0, 1.0)
	else:
		tween.tween_property(flashback_ui, "self_modulate:a", 0.0, 1.0)

func start_story():
	SaveManager.current_level = current_level
	DialogueManager.show_dialogue_balloon(dialogue_resource, "start", [self])

func go_to_next_lvl() ->  void:
	if load("res://scenes/levels/" + current_level + ".tscn") != null:
		LevelTransition.change_scene("res://scenes/levels/" + current_level + ".tscn")
	else:
		LevelTransition.change_scene("res://scenes/days/" + current_level + ".tscn")

func _on_dialogue_ended(dialogue_resource: DialogueResource):
	go_to_next_lvl()
