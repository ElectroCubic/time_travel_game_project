extends Area2D

signal playerTouch(pos)

@onready var fragmentImgUnused = $Sprite2D
var changedImage = preload("res://graphics/environment_02.png")

func _on_body_entered(body):
	if body.name == "Player":
		fragmentImgUnused.texture = changedImage
		playerTouch.emit(self.position)
