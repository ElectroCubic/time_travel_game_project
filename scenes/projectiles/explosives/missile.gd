extends Area2D

class_name Missile

signal obstacleCollided(collider, obstacle: Obstacle)

@onready var missile = $"." as Obstacle
@export var SPEED: int = 20
var direction: Vector2 = Vector2.RIGHT

func _on_body_entered(body):
	if body.name == "Player":
		obstacleCollided.emit(body, self)
	queue_free()

func _process(delta):
	position += SPEED * direction * delta
