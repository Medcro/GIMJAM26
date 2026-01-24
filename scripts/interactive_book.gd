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

var book_content = {
	1: ["", "", "", "Act 1", "[url=level_1]Level 1[/url]", "[url=level_2]Level 2[/url]"], #cover, page 1
	2: ["Act 2", "[url=level_3]Level 3[/url]", "[url=level_4]Level 4[/url]", #page 2
		"Act 3", "[url=level_5]Level 5[/url]", "[url=level_6]Level 6[/url]"], #page 3
	3: ["Act 4", "[url=level_7]Level 7[/url]", "[url=level_8]Level 8[/url]", "", "", ""] #page 4, end
}

func _ready():
	current_page = 0
	state_machine.init(self)

func update_text_visibility(is_visible: bool):
	left_title.visible = is_visible
	left_label.visible = is_visible
	left_label_2.visible = is_visible
	right_title.visible = is_visible
	right_label.visible = is_visible
	right_label_2.visible = is_visible

	if is_visible and book_content.has(current_page):
		left_title.text = book_content[current_page][0]
		left_label.text = book_content[current_page][1]
		left_label_2.text = book_content[current_page][2]
		right_title.text = book_content[current_page][3]
		right_label.text = book_content[current_page][4]
		right_label_2.text = book_content[current_page][5]

func clamp_page(new_page : int) -> int:
	if new_page < 0: return page_count
	elif new_page > page_count: return 0
	return new_page
