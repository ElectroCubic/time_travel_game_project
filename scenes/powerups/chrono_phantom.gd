extends Area2D

class_name ChronoPhantom

signal powerUpActivated(activator, powerupRef)

var is_active: bool = false
@onready var changedImage = preload("res://graphics/powerups/environment_10.png")

func _on_body_entered(body):
	if body.name == "Player":
		is_active = true
		$Sprite2D.texture = changedImage
		
	powerUpActivated.emit(body,self)
