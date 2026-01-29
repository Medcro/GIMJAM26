extends Node2D

var current_page : int = 1
var max_pages : int = 3 

@onready var next_button = $NextButton
@onready var prev_button = $PrevButton 

@onready var left_title = $LeftTitle
@onready var left_label = $LeftLabel
@onready var left_label_2 = $LeftLabel2
@onready var right_title = $RightTitle
@onready var right_label = $RightLabel
@onready var right_label_2 = $RightLabel2

@onready var photo_1 = $Photos/Photo
@onready var photo_2 = $Photos/Photo2
@onready var photo_3 = $Photos/Photo3
@onready var photo_4 = $Photos/Photo4

var book_content = {
	1: ["", "", "", "Act 1", "[url=tutorial]Tutorial[/url]", "[url=level_1]Level 1[/url]"],
	2: ["Act 2", "[url=level_2]Level 2[/url]", "[url=level_3]Level 3[/url]", "Act 3", "[url=level_4]Level 4[/url]", "[url=level_5]Level 5[/url]"],
	3: ["Act 4", "[url=level_6]Level 6[/url]", "[url=level_7]Level 7[/url]", "", "", ""]
}

func _ready():
	SaveManager.load_game() 
	
	# connect lables to link to the levels
	connect_links(left_label)
	connect_links(left_label_2)
	connect_links(right_label)
	connect_links(right_label_2)
	
	update_display()

func update_display():
	# handle the display of the texts
	if book_content.has(current_page):
		var p = book_content[current_page]
		left_title.text = p[0]
		left_label.text = format_text(p[1])
		left_label_2.text = format_text(p[2])
		
		right_title.text = p[3]
		right_label.text = format_text(p[4])
		right_label_2.text = format_text(p[5])
	
	# handle visibility of the photos on the left
	var show_left = (current_page > 1) 
	photo_1.visible = show_left
	photo_2.visible = show_left
	
	# handle visibility of the photos on the right
	var show_right = (current_page < max_pages)
	photo_3.visible = show_right
	photo_4.visible = show_right

	# handle visibility of the button
	next_button.visible = (current_page < max_pages)
	prev_button.visible = (current_page > 1)

func _on_next_button_pressed():
	if current_page < max_pages:
		current_page += 1
		update_display()

func _on_prev_button_pressed():
	if current_page > 1:
		current_page -= 1
		update_display()

func connect_links(label: RichTextLabel):
	if not label.meta_clicked.is_connected(_on_link_clicked):
		label.meta_clicked.connect(_on_link_clicked)

func _on_link_clicked(meta):
	if SaveManager.unlocked_levels.get(str(meta), false):
		get_tree().change_scene_to_file("res://scenes/levels/" + str(meta) + ".tscn")

func format_text(url_string: String) -> String:
	if url_string == "" or "[url=" not in url_string: 
		return url_string
	var level_id = url_string.get_slice("=", 1).get_slice("]", 0)
	if SaveManager.unlocked_levels.get(level_id, false):
		return url_string
	return "[color=gray]Locked[/color]"
