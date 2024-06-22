extends CharacterBody2D

class_name Player

var is_moving: bool = false
var direction: Vector2
const TILE_SIZE: int = 128

var recording: bool = false
var directions: Array[Vector2]

func replay_movements():
	var length = directions.size()
	for i in range(0,length):
		await move_player(directions[i])
		#print(directions[i])


func _unhandled_input(_event):

	if is_moving == false:
		if Input.is_action_pressed("Left"):
			direction = Vector2.LEFT
			move_player(direction)
		elif Input.is_action_pressed("Right"):
			direction = Vector2.RIGHT
			move_player(direction)
		elif Input.is_action_pressed("Up"):
			direction = Vector2.UP
			move_player(direction)
		elif Input.is_action_pressed("Down"):
			direction = Vector2.DOWN
			move_player(direction)
			
		if recording:
			record_movement(direction)
		


func record_movement(dir):
	directions.append(dir)
	#print(directions)
	
func move_player(dir):
	if is_moving == false:
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + (dir * TILE_SIZE), 0.5)
		tween.tween_callback(stop_moving)
		await tween.finished
		
func stop_moving():
	is_moving = false
	
func togglePowerup():
	recording = true
