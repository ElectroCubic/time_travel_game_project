extends Area2D

class_name ChronoLoop

signal powerUpActivated(activator, powerupRef)

var is_active: bool = false
var player_contact: bool = false
var current_clone: PlayerClone

@onready var changedImage = preload("res://graphics/powerups/environment_02.png")

func _on_body_entered(body):
	if body.name == "Player":
		player_contact = true
		$Sprite2D.texture = changedImage
		
	elif body.name == "PlayerClone":
		is_active = true
		
	powerUpActivated.emit(body,self)

func _on_body_exited(body):
	if body.name == "Player":
		player_contact = false

#func _process(_delta):
	#if player_contact and Input.is_action_just_pressed("Record"):
		#pass

