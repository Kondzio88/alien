extends PointLight2D


@onready var arrayEnergy:Array = [2,1.5,1,0.5,0.4,0.3,0.2,0.1,0,]
# Called when the node enters the scene tree for the first time.
func _ready():
	energy = chose(arrayEnergy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	energy = chose(arrayEnergy)

func chose(array):
	array.shuffle()
	return array.front()
