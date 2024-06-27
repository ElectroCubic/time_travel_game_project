extends Area2D

class_name ChronoLoop

signal powerUpActivated(powerupRef)

@onready var fragmentImgUnused = $Sprite2D
@onready var changedImage = preload("res://graphics/powerups/environment_02.png")

func _on_body_entered(body):
	if body.name == "Player":
		fragmentImgUnused.texture = changedImage
		powerUpActivated.emit(self)
		
	elif body.name == "PlayerClone":
		body.togglePowerup()
