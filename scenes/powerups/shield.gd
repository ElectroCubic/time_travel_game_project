extends Area2D

class_name Shield

signal powerUpActivated(activator,powerUpRef)

@export var shield_duration: int = 10

func _on_body_entered(body) -> void:
	if body.name == "Player":
		powerUpActivated.emit(body,self)
		queue_free()
