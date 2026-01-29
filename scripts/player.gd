extends CharacterBody2D
class_name player

signal queue_updated(new_queue: Array, max_size: int)

@export var speed: float = 400.0
@export var max_input: int = 5
 
@onready var input_queue: Array = []
@onready var is_moving: bool = false
@onready var is_turning: bool = false
@onready var current_direction: Vector2 = Vector2.ZERO

@onready var anim: AnimatedSprite2D = $Sprite2D

func _ready():
	add_to_group("player")

func _process(_delta):
	if not is_moving and input_queue.size() < max_input:
		#input user (up, down, left, right)
		if Input.is_action_just_pressed("ui_up"):    add_to_queue(Vector2.UP)
		if Input.is_action_just_pressed("ui_down"):  add_to_queue(Vector2.DOWN)
		if Input.is_action_just_pressed("ui_left"):  add_to_queue(Vector2.LEFT)
		if Input.is_action_just_pressed("ui_right"): add_to_queue(Vector2.RIGHT)
	
	#execute the command from the user	
	if Input.is_action_just_pressed("space") and not is_moving:
		execute_commands()

func add_to_queue(dir: Vector2):
	if not is_moving and input_queue.size() < max_input:
		input_queue.append(dir)
		queue_updated.emit(input_queue, max_input)

func reset_queue():
	input_queue.clear()
	queue_updated.emit(input_queue, max_input)

func execute_commands():
	is_moving = true
	while input_queue.size() > 0:
		current_direction = input_queue.pop_front()
		update_animation()
		queue_updated.emit(input_queue, max_input)
		
		await move_until_collision()
		await get_tree().create_timer(0.1).timeout
	
	is_moving = false
	update_animation()

func move_until_collision():
	while true:
		if is_turning:
			await  get_tree().physics_frame
			continue

		var collision = move_and_collide(current_direction * speed * get_process_delta_time())
		if collision: 
			#emit_signal(word_added)
			break
		await get_tree().physics_frame

func update_animation():
	var state = "walk" if is_moving else "idle"
	var suffix = ""
	
	if current_direction == Vector2.UP:
		suffix = "_up"
	elif current_direction == Vector2.DOWN:
		suffix = "_down"
	elif current_direction == Vector2.LEFT:
		suffix = "_side"
		anim.flip_h = false # face left
	elif current_direction == Vector2.RIGHT:
		suffix = "_side"
		anim.flip_h = true # face right
	
	anim.play(state + suffix)
