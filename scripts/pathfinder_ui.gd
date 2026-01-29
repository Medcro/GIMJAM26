extends CanvasLayer

@export_group("Textures")
@export var tex_up: Texture2D
@export var tex_down: Texture2D
@export var tex_left: Texture2D
@export var tex_right: Texture2D
@export var tex_dot: Texture2D

@onready var arrow_container = %ArrowContainer
var player_node: Node = null 

func _ready():
	await get_tree().process_frame
	player_node = get_tree().get_first_node_in_group("player")
	
	if player_node:
		player_node.queue_updated.connect(refresh_ui)
		refresh_ui(player_node.input_queue, player_node.max_input)
	
	$UpButton.pressed.connect(func(): _on_dir_pressed(Vector2.UP))
	$DownButton.pressed.connect(func(): _on_dir_pressed(Vector2.DOWN))
	$LeftButton.pressed.connect(func(): _on_dir_pressed(Vector2.LEFT))
	$RightButton.pressed.connect(func(): _on_dir_pressed(Vector2.RIGHT))
	
	$UpButton.mouse_entered.connect(func(): $ButtonHover.play())
	$DownButton.mouse_entered.connect(func(): $ButtonHover.play())
	$LeftButton.mouse_entered.connect(func(): $ButtonHover.play())
	$RightButton.mouse_entered.connect(func(): $ButtonHover.play())

func refresh_ui(queue: Array, max_input: int):
	for child in arrow_container.get_children():
		child.queue_free()
	
	for i in range(max_input):
		var slot = TextureRect.new()
		slot.custom_minimum_size = Vector2(40, 40)
		slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		if i < queue.size():
			slot.texture = get_texture_for_dir(queue[i])
		else:
			slot.texture = tex_dot

		arrow_container.add_child(slot)

func get_texture_for_dir(dir: Vector2) -> Texture2D:
	match dir:
		Vector2.UP: return tex_up
		Vector2.DOWN: return tex_down
		Vector2.LEFT: return tex_left
		Vector2.RIGHT: return tex_right
	return null

func _on_dir_pressed(dir: Vector2):
	$ButtonClicked.play()
	if player_node and not player_node.is_moving and not player_node.is_locked:
		player_node.add_to_queue(dir)
		
		if player_node is PlayerLevel7:
			player_node.execute_commands()

func _on_reset_button_pressed():
	$ButtonClicked.play()
	if player_node and not player_node.is_moving and not player_node.is_locked:
		player_node.reset_queue()

func _on_execute_button_pressed():
	$ButtonClicked.play()
	if player_node and not player_node.is_moving and not player_node.is_locked:
		player_node.execute_commands()

func _on_execute_button_mouse_entered() -> void:
	$ButtonHover.play()
	
func _on_reset_button_mouse_entered() -> void:
	$ButtonHover.play()
	
func _input(event):
	if event.is_action_pressed("move up"):
		$ButtonClicked.play()
	elif event.is_action_pressed("move left"):
		$ButtonClicked.play()
	elif event.is_action_pressed("move down"):
		$ButtonClicked.play()
	elif event.is_action_pressed("move right"):
		$ButtonClicked.play()
