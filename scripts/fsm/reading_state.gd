extends State

func enter():
	book.update_text_visibility(true) # Show text when still

func _on_next_page_button_button_down():
	_trigger_flip(book.current_page + 1)

func _on_previous_page_button_button_down():
	_trigger_flip(book.current_page - 1)

func _on_close_button_button_down():
	_trigger_flip(0)

func _trigger_flip(target_page: int):
	var clamped = book.clamp_page(target_page)
	if clamped == book.current_page: return
	
	get_parent().previous_page_number = book.current_page
	book.current_page = clamped
	get_parent().change_state("FlippingState")
