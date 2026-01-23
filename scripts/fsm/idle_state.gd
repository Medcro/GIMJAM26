extends State

func enter():
	book.update_text_visibility(false)

func _on_next_page_button_button_down():
	book.current_page = 1
	get_parent().change_state("FlippingState")
