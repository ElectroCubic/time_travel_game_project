extends Node

signal stat_change

var health: int = 3:
	set(value):
		health = value
		stat_change.emit()
		
var energy_charges: int = 5:
	set(value):
		energy_charges = value
		stat_change.emit()

var vulnerability = true:
	set(value):
		vulnerability = value
		stat_change.emit()

