extends PointLight2D

@onready var red_light_alarm: PointLight2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(red_light_alarm,'energy',2,0.5)
	tween.tween_property(red_light_alarm,'energy',0,1)
	tween.tween_property(red_light_alarm,'energy',0,2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
