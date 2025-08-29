extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween().set_loops()
	tween.tween_property(self,'energy',1,0.5)
	tween.tween_property(self,'energy',0,1.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
