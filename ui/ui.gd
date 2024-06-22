extends CanvasLayer

@onready var livesCounterlabel: Label = $LivesCounter/HBoxContainer/Label

func updateCounter():
	livesCounterlabel.text = "Lives: " + str(Globals.player_lives)
	
func _ready():
	Globals.connect("stat_change", update_stat_label)
	updateCounter()

func update_stat_label():
	updateCounter()
