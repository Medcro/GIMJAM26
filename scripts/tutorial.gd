extends Panel
@onready var bubble: TextureRect = $Bubble
@onready var next_button: TextureButton = $NextButton
@onready var back_button: TextureButton = $BackButton
@onready var label: RichTextLabel = $RichTextLabel
@onready var current_input: int = 1
@onready var tutorial: Panel = $"."
@onready var Player: player = $"../../Player"

@export var max_input: int = 3
@export var current_txt: int = 1
@export var set_label_visible: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.is_locked = true
	Player.is_moving = false
	update_ui()

func update_ui() -> void:
	if current_input == 1:
		back_button.visible = false
	elif current_input > max_input:
		back_button.visible = false
		next_button.visible = false
	else:
		back_button.visible = true
		next_button.visible = true

	if set_label_visible:
		if current_input == 2:
			label.visible = true
		else: label.visible = false
		
	bubble.texture = load("res://assets/tutorial/tutorial " + str(current_txt) + ".png")

func _on_next_button_pressed() -> void:
	current_input += 1
	current_txt += 1
	print(current_input)
	update_ui()
	
	if max_input < current_input:
		Player.is_locked = false
		Player.is_moving = true
		tutorial.visible = false

func _on_back_button_pressed() -> void:
	current_input -= 1
	current_txt -= 1
	print(current_input)
	update_ui()
