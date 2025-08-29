extends CharacterBody2D

class_name Guardian

# General Stats
var speed:int = 70
var direction:Vector2 = Vector2.ZERO
@onready var maxHealth:int = 100
@onready var minHealth:int = 0
@onready var health:int = 100
@onready var walk :int = 40

# Bool
@onready var die:bool = false
@onready var chaise:bool = false
@onready var shooting :bool = false
@onready var attack:bool = false
@onready var shootTimerBool:bool = false
@onready var shootColiding:bool = false

# Player navigation
@export var playerNav:Node2D = null
@onready var player:CharacterBody2D = null
@onready var playerPos

# Packed Scenes
@export var bulletScene:PackedScene = preload("res://scenes/bullet.tscn")
@onready var luska:PackedScene = preload("res://scenes/particle/luska.tscn")
@onready var bloodScene :PackedScene = preload("res://scenes/particle/enemy_blood.tscn")

# General Nodes and navigation
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D

# Sounds
@onready var audio_dead:AudioStreamPlayer2D = $audioDead
@onready var audio_shoot:AudioStreamPlayer2D = $audioShoot
@onready var choise_audio: AudioStreamPlayer2D = $choiseAudio

# Area  Nodes , coliding
@onready var coliding: RayCast2D = $pointBullet/coliding
@onready var point_bullet:Marker2D = $pointBullet
@onready var range_area:Area2D = $rangeArea
@onready var hurt_box_area:Area2D = $hurtBoxArea
@onready var collision_shape_2d:CollisionShape2D = $CollisionShape2D

# Sprite 2D - blood dead sprite ,question
@onready var blood_sprite_dead: Sprite2D = $bloodSpriteDead
@onready var question:Sprite2D = $question

# Lights ,shadow
@onready var shadow: LightOccluder2D = $shadow
@onready var red_light:PointLight2D = $redLight

# Timer
@onready var shoot_timer: Timer = $shootTimer
@onready var chaise_timer: Timer = $chaiseTimer
@onready var recal_timer: Timer = $recalTimer


func _ready() -> void:
	direction = Vector2.UP
	recal_timer.timeout.connect(_on_recal_timer_timeout)
	red_light.enabled = false
	
func _physics_process(delta):
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider():
			direction = Vector2(changeDirection(),changeDirection())
	
	playerPos = Global.playerPosition.global_position
	
	question.rotation = -rotation
	question.global_position = self.global_position - Vector2(0,25)
	red_light.rotation = -rotation
	red_light.global_position = self.global_position - Vector2(0,25)
	
	if die:
		return
	else:
		
		if chaise && player:
			rotation = global_position.angle_to_point(player.global_position)
			direction = global_position.direction_to(navigation_agent_2d.get_next_path_position()).normalized()
			velocity = direction * speed
		if chaise && !player:
			rotation = global_position.angle_to_point(playerPos)
			direction = global_position.direction_to(playerPos).normalized()
			velocity = direction * speed
			
		if !chaise:
			if direction:
				if position.x > 0 :
					rotation = global_position.angle_to(direction)
				if position.x < 0:
					rotation = global_position.angle_to(-direction)
				velocity = direction * speed
			if !direction:
				velocity = direction * speed
	
	dead()
	move_and_slide()
	playAnimation(direction,delta)
	colidingShoot()
	
func shoot():
	if shooting && attack && player && !shootTimerBool && !shootColiding:
		shootTimerBool = true
		audio_shoot.play()
		var projectile = bulletScene.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_rotation = point_bullet.global_rotation
		projectile.global_position = point_bullet.global_position
		var launchDir = Vector2.RIGHT.rotated(point_bullet.global_rotation)
		projectile.launch(launchDir)
		var luskaItem = luska.instantiate()
		get_tree().root.add_child(luskaItem)
		luskaItem.global_position = point_bullet.global_position
		luskaItem.global_rotation = point_bullet.global_rotation
		shoot_timer.start()

func playAnimation(direction,delta):
	
	if die:
		animated_sprite_2d.play("dead")
	else:
		if !attack || shootColiding:
			if direction == Vector2.ZERO:
				animated_sprite_2d.play("idle")
			if direction != Vector2.ZERO:
				animated_sprite_2d.play("run")
				speed = 60
				
		if attack && !shootColiding:
			speed = 30
			animated_sprite_2d.play("aim")

func _on_range_area_body_entered(body):
	if body is Player  || body is Alien:
		player = body
		red_light.enabled = true
		question.visible = true
		chaise = true
		choise_audio.play()
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property(question,'scale',Vector2(0.7,0.7),0.3)
		tween.tween_property(question,'scale',Vector2(0.4,0.3),0.4)

func _on_range_area_body_exited(body):
	if body is Player || body is Alien:
		player = null
		chaise_timer.start()

func _on_hurt_box_area_area_entered(area):
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,0,0,255)
	if area is not AreaLaser:
		var blood = bloodScene.instantiate()
		get_tree().root.add_child(blood)
		blood.global_position = area.global_position
		blood.rotation = global_position.angle_to_point(Global.playerPosition.global_position)
		blood.emitting = true
		health -= area.dealDamage()
		chaise = true

func dead():
	if health <= 0:
		shadow.queue_free()
		audio_dead.play()
		range_area.queue_free()
		question.visible = false
		red_light.enabled = false
		collision_shape_2d.queue_free()
		hurt_box_area.queue_free()
		direction = Vector2.ZERO
		die = true
		animated_sprite_2d.play("dead")
		var tween = get_tree().create_tween()
		tween.tween_property(blood_sprite_dead,'scale',Vector2(0.8,0.8),4)
		await get_tree().create_timer(7).timeout
		queue_free()

func _on_shoot_area_body_entered(body: Node2D) -> void:
	if body is Player:
		shooting = true
		attack = true

func _on_shoot_area_body_exited(body: Node2D) -> void:
	shooting = false
	attack = false

func _on_recal_timer_timeout():
	makePath()
	
func makePath():
	if player:
		navigation_agent_2d.target_position = player.global_position

func _on_shoot_timer_timeout() -> void:
	shootTimerBool = false
	if player && shooting :
		shoot()

func colidingShoot():
	if shooting:
		coliding.target_position = to_local(player.global_position)
	if coliding.get_collider() == player:
		shootColiding = false
		shoot()
	else:
		shootColiding = true
		
func enemy():
	pass

func changeDirection():
	return randi_range(-1,1)

func _on_hurt_box_area_area_exited(area: Area2D) -> void:
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,255,255,255)

func _on_chaise_timer_timeout() -> void:
	if player == null:
		chaise = false
		if !chaise:
			red_light.enabled = false
			question.visible = false
