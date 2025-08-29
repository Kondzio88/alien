extends StaticBody2D

@onready var label: Label = $Label
var player: CharacterBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var open :bool = false

func _ready() -> void:
	player = null

func _process(delta: float) -> void:
	
	if player && Input.is_action_just_pressed("action") && !open:
		open = true
		player.healthPlus()
		audio_stream_player_2d.play()
		collision_shape_2d.disabled = true
		sprite_2d.visible = false
		point_light_2d.enabled = false
		Global.tipOffSignal.emit()
		await get_tree().create_timer(1).timeout
		queue_free()

		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		point_light_2d.enabled = true
		Global.tipOnSignal.emit()
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	player = null
	point_light_2d.enabled = false
	Global.tipOffSignal.emit()
	
