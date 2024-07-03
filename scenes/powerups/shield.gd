extends Area2D

class_name Shield

signal powerUpActivated(activator,powerUpRef)

func _on_body_entered(body):
	if body.name == "Player":
		powerUpActivated.emit(body,self)
		queue_free()
