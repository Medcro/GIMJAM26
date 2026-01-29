extends Area2D

# This function runs when something enters the area
func _on_body_entered(body):
	if body.name == "Player":
		GlobalSettings.word += 1
		print("Item collected!")
		queue_free() 
