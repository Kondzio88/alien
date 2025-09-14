extends ParallaxBackground


@onready var color_rect: ColorRect = $TextureRect/ColorRect
@onready var _mat: ShaderMaterial = color_rect.material as ShaderMaterial

func _ready() -> void:
	# Check if Material Exist and Set to Local Scecne but not allways work for Code !!!
	if _mat != null and !_mat.resource_local_to_scene:
		_mat.resource_local_to_scene = true

func set_density(value: float) -> void:
	if _mat:
		_mat.set_shader_parameter("density", value)

func tween_density(target: float, duration: float = 0.6) -> void:
	if _mat == null:
		return
	var from := float(_mat.get_shader_parameter("density"))
	var tw := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_method(func(v): _mat.set_shader_parameter("density", v), from, target, duration)
