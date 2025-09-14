extends ColorRect
@onready var fog: ColorRect = $"."
@onready var _mat: ShaderMaterial = fog.material as ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(_mat.get_shader_parameter('density'))
	
func tween_density(target: float, duration: float = 0.6) -> void:
	print('density is ok')
	if _mat == null:
		return
	var from := float(_mat.get_shader_parameter("density"))
	var tw := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_method(func(v): _mat.set_shader_parameter("density", v), from, target, duration)
