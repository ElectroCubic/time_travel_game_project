extends CharacterBody2D

class_name Player

var is_moving: bool = false
var direction: Vector2
const TILE_SIZE: int = 128

var undoRedo: UndoRedo

func _process(_delta):
	if Input.is_action_pressed("Left"):
		direction = Vector2.LEFT
		move_player()
	elif Input.is_action_pressed("Right"):
		direction = Vector2.RIGHT
		move_player()
	elif Input.is_action_pressed("Up"):
		direction = Vector2.UP
		move_player()
	elif Input.is_action_pressed("Down"):
		direction = Vector2.DOWN
		move_player()
		
func move_player():
	if direction:
		if is_moving == false:
			is_moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + (direction * TILE_SIZE), 0.5)
			tween.tween_callback(stop_moving)
		
func stop_moving():
	is_moving = false
	
	
	
	
	
