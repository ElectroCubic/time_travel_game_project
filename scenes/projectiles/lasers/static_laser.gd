extends Obstacle

class_name StaticLaser

signal obstacleCollided(collider, obstacle: Obstacle)

@onready var static_laser = $"." as StaticLaser

