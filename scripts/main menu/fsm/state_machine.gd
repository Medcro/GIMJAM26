extends Node

var current_state: State
var previous_page_number: int = 0 

func init(book_node: InteractiveBook2D):
	for child in get_children():
		if child is State:
			child.book = book_node
	change_state("IdleState")

func change_state(state_name: String):
	if current_state:
		current_state.exit()
	current_state = get_node(state_name)
	current_state.enter()

func _process(delta):
	if current_state:
		current_state.update(delta)
