extends StaticBody2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var tween: Tween = get_tree().create_tween().set_loops()
@onready var player:CharacterBody2D = null
@onready var collision_shape_2d: CollisionShape2D = $openArea/CollisionShape2D
var open:bool = false

func _ready() -> void:
	tween.tween_property(point_light_2d,'energy',1,1)
	tween.tween_property(point_light_2d,'energy',0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && player && !open:
		Global.laserSignal.emit()
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
