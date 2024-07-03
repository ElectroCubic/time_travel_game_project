extends Node

signal stat_change

var player_lives: int = 3:
	set(value):
		player_lives = value
		stat_change.emit()
		
var energy_charges: int = 5:
	set(value):
		energy_charges = value
		stat_change.emit()

