extends State

var pageflip_audio: AudioStreamPlayer

func enter():
	if pageflip_audio == null:
		pageflip_audio = book.get_node("PageFlip")
		
	book.update_text_visibility(false)
		
	var page = book.current_page
	var prev = get_parent().previous_page_number
	var p_count = book.page_count 

	if page == 0:
		if prev == 1: book.play("close_from_first")
		else: book.play("close_from_middle") 
	elif page == p_count: 
		if prev == p_count - 1: book.play("close_from_last")
		else: book.play("closed_back")
	
	elif page == 1:
		if prev == 0: book.play("open_to_first")
		elif prev == 2: book.play("previous_to_first")
	
	elif page == p_count - 1:
		if prev == p_count: book.play("open_to_last")
		if prev == p_count - 2: book.play("next_to_last")
	
	elif page == 2 and prev == 1:
		book.play("next_from_first")
	
	elif page == p_count - 2 and prev == p_count - 1:
		book.play("previous_from_last")
	
	else:
		if page > prev: book.play("next_page")
		elif page < prev: book.play("previous_page")
	
	play_flip_sound()

func update(_delta):
	if not book.is_playing():
		if book.current_page == 0 or book.current_page == book.page_count:
			get_parent().change_state("IdleState")
		else:
			get_parent().change_state("ReadingState")

func play_flip_sound():
	if pageflip_audio:
		pageflip_audio.pitch_scale = randf_range(0.9, 1.1)
		pageflip_audio.play()
