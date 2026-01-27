extends Button

@onready var normal_image = $"../PauseImage"
@onready var clicked_image = $"../PauseImageClicked"

func _ready():
	normal_image.visible = true
	clicked_image.visible = false

	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_mouse_entered():
	clicked_image.visible = true
	normal_image.visible = false

func _on_mouse_exited():
	clicked_image.visible = false
	normal_image.visible = true

func _on_button_down():
	clicked_image.visible = true
	normal_image.visible = false

func _on_button_up():
	clicked_image.visible = false
	normal_image.visible = true
