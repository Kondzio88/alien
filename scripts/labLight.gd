extends PointLight2D


@onready var arrayEnergy:Array = [1,0.5,0.4,0.3,0.2,0.1,0,0,0,0,0]
# Called when the node enters the scene tree for the first time.
func _ready():
	tweenEnergy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func tweenEnergy():
	var tween:Tween = create_tween()
	var targetEnergy = arrayEnergy.pick_random()
	tween.tween_property(self,'energy',targetEnergy,0.01)
	tween.finished.connect(tweenEnergy)
	
