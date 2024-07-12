extends Area2D

class_name EnergyUP

signal powerUpActivated(activator,powerUpRef)

func _on_body_entered(body) -> void:
	if body.name == "Player":
		powerUpActivated.emit(body,self)
		queue_free()
