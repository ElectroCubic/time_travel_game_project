extends Area2D

class_name LifeUP

signal powerUpActivated(powerUpRef)

func _on_body_entered(body):
	if body.name == "Player":
		powerUpActivated.emit(self)
		self.queue_free()
