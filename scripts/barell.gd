extends StaticBody2D


@onready var explosion: GPUParticles2D = $explosion
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_box: CollisionShape2D = $Area2D2/hitBox
@onready var explode:bool = false
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hurt_box: CollisionShape2D = $Area2D/hurtBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health:int = 15
@onready var laser_target_light: PointLight2D = $laserTargetLight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	health -= area.dealDamage()
	if health <= 0:
		animation_player.play('explosion')
	if area is AreaLaser:
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property(laser_target_light,'texture_scale',1,0.5)
		tween.tween_property(laser_target_light,'texture_scale',0,0.5)
		laser_target_light.enabled = true
		
func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is AreaLaser:
		laser_target_light.enabled = false
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'explosion':
		queue_free()
