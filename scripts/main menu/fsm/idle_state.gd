extends State

func enter():
	book.update_text_visibility(false)
	book.get_node("Control/NextPageButton").show()

func _on_next_page_button_button_down():
	get_parent().previous_page_number = book.current_page
	book.current_page = 1
	get_parent().change_state("FlippingState")
