extends CharacterBody2D
class_name Grenade

@export var friction: float = 300.0
@export var explosionDamage :int = 100
@export var explosionRange : Area2D

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
@onready var colision_explosion_damage: CollisionShape2D = $areaGrenade/colisionExplosionDamage

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if pushGrenade:
		velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
		
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collison = get_slide_collision(i)
			var collider = collison.get_collider()
			
			if collider:
				velocity = velocity.bounce(collison.get_normal())
				velocity *= 0.6
				
				if collider.has_method("enemy"):
					explode()
		if velocity == Vector2.ZERO && pushGrenade:
			explode()
		
func launch(strengthGrenade):
	velocity = transform.x * (150.0 + strengthGrenade)
	
	pushGrenade = true
	
	tween = get_tree().create_tween().set_loops()
	tween.tween_property(point_light_2d,'energy',2,0.5)
	tween.tween_property(point_light_2d,'energy',0,0.5)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'explosion':
		queue_free()

func chose(array):
	array.shuffle()
	return array.front()

func explode(area= null):
	pushGrenade = false # Blokujemy dalszy ruch
	animation_player.play("explosion")
	if tween:
		tween.kill() # Wyłączamy miganie światła
		if area is HurtBoxComponent:
			area.takeDamage(explosionDamage,self)
			print(area)
			print(explosionDamage)
		
func _on_area_grenade_area_entered(area: Area2D) -> void:
	explode(area)
