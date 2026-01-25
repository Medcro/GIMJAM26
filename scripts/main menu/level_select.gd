extends Node2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var state_machine = $StateMachine
@onready var left_page_text = $CanvasLayer/LeftPage
@onready var right_page_text = $CanvasLayer/RightPage

var current_page = 0
var book_data = {
	1: ["Chapter 1: The Beginning", "Once upon a time..."],
	2: ["The journey started here.", "The road was long..."],
	3: ["The end of the road.", "The hero rested."]
}

func _ready():
	state_machine.init(self)

func update_text():
	if book_data.has(current_page):
		left_page_text.text = book_data[current_page][0]
		right_page_text.text = book_data[current_page][1]
		left_page_text.show()
		right_page_text.show()
	else:
		left_page_text.hide()
		right_page_text.hide()
