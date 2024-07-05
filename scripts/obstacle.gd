extends Node2D

class_name Obstacle

signal obstacleCollided(collider, obstacle: Obstacle)

var direction: Vector2 = Vector2.ZERO
var speed: int = 0
var damage: int = 0
var can_move: bool = false
var is_colliding: bool = false
var is_moving: bool = false
var is_active: bool = true
