extends CharacterBody2D

class_name PlayerClone

var is_moving: bool = false
var direction: Vector2
var is_active: bool = false
const TILE_SIZE: int = 128

@export var move_time: float
@onready var level = get_node("../../")

func _unhandled_key_input(_event):
	if is_moving == false:
		if level.is_recording:
			direction = Input.get_vector("Left","Right","Up","Down")
			move_clone(direction)
			record_movement(direction)
	else:
		is_active = true
			
func record_movement(dir):
	level.directions_record.append(dir)
	print(level.directions_record)

func togglePowerup():
	level.is_recording = !level.is_recording
	if !level.is_recording or is_active:
		print("Replaying")
		await get_tree().create_timer(0.4).timeout
		replay_movements()

func replay_movements():
	var length = level.directions_record.size()
	for i in range(0,length):
		await move_clone(level.directions_record[i])
		print(level.directions_record[i])

func move_clone(dir):
	if is_moving == false:
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + (dir * TILE_SIZE), move_time)
		tween.tween_callback(stop_moving)
		await tween.finished

func stop_moving():
	is_moving = false

