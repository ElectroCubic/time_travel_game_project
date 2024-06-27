extends CharacterBody2D

class_name Player

var is_moving: bool = false
var direction: Vector2
const TILE_SIZE: int = 128

@export var move_time: float 
@onready var anim_sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var level = get_node("../../")

func _ready():
	anim.play("Idle_Front")

func _unhandled_key_input(_event):
	if is_moving == false:
		anim.play("Idle_Front")
		
		if !level.is_recording:
			direction = Input.get_vector("Left","Right","Up","Down")
		
			if direction == Vector2.UP:
				anim.play("Back Walk")
			elif direction == Vector2.DOWN:
				anim.play("Front Walk")
			elif direction == Vector2.LEFT:
				anim_sprite.flip_h = false
				anim.play("Side Walk")
			elif direction == Vector2.RIGHT:
				anim_sprite.flip_h = true
				anim.play("Side Walk")
			
			move_player(direction)

func move_player(dir):
	if is_moving == false:
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self, "position", position + (dir * TILE_SIZE), move_time)
		tween.tween_callback(stop_moving)
		await tween.finished

func stop_moving():
	is_moving = false
