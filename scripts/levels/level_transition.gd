extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer
@export var color_rect: ColorRect

func change_scene(target_path: String):
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	anim.play("dissolve")
	await anim.animation_finished
	
	get_tree().change_scene_to_file(target_path)
	
	anim.play_backwards("dissolve")
	await anim.animation_finished
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
