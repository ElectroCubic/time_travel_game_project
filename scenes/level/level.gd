extends Node2D

class_name Level

@onready var tile_map = $TileMap
@onready var player = $Player_Clones/Player as Player
@onready var playerClone = preload("res://scenes/player/player_clone.tscn")

var directions_record: Array[Vector2]
var is_recording: bool = false
var cloneTemp

func _ready():
	var powerups = get_node("Powerups").get_children()
	
	for powerup in powerups:
		powerup.connect("powerUpActivated", _on_player_activate_powerup)
		
func _on_player_activate_powerup(powerupRef):
	if powerupRef is ChronoLoop:
		print("Recording")
		await get_tree().create_timer(0.5).timeout
		cloneTemp = playerClone.instantiate()
		cloneTemp.position = player.position
		get_node("Player_Clones").add_child(cloneTemp)

