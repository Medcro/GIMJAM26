extends State

func enter():
	book.update_text_visibility(false)
	
	var page = book.current_page
	var prev = get_parent().previous_page_number
	var last_content_page = book.page_count       
	var back_cover_index = last_content_page + 1  
	
	if page == 0:
		if prev == 1: book.play("close_from_first")
		elif prev == back_cover_index: book.play("closed_back")
		else: book.play("close_from_middle")
		
	elif page == 1 and prev == 0:
		book.play("open_to_first")
		
	elif page == back_cover_index: 
		book.play("close_from_last")
		
	elif page == last_content_page and prev == back_cover_index:
		book.play("previous_from_last")
		
	else:
		if page > prev: book.play("next_page")
		else: book.play("previous_page")

func update(_delta):
	if not book.is_playing():
		if book.current_page == 0 or book.current_page > book.page_count:
			get_parent().change_state("IdleState")
		else:
			get_parent().change_state("ReadingState")
