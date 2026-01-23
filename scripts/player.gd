extends CharacterBody2D

@export var speed: float = 400.0
var input_queue: Array = []
var is_moving: bool = false

func _process(_delta):
	if not is_moving:
		#input user (up, down, left, right)
		if Input.is_action_just_pressed("ui_up"): 
			input_queue.append(Vector2.UP)
			print("up")
		if Input.is_action_just_pressed("ui_down"): 
			input_queue.append(Vector2.DOWN)
			print("down")
		if Input.is_action_just_pressed("ui_left"): 
			input_queue.append(Vector2.LEFT)
			print("left")
		if Input.is_action_just_pressed("ui_right"): 
			input_queue.append(Vector2.RIGHT)
			print("right")
	
	#execute the command from the user
	if Input.is_action_just_pressed("ui_accept") and not is_moving:
		execute_commands()
		print("execute")

func execute_commands():
	is_moving = true
	
	while input_queue.size() > 0:
		var current_dir = input_queue.pop_front() #assign the current direction as the first direction in queue
		
		await move_until_collision(current_dir)
		
		await get_tree().create_timer(0.1).timeout
	
	is_moving = false

func move_until_collision(direction: Vector2):
	while true:
		var collision = move_and_collide(direction * speed * get_process_delta_time())
		
		if collision: #if the player collide, it will break
			break

		await get_tree().physics_frame
