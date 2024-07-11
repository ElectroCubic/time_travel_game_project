extends Area2D

class_name ChronoLoop

signal powerUpActivated(activator, powerupRef)

var player_contact: bool = false
var current_clone: PlayerClone = null

@export var move_count: int
@onready var anim = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

func _ready():
	anim.play("Inactive")
	interaction_area.update_label_text("Touch to Create Loop")

func _on_body_entered(body):
	if body.name == "Player":
		player_contact = true
		anim.play("Active")
		
	powerUpActivated.emit(body,self)

func _on_body_exited(body):
	if body.name == "Player":
		player_contact = false
		
func _process(_delta):
	if current_clone != null and player_contact and Input.is_action_just_pressed("Reset"):
		powerUpActivated.emit("Player",self)
		anim.play("Inactive")
