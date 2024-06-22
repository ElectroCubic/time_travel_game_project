extends Node2D

class_name Level

@onready var tile_map = $TileMap

@onready var player = $"Player Entities/Player" as Player

'''
func checkActivated():
	if player.recording == true:
		player.recording = false
		
		player.replay_movements()

'''
