extends StaticBody2D

var tween = create_tween().set_loops()
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var open :bool = false
@onready var player : CharacterBody2D = null
@onready var collision_shape_2d: CollisionShape2D = $openArea/CollisionShape2D

func _ready() -> void:
	tween.tween_property(point_light_2d,'energy',1,1)
	tween.tween_property(point_light_2d,'energy',0,1)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && player && !open:
		Global.magazineSignal.emit()
		open = true
		collision_shape_2d.disabled = true
	if open:
		player = null
		tween.kill()
		point_light_2d.enabled = false
		
func _on_open_area_body_entered(body: Node2D) -> void:
	player = body
	if !open && player:
		Global.tipOnSignal.emit()


func _on_open_area_body_exited(body: Node2D) -> void:
	player = null
	Global.tipOffSignal.emit()
