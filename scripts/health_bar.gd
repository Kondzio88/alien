extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	
	if Global.playerPosition:
		Global.playerPosition.healthChange.connect(onPlayerHealthChange)
	
		onPlayerHealthChange(Global.playerPosition.health,Global.playerPosition.maxHealth)


func onPlayerHealthChange(currentHealth:int,maxhealth:int):
	var targetPercent = (float(currentHealth) / maxhealth) * 100
	
	var tween: Tween = create_tween()
	tween.tween_property(self,'value',targetPercent,0.25).set_trans(Tween.TRANS_SINE)
