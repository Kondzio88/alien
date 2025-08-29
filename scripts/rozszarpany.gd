extends CharacterBody2D

class_name Rozszarpany
var SPEED = 10

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var blood_sprite: Sprite2D = $bloodSprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var dead_audio: AudioStreamPlayer2D = $deadAudio

func _ready() -> void:
	audio_stream_player_2d.play()
	Global.scriptSceneLvl2DeadSoldier.connect(deadSoldier)
	
func _physics_process(delta: float) -> void:

	var direction : Vector2 = global_position.direction_to(Global.playerPosition.global_position)
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = direction * 0

	move_and_slide()

func deadSoldier():
	SPEED = 0
	animated_sprite_2d.play('dead')
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(blood_sprite,'scale',Vector2(1,1),5)
	collision_shape_2d.queue_free()
	dead_audio.play()
