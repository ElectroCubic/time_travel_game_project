extends CanvasLayer

@onready var healthlabel: Label = $Health/HBoxContainer/Label
@onready var texture_progress_bar = $EnergyBar/TextureProgressBar
@onready var path = $Path

func updateCounter():
	healthlabel.text = "Health: " + str(Globals.health)
	texture_progress_bar.value = Globals.energy_charges
	
func _ready():
	Globals.connect("stat_change", update_stat_label)
	updateCounter()

func update_stat_label():
	updateCounter()
	
#func _process(_delta):
	#path.text = "Array: " + str(Globals.current_path)
