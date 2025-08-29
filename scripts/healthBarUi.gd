extends ProgressBar


func _ready():
	pass
func _physics_process(delta):
	
	if Global.playerMaxHealthUi <= Global.playerHealthUi:
		self.value = Global.playerHealthUi
		if Global.playerHealthUi <= 0:
			self.value = 0
