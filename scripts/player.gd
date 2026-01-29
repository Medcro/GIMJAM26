extends CharacterBody2D
class_name player

signal queue_updated(new_queue: Array, max_size: int)

@export var speed: float = 400.0
@export var max_input: int = 5

@export var dialogue_resource: DialogueResource
 
@onready var input_queue: Array = []
@onready var is_moving: bool = false
@onready var is_turning: bool = false
@onready var current_direction: Vector2 = Vector2.ZERO

@onready var anim: AnimatedSprite2D = $Sprite2D

@onready var is_locked: bool = false

@onready var num_input := 0
@onready var is_in_endpoint: bool = false
@onready var has_collected_memory: bool = false

func _ready():
	add_to_group("player")

func _process(_delta):
	if not is_moving and not is_locked and input_queue.size() < max_input:
		#input user (up, down, left, right)
		if Input.is_action_just_pressed("ui_up"):    add_to_queue(Vector2.UP)
		if Input.is_action_just_pressed("ui_down"):  add_to_queue(Vector2.DOWN)
		if Input.is_action_just_pressed("ui_left"):  add_to_queue(Vector2.LEFT)
		if Input.is_action_just_pressed("ui_right"): add_to_queue(Vector2.RIGHT)
	
	#execute the command from the user	
	if Input.is_action_just_pressed("space") and not is_moving and not is_locked:
		execute_commands()
		num_input = 0

func add_to_queue(dir: Vector2):
	if not is_moving and input_queue.size() < max_input:
		input_queue.append(dir)
		num_input += 1
		queue_updated.emit(input_queue, max_input)

func reset_queue():
	input_queue.clear()
	num_input = 0
	queue_updated.emit(input_queue, max_input)

func execute_commands():
	is_moving = true
	while input_queue.size() > 0:
		current_direction = input_queue.pop_front()
		update_animation()
		queue_updated.emit(input_queue, max_input)
		
		await move_until_collision()
	
	is_moving = false
	update_animation()

	if not is_in_endpoint:
		await show_dialogue_and_wait("exited_without_memory")
		reset_level()
	elif not has_collected_memory:
		await show_dialogue_and_wait("fail_to_exit")
		reset_level()
	else:
		print("Berhasil")

func move_until_collision():
	while true:
		if not is_inside_tree():
			return
		if is_turning or is_locked:
			await  get_tree().physics_frame
			if not is_inside_tree():
				return
			continue

		var collision = move_and_collide(current_direction * speed * get_process_delta_time())
		if collision: 
			
			break
		await get_tree().physics_frame
		if not is_inside_tree():
			return

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

func reset_level():
	await get_tree().create_timer(0.1).timeout
	set_process(false)
	set_physics_process(false)
	get_tree().reload_current_scene()

func show_dialogue_and_wait(title: String):
	is_locked = true
	var balloon = DialogueManager.show_dialogue_balloon(dialogue_resource, title, [self])
	await balloon.tree_exited
	
