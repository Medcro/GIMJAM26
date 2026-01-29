extends CanvasLayer
## A basic dialogue balloon for use with Dialogue Manager.

signal dialogue_ended

## The dialogue resource
@export var dialogue_resource: DialogueResource

## Start from a given title when using balloon as a [Node] in a scene.
@export var start_from_title: String = ""

## If running as a [Node] in a scene then auto start the dialogue.
@export var auto_start: bool = false

## The action to use for advancing the dialogue
@export var next_action: StringName = &"ui_accept"

## The action to use to skip typing the dialogue
@export var skip_action: StringName = &"ui_cancel"

## A sound player for voice lines (if they exist).
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

@onready var autoplay_timer: Timer = Timer.new()

@onready var autoplay_button: TextureButton = $AutoplayButton
@onready var skip_button: TextureButton = %SkipButton

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## A dictionary to store any ephemeral variables
var locals: Dictionary = {}

var _locale: String = TranslationServer.get_locale()

var is_autoplay: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(value):
		if value:
			dialogue_line = value
			apply_dialogue_line()
		else:
			# The dialogue has finished so close the balloon
			if owner == null:
				queue_free()
			else:
				hide()
	get:
		return dialogue_line

## A cooldown timer for delaying the balloon hide when encountering a mutation.
var mutation_cooldown: Timer = Timer.new()

var is_manual_portrait: bool = false

## The base balloon anchor
@onready var balloon: Control = %Balloon

## The label showing the name of the currently speaking character
@onready var character_label: RichTextLabel = %CharacterLabel

## The label showing the currently spoken dialogue
@onready var dialogue_label: DialogueLabel = %DialogueLabel

## The menu of responses
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

## Indicator to show that player can progress dialogue.
@onready var progress: Polygon2D = %Progress

@onready var skip_ui: Panel = $SkipUI

@onready var pause_ui: Panel = $PauseUI

@onready var chara_portrait: TextureRect = $CharaPortrait

func _ready() -> void:
	var level_id = SaveManager.current_level
	var is_finished = SaveManager.unlocked_levels.get(level_id, false)
	
	if is_finished:
		skip_button.visible = true
	else:
		skip_button.visible = false
	
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)
	if dialogue_label:
		dialogue_label.finished_typing.connect(_on_finished_typing)

	# If the responses menu doesn't have a next action set, use this one
	if responses_menu.next_action.is_empty():
		responses_menu.next_action = next_action

	mutation_cooldown.timeout.connect(_on_mutation_cooldown_timeout)
	add_child(mutation_cooldown)
	
	# Setup the timer
	add_child(autoplay_timer)
	autoplay_timer.one_shot = true
	autoplay_timer.timeout.connect(_on_autoplay_timeout)

	if auto_start:
		if not is_instance_valid(dialogue_resource):
			assert(false, DMConstants.get_error_message(DMConstants.ERR_MISSING_RESOURCE_FOR_AUTOSTART))
		start()


func _process(delta: float) -> void:
	if is_instance_valid(dialogue_line):
		progress.visible = not dialogue_label.is_typing and dialogue_line.responses.size() == 0 and not dialogue_line.has_tag("voice")


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	## Detect a change of locale and update the current dialogue line to show the new language
	if what == NOTIFICATION_TRANSLATION_CHANGED and _locale != TranslationServer.get_locale() and is_instance_valid(dialogue_label):
		_locale = TranslationServer.get_locale()
		var visible_ratio: float = dialogue_label.visible_ratio
		dialogue_line = await dialogue_resource.get_next_dialogue_line(dialogue_line.id)
		if visible_ratio < 1:
			dialogue_label.skip_typing()


## Start some dialogue
func start(with_dialogue_resource: DialogueResource = null, title: String = "", extra_game_states: Array = []) -> void:
	temporary_game_states = [self] + extra_game_states
	is_waiting_for_input = false
	if is_instance_valid(with_dialogue_resource):
		dialogue_resource = with_dialogue_resource
	if not title.is_empty():
		start_from_title = title
	dialogue_line = await dialogue_resource.get_next_dialogue_line(start_from_title, temporary_game_states)
	show()


## Apply any changes to the balloon given a new [DialogueLine].
func apply_dialogue_line() -> void:
	mutation_cooldown.stop()

	progress.hide()
	is_waiting_for_input = false
	balloon.focus_mode = Control.FOCUS_ALL
	balloon.grab_focus()

	var is_narrator: bool = dialogue_line.character.is_empty()
	
	if is_narrator:
		character_label.modulate.a = 0.0
	else:
		character_label.modulate.a = 1.0
		character_label.text = tr(dialogue_line.character, "dialogue")
	
	if not is_manual_portrait:
		var portrait_path: String = "res://assets/portrait/[%s] default.png" % dialogue_line.character
		if ResourceLoader.exists(portrait_path):
			chara_portrait.texture = load(portrait_path)
			chara_portrait.show()
		else:
			chara_portrait.texture = null
			chara_portrait.hide()
	
	# Reset for the next line of dialogue
	is_manual_portrait = false

	dialogue_label.hide()
	dialogue_label.dialogue_line = dialogue_line

	responses_menu.hide()
	responses_menu.responses = dialogue_line.responses

	balloon.show()
	will_hide_balloon = false

	dialogue_label.show()
	if not dialogue_line.text.is_empty():
		# Use the typewriter effect
		dialogue_label.type_out()
		# Wait for it to finish
		await dialogue_label.finished_typing

	# Wait for next line
	if dialogue_line.has_tag("voice"):
		audio_stream_player.stream = load(dialogue_line.get_tag_value("voice"))
		audio_stream_player.play()
		await audio_stream_player.finished
		next(dialogue_line.next_id)
	elif dialogue_line.responses.size() > 0:
		balloon.focus_mode = Control.FOCUS_NONE
		responses_menu.show()
	elif dialogue_line.time != "":
		var time: float = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
		await get_tree().create_timer(time).timeout
		next(dialogue_line.next_id)
	else:
		is_waiting_for_input = true
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

## Change the portrait expression
func set_expression(expression: String) -> void:
	if dialogue_line.character.is_empty(): 
		return
	var portrait_path: String = "res://assets/portrait/[%s] %s.png" % [dialogue_line.character, expression]
	
	if ResourceLoader.exists(portrait_path):
		chara_portrait.texture = load(portrait_path)
	else:
		push_warning("Expression file not found: " + portrait_path)

func set_portrait(chara_id: String, expression: String = "default") -> void:
	# This builds the exact path: res://assets/portrait/[chara_id] expression.png
	var path: String = "res://assets/portrait/[%s] %s.png" % [chara_id, expression]
	
	if ResourceLoader.exists(path):
		chara_portrait.texture = load(path)
		chara_portrait.show()
		chara_portrait.modulate.a = 1.0
		is_manual_portrait = true
	else:
		push_warning("Manual portrait failed: " + path)
		chara_portrait.hide()

## Go to the next line
func next(next_id: String) -> void:
	dialogue_line = await dialogue_resource.get_next_dialogue_line(next_id, temporary_game_states)


#region Signals


func _on_mutation_cooldown_timeout() -> void:
	if will_hide_balloon:
		will_hide_balloon = false
		balloon.hide()


func _on_mutated(_mutation: Dictionary) -> void:
	if not _mutation.is_inline:
		is_waiting_for_input = false
		will_hide_balloon = true
		mutation_cooldown.start(0.1)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(skip_action)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(next_action) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)


#endregion


func _on_skip_button_pressed() -> void:
	skip_ui.visible = true

func _on_skip_button_yes_pressed() -> void:
	if is_instance_valid(audio_stream_player):
		audio_stream_player.stop()

	dialogue_ended.emit()

	queue_free()

func _on_skip_button_no_pressed() -> void:
	skip_ui.visible = false

func _on_autoplay_toggle_pressed() -> void:
	is_autoplay = !is_autoplay
	autoplay_timer.start(1.5)

func _on_finished_typing() -> void:
	if is_autoplay:
		autoplay_timer.start(1.5)

func _on_autoplay_timeout() -> void:
	if is_autoplay:
		next(dialogue_line.next_id)

func _on_pause_button_pressed() -> void:
	pause_ui.visible = true
	get_tree().paused = true

func _on_pause_resume_button_pressed() -> void:
	pause_ui.visible = false
	get_tree().paused = false

func _on_pause_quit_button_pressed() -> void:
	pass # Replace with function body.
