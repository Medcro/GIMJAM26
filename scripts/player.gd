extends CharacterBody2D
class_name player

signal queue_updated(new_queue: Array, max_size: int)

@export var speed: float = 400.0
@export var max_input: int = 5
@onready 
var input_queue: Array = []
var is_moving: bool = false
var is_turning: bool = false
var current_direction: Vector2 = Vector2.ZERO

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
	if Input.is_action_just_pressed("ui_accept") and not is_moving:
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
		queue_updated.emit(input_queue, max_input)
		
		await move_until_collision()
		await get_tree().create_timer(0.1).timeout
	
	current_direction = Vector2.ZERO
	is_moving = false

func move_until_collision():
	while true:
		if is_turning:
			await  get_tree().physics_frame
			continue

		var collision = move_and_collide(current_direction * speed * get_process_delta_time())
		if collision: 
			break
		await get_tree().physics_frame
