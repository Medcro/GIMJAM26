extends AnimatedSprite2D
class_name InteractiveBook2D

@export var page_count : int = 3
var current_page : int = 0

@onready var state_machine = $StateMachine

@onready var next_button = $Control/NextPageButton
@onready var prev_button = $Control/PreviousPageButton
@onready var close_button: Button = $Control/CloseButton

@onready var left_title: RichTextLabel = $Control/LeftTitle
@onready var left_label: RichTextLabel = $Control/LeftLabel
@onready var left_label_2: RichTextLabel = $Control/LeftLabel2
@onready var right_title: RichTextLabel = $Control/RightTitle
@onready var right_label: RichTextLabel = $Control/RightLabel
@onready var right_label_2: RichTextLabel = $Control/RightLabel2

@onready var settings_container: Control = $Control/Settings

@onready var photo_1 = $Control/Photos/Photo
@onready var photo_2 = $Control/Photos/Photo2
@onready var photo_3 = $Control/Photos/Photo3
@onready var photo_4 = $Control/Photos/Photo4

@onready var button_container: VBoxContainer = $Control/ButtonContainer 
@onready var play_button: TextureButton = $Control/ButtonContainer/PlayButton
@onready var settings_button: TextureButton = $Control/ButtonContainer/SettingsButton
@onready var quit_button: TextureButton = $Control/ButtonContainer/QuitButton
@onready var sandikala_rounded: Sprite2D = $Control/SandikalaRounded

var is_settings_mode : bool = false

var book_content = {
	1: ["", "", "", "", "[url=tutorial]Tutorial[/url]", "[url=level_1]Level 1[/url]"],
	2: ["", "[url=level_2]Level 2[/url]", "[url=level_3]Level 3[/url]", "", "[url=level_4]Level 4[/url]", "[url=level_5]Level 5[/url]"],
	3: ["", "[url=level_6]Level 6[/url]", "[url=level_7]Level 7[/url]", "", "", ""]
}

func _ready():
	state_machine.init(self)

func update_text_visibility(should_show: bool):
	if not should_show:
		_set_reading_content_visible(false)
		button_container.visible = false
		sandikala_rounded.visible = false
		settings_container.visible = false
		_set_photos_visible(false, false)
		return

	if current_page == 0:
		button_container.visible = true       # Show Menu
		sandikala_rounded.visible = true
		_set_reading_content_visible(false)   # Hide Book Text
		_set_photos_visible(false, false)     # Hide Photos
		settings_container.visible = false
		next_button.visible = false           
		prev_button.visible = false

	elif current_page > page_count:
		button_container.visible = false      # Hide Menu
		sandikala_rounded.visible = false
		_set_reading_content_visible(false)   # Hide Book Text
		_set_photos_visible(false, false)     # Hide Photos
		settings_container.visible = false
		close_button.visible = true
		
		next_button.visible = false
		prev_button.visible = true 
		
	else:
		button_container.visible = false      # Hide Menu
		sandikala_rounded.visible = false
		_set_reading_content_visible(true)    # Show Book Text
		
		next_button.visible = true            
		prev_button.visible = true
		
		if is_settings_mode:
			settings_container.visible = true
			
			_set_reading_content_visible(false)
			_set_photos_visible(false, false)
			next_button.visible = false
			prev_button.visible = false
			close_button.visible = true

		else:
			settings_container.visible = false
			_set_reading_content_visible(true)
			
			# Handle Photos
			var show_left = (current_page > 1) 
			var show_right = (current_page < page_count)
			_set_photos_visible(show_left, show_right)
		
		# Update Text Content
			if book_content.has(current_page):
				var p = book_content[current_page]
				left_title.text = p[0]
				left_label.text = format_text(p[1])
				left_label_2.text = format_text(p[2])
				right_title.text = p[3]
				right_label.text = format_text(p[4])
				right_label_2.text = format_text(p[5])

func _set_reading_content_visible(is_vis: bool):
	left_title.visible = is_vis
	left_label.visible = is_vis
	left_label_2.visible = is_vis
	right_title.visible = is_vis
	right_label.visible = is_vis
	right_label_2.visible = is_vis
	close_button.visible = is_vis

func _set_photos_visible(show_left: bool, show_right: bool):
	photo_1.visible = show_left
	photo_2.visible = show_left
	photo_3.visible = show_right
	photo_4.visible = show_right

func format_text(url_string: String) -> String:
	if url_string == "" or "[url=" not in url_string: return url_string
	var level_id = url_string.get_slice("=", 1).get_slice("]", 0)
	if SaveManager.unlocked_levels.get(level_id, false):
		return url_string
	return "[color=gray]Locked[/color]"

func clamp_page(new_page : int) -> int:
	if new_page < 0: 
		return 0 
	elif new_page > page_count + 1: 
		return page_count + 1 
	return new_page

func _on_play_pressed():
	is_settings_mode = false 
	state_machine.previous_page_number = 0
	current_page = 1
	state_machine.change_state("FlippingState")

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed() -> void:
	is_settings_mode = true
	state_machine.previous_page_number = 0
	current_page = 1
	state_machine.change_state("FlippingState")
