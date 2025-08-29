extends CharacterBody2D
class_name Alien

var speed:int = 100

@onready var range_area: Area2D = $rangeArea

@onready var animated_sprite_2d = $AnimatedSprite2D
@export var bloodScene:PackedScene

@onready var attack_timer: Timer = $attackTimer
@onready var hurt_timer: Timer = $hurtTimer

@onready var alien_sound: AudioStreamPlayer2D = $alienSound
@onready var alien_bite_sound: AudioStreamPlayer2D = $alienBiteSound
@onready var alien_hurt_sound: AudioStreamPlayer2D = $alienHurtSound

@onready var target: CharacterBody2D = null
@onready var targetArray :Array = []

@onready var chaise :bool = false
@onready var hurt :bool = false
@onready var attackBack:bool = false

@onready var direction :Vector2 = Vector2.ZERO
@onready var pushDirection:Vector2 
@onready var newDirection :Vector2


func _ready():
	direction = Vector2.RIGHT
	
func _physics_process(delta):
	
	rotation = direction.angle()
	#playerPos = global_position.direction_to(Global.playerPosition.global_position)
	if chaise:
		targetArray = range_area.get_overlapping_bodies()
		target = targetArray[0]
	if !chaise:
		target = null
		targetArray = []
		

	velocity = direction * speed
	animated_sprite_2d.play("run")
	
	colision()
	hurtCheckAndChaise()
	move_and_slide()
	sound()
	
func _on_hurt_box_area_area_entered(area):
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,0,0,255)
		
	if area is not AreaLaser:
		hurt = true
		speed = 100
		hurt_timer.start()
		var blood = bloodScene.instantiate()
		get_tree().current_scene.add_child(blood)
		blood.global_position = area.global_position
		blood.rotation = global_position.angle_to_point(Global.playerPosition.global_position)
		blood.emitting = true
		pushDirection = get_vector_from_rotation(rotation)
		
func hurtCheckAndChaise():
	if hurt:
		direction = -pushDirection
		rotation = -pushDirection.angle()
		speed = 190
	else:
		if attackBack:
			velocity = -direction * speed
		else:
			if chaise:
				direction = global_position.direction_to(target.global_position)
				speed = 130
			if !chaise:
				speed = 100
			
func changeDirection():
	newDirection = Vector2(randi_range(-1,1),randi_range(-1,1))
	if newDirection == Vector2.ZERO:
		changeDirection()
	return newDirection

func _on_range_area_body_entered(body):
	if body is Player || body is Soldier || body is BlueSoldier || body is Guardian:
		chaise = true

func _on_range_area_body_exited(body):
	chaise = false

func _on_hurt_box_area_area_exited(area: Area2D) -> void:
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,255,255,255)

func get_vector_from_rotation(rotation: float) -> Vector2:
	return Vector2(cos(rotation), sin(rotation))

func _on_hurt_timer_timeout() -> void:
	hurt = false

func sound():
	if hurt:
		if !alien_hurt_sound.playing:
			alien_hurt_sound.play()
	else:
		if chaise && !alien_sound.playing:
			alien_sound.play()
		if !chaise:
			alien_sound.stop()

func colision():
	for i in get_slide_collision_count():
		var colision = get_slide_collision(i)
		if colision.get_collider():
			direction = changeDirection()
		if colision.get_collider().name == 'player' || colision.get_collider().name == 'soldier' || colision.get_collider().name == 'guardian' || colision.get_collider().name == 'blueSoldier':
			attack_timer.start()	
			attackBack = true
			
			velocity = direction * 100
			if !alien_bite_sound.playing:
				alien_bite_sound.play()

func _on_attack_timer_timeout() -> void:
	attackBack = false
	
