extends Area2D

@onready var fragmentImgUnused = $Sprite2D

var changedImage = preload("res://graphics/environment_02.png")

func _on_body_entered(body):
	if body.name == "Player":
		fragmentImgUnused.texture = changedImage
		body.togglePowerup()
		
