extends Area2D

@onready var Player: player = get_tree().get_first_node_in_group("player")
@onready var sprite: Sprite2D = $Sprite2D

@export var transition_speed:float = 0.1 

var hasRotated = false

func _on_body_entered(body: Node2D) -> void:
	var p = body as player
	p.is_turning = true
	
	var new_dir: Vector2
	
	if !hasRotated:
		new_dir = rotation_clockwise(p.current_direction) # rotate clockwise
	else:
		new_dir = rotation_anticlockwise(p.current_direction) # rotate anticlockwise
	var tween = create_tween().set_parallel(true)
	
	# move the player smoothly on the plate
	tween.tween_property(p, "global_position", global_position, transition_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# flip the plate's sprite smopthly
	tween.tween_property(sprite, "scale:x", 0.0, transition_speed / 2.0)
	tween.chain().tween_property(sprite, "scale:x", 1.0 if sprite.scale.x < 0 else -1.0, transition_speed / 2.0)
	
	await tween.finished
	p.current_direction = new_dir
	p.is_turning = false
	
	hasRotated = !hasRotated

func rotation_clockwise(dir: Vector2) -> Vector2:
	match dir:
		Vector2.UP: return Vector2.RIGHT
		Vector2.DOWN: return Vector2.LEFT
		Vector2.LEFT: return Vector2.UP
		Vector2.RIGHT: return Vector2.DOWN
	return Vector2.ZERO

func rotation_anticlockwise(dir: Vector2) -> Vector2:
	match dir:
		Vector2.UP: return Vector2.LEFT
		Vector2.DOWN: return Vector2.RIGHT
		Vector2.LEFT: return Vector2.DOWN
		Vector2.RIGHT: return Vector2.UP
	return Vector2.ZERO
