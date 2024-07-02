extends Area2D

class_name ChronoLoop

signal powerUpActivated(activator, powerupRef)

var player_contact: bool = false
var current_clone: PlayerClone

@export var move_count: int
@onready var changedImage = preload("res://graphics/powerups/environment_02.png")

func _on_body_entered(body):
	if body.name == "Player":
		player_contact = true
		$Sprite2D.texture = changedImage
		
	powerUpActivated.emit(body,self)

func _on_body_exited(body):
	if body.name == "Player":
		player_contact = false

