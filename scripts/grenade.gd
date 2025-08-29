extends CharacterBody2D

@onready var speed:int = 200
@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var tween: Tween 
@onready var explosion: GPUParticles2D = $explosion
@onready var direction:Vector2 = Vector2.ZERO
@onready var strength:float
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var point_light_2d_2: PointLight2D = $PointLight2D2
@onready var arrayEnergy:Array = [0.5,1,1.5,2,2.5,3]
@onready var pushGrenade:bool = false

func _ready() -> void:
	tween = get_tree().create_tween().set_loops()
	tween.tween_property(point_light_2d,'energy',2,0.5)
	tween.tween_property(point_light_2d,'energy',0,0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	point_light_2d.energy = chose(arrayEnergy)
	
	if pushGrenade:
		velocity = direction * strength
		strength -= 0.05
		if strength < 50:
			strength -= 0.3
	if strength <= 0:
		strength = 0 
		tween.kill()
		animation_player.play('explosion')
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider():
			direction = direction.rotated(180)
			strength -= 20 
			if collision.get_collider().has_method('enemy'):
				animation_player.play('explosion')
				
	
	print(strength)
	
	move_and_slide()
	
func launch(dir,delta,strengthGrenade):
	direction = dir
	strength = strengthGrenade
	pushGrenade = true
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'explosion':
		queue_free()

func chose(array):
	array.shuffle()
	return array.front()
