extends StaticBody2D


@onready var tween: Tween = get_tree().create_tween().set_loops()
@onready var player:CharacterBody2D = null
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var color_rect: ColorRect = $Sprite2D/ColorRect
@onready var mat := color_rect.material as ShaderMaterial

var open:bool = false

func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && player && !open:
		player.grenadePlus()
		open = true
		get_node('AudioStreamPlayer2D').play()
		collision_shape_2d.disabled = true
	if open:
		player = null
		mat.set_shader_parameter('Brightness',0.0)
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	if !open && player:
		Global.tipOnSignal.emit()
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	player = null
	Global.tipOffSignal.emit()
