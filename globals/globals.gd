extends Node

signal stat_change

var player_lives: int = 3:
	set(value):
		player_lives = value
		stat_change.emit()
		
var player_energy: int = 100:
	set(value):
		player_energy = value
		stat_change.emit()

