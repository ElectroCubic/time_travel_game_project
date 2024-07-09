extends Node2D

class_name Enemy

signal enemyCollided(collider, enemy: Enemy)

var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var damage: int = 0
var health: int = 100
var is_moving: bool = false
var is_active: bool = true
var is_colliding: bool = false
var is_vulnerable: bool = true
var is_chasing: bool = false

func enemy_hit() -> void:
	pass
