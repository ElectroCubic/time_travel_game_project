extends CharacterBody2D

class_name Player

signal input_pressed
signal powerUpActivated(activator, powerupRef)

var direction: Vector2
var target_pos: Vector2
var is_moving: bool = false
var is_controlled: bool = true
var is_move_key_pressed: bool = false

@export var move_time: float 
@onready var anim_sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var tile_map = get_node("../TileMap") as TileMap

func _ready():
	anim.play("Idle_Front")
	
func player_input():
	if Input.is_action_pressed("Left"):
		direction = Vector2.LEFT
		is_move_key_pressed = true
	elif Input.is_action_pressed("Right"):
		direction = Vector2.RIGHT
		is_move_key_pressed = true
	elif Input.is_action_pressed("Up"):
		direction = Vector2.UP
		is_move_key_pressed = true
	elif Input.is_action_pressed("Down"):
		direction = Vector2.DOWN
		is_move_key_pressed = true
	else:
		is_move_key_pressed = false
		
	if Input.is_action_just_pressed("Phantom") and Globals.energy_charges > 0:
		Globals.energy_charges -= 1
		powerUpActivated.emit(self,"Phantom")
		
	elif Input.is_action_just_pressed("Bomb") and Globals.energy_charges > 1:
		Globals.energy_charges -= 2
		powerUpActivated.emit(self,"Bomb")
		
	elif Input.is_action_just_pressed("Reset"):
		pass

func _unhandled_key_input(_event):
	if is_moving == false:
		player_input()
		if is_move_key_pressed:
			move_player()
			input_pressed.emit()

func move_player():
	get_target_pos(direction)
	if is_controlled:
		is_moving = true
		var tween = create_tween()
		tween.tween_property(self, "global_position", target_pos, move_time).set_trans(Tween.TRANS_SINE)
		await tween.finished
		is_moving = false
		
func get_target_pos(dir: Vector2i):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	
	var target_tile: Vector2i = Vector2i(
		current_tile.x + dir.x,
		current_tile.y + dir.y
	)
	
	var tile_data = tile_map.get_cell_tile_data(0,target_tile)
	
	var custom_data = tile_data.get_custom_data_by_layer_id(0)
	
	if not custom_data == true:
		target_pos = tile_map.map_to_local(target_tile)
