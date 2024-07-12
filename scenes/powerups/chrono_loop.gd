extends Area2D

class_name ChronoLoop

signal powerUpActivated(activator, powerupRef)

var current_clone: PlayerClone = null

@export var move_count: int
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: InteractionManager = $InteractionArea

func _ready() -> void:
	anim.play("Inactive")
	interaction_area.update_label_text("Touch to Create Loop")

func _on_body_entered(body) -> void:
	if body.name == "Player":
		anim.play("Active")
	powerUpActivated.emit(body,self)

func _process(_delta) -> void:
	if (current_clone != null and 
		not current_clone.is_recording and 
		interaction_area.can_interact and 
		Input.is_action_just_pressed("Reset")):
		
		interaction_area.update_label_text("Touch To Create Loop")
		current_clone.disappear()
		current_clone = null
		print("Powerup Reset")
		anim.play("Inactive")
