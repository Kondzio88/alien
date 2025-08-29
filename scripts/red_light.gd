extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(self,'energy',5,1).set_ease(Tween.EASE_IN)
	tween.tween_property(self,'energy',1,1)
	
