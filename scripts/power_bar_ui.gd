extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.value = Global.globalBattery


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.globalBattery < 1000:
		self.value = Global.globalBattery
