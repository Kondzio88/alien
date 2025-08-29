extends Sprite2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var tween:Tween = get_tree().create_tween().set_loops()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween.tween_property(point_light_2d,'energy',1,1)
	tween.tween_property(point_light_2d,'energy',0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.idCardSignal.emit()
	queue_free()
