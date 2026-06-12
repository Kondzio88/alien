extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	if Global.playerPosition:
		Global.playerPosition.batteryChange.connect(onBatteryChange)
		
		onBatteryChange(Global.playerPosition.battery,Global.playerPosition.maxBattery)

func onBatteryChange(current:int,maxValue:int):
	var targetPercentage = (float(current) / maxValue) * 100
	
	var tween = create_tween()
	tween.tween_property(self, "value", targetPercentage, 0.1).set_trans(Tween.TRANS_SINE)
