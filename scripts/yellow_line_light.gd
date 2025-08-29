extends Sprite2D

@onready var point_light_2d: PointLight2D = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(point_light_2d,'position',Vector2(98,0),1)
	tween.tween_property(point_light_2d,'position',Vector2(-98,0),0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
