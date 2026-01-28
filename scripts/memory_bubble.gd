extends Area2D

class_name MemoryBubble

func _on_body_entered(body: Node2D) -> void:
	if body is player:
		body.has_collected_memory = true
		queue_free()

func _ready() -> void:
	body_entered.connect(_on_body_entered)
