extends CharacterBody2D
class_name player

signal queue_updated(new_queue: Array, max_size: int)

@export var speed: float = 400.0
@export var max_input: int = 5
@onready 
var input_queue: Array = []
var is_moving: bool = false
var num_input := 0
var is_in_endpoint: bool = false
var has_collected_memory: bool = false

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
		num_input = 0
		
func _on_endpoint_body_entered(body: Node2D) -> void:
	if body is player:
		is_in_endpoint = true
		
func _on_endpoint_body_exited(body: Node2D) -> void:
	if body is player:
		is_in_endpoint = false
		
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

func _on_area_entered(area: Area2D) -> void:
	if area is MemoryBubble:
		has_collected_memory = true
		area.queue_free()
		print("Memory diambil")
		
func execute_commands():
	is_moving = true
	while input_queue.size() > 0:
		current_direction = input_queue.pop_front()
		queue_updated.emit(input_queue, max_input)
		
		await move_until_collision()
		await get_tree().create_timer(0.1).timeout
	
	current_direction = Vector2.ZERO
	is_moving = false
	
	await get_tree().create_timer(0.5).timeout # Beri jeda sebentar
	
	if not is_in_endpoint or not has_collected_memory:
		print("Gagal")
		reset_level()
	else:
		print("Berhasil")

func move_until_collision():
	while true:
		if is_turning:
			await  get_tree().physics_frame
			continue

		var collision = move_and_collide(current_direction * speed * get_process_delta_time())
		if collision: 
			emit_signal(word_added)
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

func reset_level():
	has_collected_memory = false
	get_tree().reload_current_scene()
