extends CanvasLayer

@onready var livesCounterlabel: Label = $LivesCounter/HBoxContainer/Label
@onready var texture_progress_bar = $EnergyBar/TextureProgressBar


func updateCounter():
	livesCounterlabel.text = "Lives: " + str(Globals.player_lives)
	texture_progress_bar.value = Globals.energy_charges
	
func _ready():
	Globals.connect("stat_change", update_stat_label)
	updateCounter()

func update_stat_label():
	updateCounter()
