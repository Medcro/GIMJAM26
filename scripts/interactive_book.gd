extends AnimatedSprite2D
class_name InteractiveBook2D

@export var page_count : int = 6
var current_page : int = 0

@onready var state_machine = $StateMachine
@onready var next_button = $Control/NextPageButton
@onready var prev_button = $Control/PreviousPageButton

var book_content = {
	1: ["Page 1: ", "blablablablablabla"],
	2: ["Page 2: ", "blablablablablabla"],
	3: ["Page 3: ", "blablablablablabla"],
	4: ["Page 4: ", "blablablablablabla"],
	5: ["Page 5: ", "blablablablablabla"],
	6: ["Page 6: ", "blablablablablabla"],
	7: ["Page 7: ", "blablablablablabla"]
}

func _ready():
	current_page = 0
	state_machine.init(self)

func update_text_visibility(visible: bool):
	$Control/LeftLabel.visible = visible
	$Control/RightLabel.visible = visible
	if visible and book_content.has(current_page):
		$Control/LeftLabel.text = book_content[current_page][0]
		$Control/RightLabel.text = book_content[current_page][1]

func clamp_page(new_page : int) -> int:
	if new_page < 0: return page_count
	elif new_page > page_count: return 0
	return new_page
