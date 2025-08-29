extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween:Tween = get_tree().create_tween().set_loops()
	tween.tween_property(self,'energy',2,0.5)
	tween.tween_property(self,'energy',0,0.5)
