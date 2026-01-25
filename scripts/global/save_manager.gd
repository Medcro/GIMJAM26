extends Node

const SAVE_PATH = "user://save_game.dat"

# Tracks which levels are unlocked
var unlocked_levels = {
	"level_1": true,
	"level_2": false,
	"level_3": false,
	"level_4": false,
	"level_5": false,
	"level_6": false,
	"level_7": false,
	"level_8": false
}

func _ready():
	load_game()

func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(unlocked_levels)

func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			unlocked_levels = file.get_var()

func reset_data():
	unlocked_levels = {
	"level_1": true,
	"level_2": false,
	"level_3": false,
	"level_4": false,
	"level_5": false,
	"level_6": false,
	"level_7": false,
	"level_8": false
	}
	save_game()
