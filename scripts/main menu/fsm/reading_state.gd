extends State

func enter():
	book.update_text_visibility(true) # Show text when still
	if not book.left_label.meta_clicked.is_connected(_on_link_clicked):
		book.left_label.meta_clicked.connect(_on_link_clicked)
	if not book.left_label_2.meta_clicked.is_connected(_on_link_clicked):
		book.left_label_2.meta_clicked.connect(_on_link_clicked)
	if not book.right_label.meta_clicked.is_connected(_on_link_clicked):
		book.right_label.meta_clicked.connect(_on_link_clicked)
	if not book.right_label_2.meta_clicked.is_connected(_on_link_clicked):
		book.right_label_2.meta_clicked.connect(_on_link_clicked)

func _on_next_page_button_down():
	_trigger_flip(book.current_page + 1)

func _on_previous_page_button_down():
	_trigger_flip(book.current_page - 1)

func _on_close_button_down():
	book.is_settings_mode = false
	get_parent().previous_page_number = book.current_page
	book.current_page = 0 
	get_parent().change_state("FlippingState")

func _trigger_flip(target_page: int):
	var clamped = book.clamp_page(target_page)
	if clamped == book.current_page: return
	get_parent().previous_page_number = book.current_page
	book.current_page = clamped
	get_parent().change_state("FlippingState")

func _on_link_clicked(meta):
	if SaveManager.unlocked_levels.get(str(meta), false):
		get_tree().change_scene_to_file("res://scenes/levels/" + str(meta) + ".tscn")
