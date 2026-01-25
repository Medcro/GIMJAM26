extends CharacterBody2D
class_name player

@export var speed: float = 400.0
@export var max_input: int = 5
@export var arrow_icon_prefab: PackedScene

@onready var arrow_container = get_node("../PathfinderUI/ArrowContainer")

var input_queue: Array = []
var is_moving: bool = false
var num_input := 0

func _process(_delta):
	if not is_moving and num_input < max_input:
		#input user (up, down, left, right)
		if Input.is_action_just_pressed("ui_up"):    add_to_queue(Vector2.UP, 0)
		if Input.is_action_just_pressed("ui_down"):  add_to_queue(Vector2.DOWN, 180)
		if Input.is_action_just_pressed("ui_left"):  add_to_queue(Vector2.LEFT, -90)
		if Input.is_action_just_pressed("ui_right"): add_to_queue(Vector2.RIGHT, 90)
	
	#execute the command from the user	
	if Input.is_action_just_pressed("ui_accept") and not is_moving:
		execute_commands()
		num_input = 0

func add_to_queue(direction: Vector2, rotation_deg: float):
	input_queue.append(direction)
	num_input += 1
	
	var wrapper = Control.new() # create wrapper for the arrow so it could rotate
	wrapper.custom_minimum_size = Vector2(64, 64)
	var new_arrow = TextureRect.new()
	new_arrow.texture = load("res://assets/pathfinder/arrow_placeholder.png")
	new_arrow.custom_minimum_size = Vector2(64, 64)
	new_arrow.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_arrow.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	new_arrow.pivot_offset = Vector2(32, 32)
	new_arrow.rotation_degrees = rotation_deg
	wrapper.add_child(new_arrow)
	arrow_container.add_child(wrapper)

func execute_commands():
	is_moving = true
	
	while input_queue.size() > 0:
		var current_dir = input_queue.pop_front()
		
		if arrow_container.get_child_count() > 0:
			var visual_arrow = arrow_container.get_child(0)
			visual_arrow.queue_free() # update arrow ui after execute 1 command
		
		await move_until_collision(current_dir)
		await get_tree().create_timer(0.1).timeout
	
	is_moving = false

func move_until_collision(direction: Vector2):
	while true:
		var collision = move_and_collide(direction * speed * get_process_delta_time())
		if collision: #if the player collide, it will break
			break
		await get_tree().physics_frame

func reset_input():
	input_queue.clear()
	num_input = 0
	
	for child in arrow_container.get_children():
		child.queue_free()

func _on_pathfinder_ui_reset_requested() -> void:
	if !is_moving:
		reset_input()
