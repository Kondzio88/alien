extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.globalStrength <= 0:
		self.visible = false
	if Global.globalStrength > 0:
		self.value = Global.globalStrength
		self.visible = true
		
