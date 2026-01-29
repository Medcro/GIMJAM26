extends AnimatedSprite2D
class_name InteractiveBook2D

@export var page_count : int = 3
var current_page : int = 0

@onready var state_machine = $StateMachine
@onready var next_button = $Control/NextPageButton
@onready var prev_button = $Control/PreviousPageButton
@onready var left_title: RichTextLabel = $Control/LeftTitle
@onready var left_label: RichTextLabel = $Control/LeftLabel
@onready var left_label_2: RichTextLabel = $Control/LeftLabel2
@onready var right_title: RichTextLabel = $Control/RightTitle
@onready var right_label: RichTextLabel = $Control/RightLabel
@onready var right_label_2: RichTextLabel = $Control/RightLabel2
@onready var close_button: Button = $Control/CloseButton

@onready var photo_1 = $Control/Photos/Photo
@onready var photo_2 = $Control/Photos/Photo2
@onready var photo_3 = $Control/Photos/Photo3
@onready var photo_4 = $Control/Photos/Photo4

var book_content = {
	1: ["", "", "", "Act 1", "[url=tutorial]Tutorial[/url]", "[url=level_1]Level 1[/url]"],
	2: ["Act 2", "[url=level_2]Level 2[/url]", "[url=level_3]Level 3[/url]", "Act 3", "[url=level_4]Level 4[/url]", "[url=level_5]Level 5[/url]"],
	3: ["Act 4", "[url=level_6]Level 6[/url]", "[url=level_7]Level 7[/url]", "", "", ""]
}

func _ready():
	state_machine.init(self)

func update_text_visibility(is_visible: bool):
	left_title.visible = is_visible
	left_label.visible = is_visible
	left_label_2.visible = is_visible
	right_title.visible = is_visible
	right_label.visible = is_visible
	right_label_2.visible = is_visible
	close_button.visible = is_visible
	
	if is_visible:
		# handle visibility of the photos on the left
		var show_left = (current_page > 1) 
		photo_1.visible = show_left
		photo_2.visible = show_left
		
		# handle visibility of the photos on the right
		var show_right = (current_page < page_count-1)
		photo_3.visible = show_right
		photo_4.visible = show_right
		
		if book_content.has(current_page):
			var p = book_content[current_page]
			
			# Left Page Mapping
			left_title.text = p[0]
			left_label.text = format_text(p[1])
			left_label_2.text = format_text(p[2])
			
			# Right Page Mapping
			right_title.text = p[3]
			right_label.text = format_text(p[4])
			right_label_2.text = format_text(p[5])
	else: 
		photo_1.visible = false
		photo_2.visible = false
		photo_3.visible = false
		photo_4.visible = false

func format_text(url_string: String) -> String:
	if url_string == "" or "[url=" not in url_string: return url_string
	var level_id = url_string.get_slice("=", 1).get_slice("]", 0)
	
	if SaveManager.unlocked_levels.get(level_id, false):
		return url_string
	return "[color=gray]Locked[/color]"

func clamp_page(new_page : int) -> int:
	if new_page < 0: return page_count
	elif new_page > page_count: return 0
	return new_page
