extends Node2D

@export var Player: player 
@export var dialogue_resource: DialogueResource

var move_count = 0
var is_dialogue_pending = false

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("awan_geser")

func _on_animation_player_animation_started(_anim_name: StringName) -> void:
	if Player: Player.is_locked = true
	is_dialogue_pending = false

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if not is_dialogue_pending:
		if Player: Player.is_locked = false

func _on_nenek_body_entered(body: Node2D) -> void:
	if body is player:
		if anim.is_playing(): return
		
		match move_count:
			0:
				is_dialogue_pending = true
				anim.play("nenek_geser_1")
				start_dialogue("first")
			1:
				anim.play("nenek_geser_2")
			2:
				is_dialogue_pending = true
				anim.play("nenek_geser_3")
				start_dialogue("second")
			3:
				anim.play("nenek_geser_4")
			4:
				is_dialogue_pending = true
				anim.play("nenek_geser_5")
				start_dialogue("third")
		
		move_count += 1

func start_dialogue(word: String):
	var balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, word)
	
	balloon.tree_exited.connect(func():
		is_dialogue_pending = false
		if Player: Player.is_locked = false
	)
