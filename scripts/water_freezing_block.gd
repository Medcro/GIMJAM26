extends StaticBody2D

enum State { WATER, ICE }
var state := State.WATER

@onready var sprite: Sprite2D = $Sprite2D
@onready var wall_collision: CollisionShape2D = $CollisionShape2D

@export var water_texture: Texture2D
@export var ice_texture: Texture2D

func _ready():
	sprite.texture = water_texture
	wall_collision.disabled = true

func freeze():
	if state == State.ICE:
		return
	state = State.ICE
	sprite.texture = ice_texture
	wall_collision.disabled = false

func _on_area_2d_body_exited(body):
	if body is player:
		freeze()
