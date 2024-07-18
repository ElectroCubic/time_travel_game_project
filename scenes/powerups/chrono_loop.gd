extends Area2D

class_name ChronoLoop

signal powerUpActivated(activator, powerupRef)

var current_clone: PlayerClone = null

@export var move_count: int
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interaction_area: InteractionManager = $InteractionArea

func _ready() -> void:
	anim.play("Inactive")
	interaction_area.update_label_text("Press E to Create Loop")

func _process(_delta) -> void:
	check_player_input()
	
func _on_body_entered(body) -> void:
	if body is PlayerClone and body.type == PlayerClone.CloneType.CHRONO_LOOP:
		powerUpActivated.emit(body,self)

func check_player_input() -> void:
	# Interact with Powerup
	
	if (current_clone == null and
		interaction_area.can_interact and
		Input.is_action_just_pressed("Interact")):
			
		print("Interacted")
		powerUpActivated.emit("Player",self)
		anim.play("Active")
	
	# Reset Powerup
	
	elif (current_clone != null and 
	not current_clone.is_recording and 
	interaction_area.can_interact and 
	Input.is_action_just_pressed("Reset")):
		
		interaction_area.update_label_text("Press E to Create Loop")
		current_clone.disappear()
		current_clone = null
		print("Powerup Reset")
		anim.play("Inactive")
