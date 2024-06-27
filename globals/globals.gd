extends Node

signal stat_change

var player_lives: int = 3:
	set(value):
		player_lives = value
		stat_change.emit()

