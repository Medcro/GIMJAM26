extends Area2D

@export var is_clockwise: bool = true
@export var transition_speed: float = 0.1

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	add_to_group("plates")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body is player:
		rotate_player(body)
		get_tree().call_group("plates", "toggle_mode")

func rotate_player(p: player):
	p.is_turning = true
	var new_dir = rotation_anticlockwise(p.current_direction) if is_clockwise else rotation_clockwise(p.current_direction)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(p, "global_position", global_position, transition_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished
	p.current_direction = new_dir
	p.is_turning = false
	
func toggle_mode():
	is_clockwise = !is_clockwise

	if is_clockwise:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

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
