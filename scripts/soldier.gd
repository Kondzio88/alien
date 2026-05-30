extends CharacterBody2D

class_name Soldier

@onready var soldier = $"."
@onready var speed:int= 50

# General Stats 
@onready var maxHealth:int = 100
@onready var minHealth:int = 0
@onready var health:int = 100
@onready var direction :Vector2 = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Boll stats 
@onready var chaise:bool = false
@onready var attack:bool = false
@onready var shooting :bool = false
@onready var die:bool = false
@onready var shootTimerBool:bool = false
@onready var shootColiding:bool = false

# Nodes animated , collision ,point , hurtBox ,rangeArea ,rayCast Coliding
@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d:CollisionShape2D = $CollisionShape2D
@onready var point_bullet:Marker2D = $pointBullet
@onready var hurt_box_area:Area2D = $hurtBoxArea
@onready var range_area:Area2D = $rangeArea
@onready var colidingRayCast: RayCast2D = $pointBullet/coliding

# Question , lights and navigation ,and bloodSprite dead
@onready var question:Sprite2D = $question
@onready var red_light_question:PointLight2D = $redLightQuestion
@onready var navigation_agent_2d : NavigationAgent2D = $NavigationAgent2D
@onready var blood_sprite_dead: Sprite2D = $bloodSpriteDead

# Sounds
@onready var what_audio: AudioStreamPlayer2D = $whatAudio
@onready var audio_shoot:AudioStreamPlayer2D = $audioShoot
@onready var audio_dead:AudioStreamPlayer2D = $audioDead
@onready var audio_walk:AudioStreamPlayer2D = $audioWalk
@onready var fuck_you_audio: AudioStreamPlayer2D = $fuckYouAudio
@onready var fuck_audio: AudioStreamPlayer2D = $fuckAudio

# Packed Scenes Instantiate
@export var bulletScene:PackedScene = preload("res://scenes/bullet.tscn")
@onready var luska:PackedScene = preload("res://scenes/particle/luska.tscn")
@onready var bloodScene :PackedScene = preload("res://scenes/particle/enemy_blood.tscn")

# Timers
@onready var shoot_timer: Timer = $shootTimer
@onready var recal_timer = $recalTimer
@onready var chaise_timer: Timer = $chaiseTimer

# Player coordinate and player Nav
@onready var player:CharacterBody2D = null
@export var playerNav: Node2D
@onready var playerPos # Global cordinate when player isnt chaise

func _ready():
	direction = Vector2.UP
	recal_timer.timeout.connect(_on_recal_timer_timeout)
	
func _physics_process(delta):
	
	# Change move direction when touch avoide
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider():
			direction = Vector2(changeDirection(),changeDirection())
			
	# Question Sign Position
	question.rotation = -rotation
	question.global_position = self.global_position - Vector2(0,25)
	red_light_question.rotation = -rotation
	red_light_question.global_position = self.global_position - Vector2(0,25)
	
	if die:
		return
	else:
		# Chaise logic when player is at Area
		if chaise && player:
			rotation = global_position.angle_to_point(player.global_position)
			direction = global_position.direction_to(navigation_agent_2d.get_next_path_position()).normalized()
			velocity = direction * speed
		if chaise && !player:
			# playerPos Global Script position player to navigate when chaise and no player
			playerPos = Global.playerPosition.global_position  
			rotation = global_position.angle_to_point(playerPos)
			direction = global_position.direction_to(playerPos).normalized()
			velocity = direction * speed
			
		if !chaise:
			if direction:
				# Zmiana rotacji wzgledem osi X ogolnie na mapie
				if position.x > 0 :
					rotation = global_position.angle_to(direction)
				if position.x < 0:
					rotation = global_position.angle_to(-direction)
				velocity = direction * speed
			if !direction:
				velocity = direction * speed
			
	dead()
	playAnimation(direction,delta)
	move_and_slide()
	colidingShoot()
	
# Create Navigation Path to Player
func makePath():
	if player:
		navigation_agent_2d.target_position = player.global_position

# Animated Sprite Texture Logic
func playAnimation(direction,delta):
	
	if die:
		animated_sprite_2d.play("dead")
	else:
		#zakomentuj shootColiding
		if !attack || shootColiding:
			if direction == Vector2.ZERO:
				animated_sprite_2d.play("idle")
			if direction != Vector2.ZERO:
				animated_sprite_2d.play("run")
				speed = 50
				if !audio_walk.playing:
					audio_walk.play()
		if attack && !shootColiding:
			speed = 20
			animated_sprite_2d.play("aim")
		
func _on_range_area_body_entered(body):
	if body is Player && !chaise:
		what_audio.play()
	if body is Player || body is Alien:
		
		player = body
		red_light_question.enabled = true
		question.visible = true
		chaise = true
		var tween :Tween = get_tree().create_tween().set_loops()
		tween.tween_property(question,'scale',Vector2(0.7,0.7),0.3)
		tween.tween_property(question,'scale',Vector2(0.4,0.3),0.4)
		
func _on_range_area_body_exited(body):
	if body is Player || body is Alien:
		player = null
		chaise_timer.start()

func shoot():
	if shooting && attack && player && !shootTimerBool && !shootColiding:
		shoot_timer.start()
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
		fuck_you_audio.play()
		
# Func Determinated shoot for 2.0s, not auto shoot
func _on_shoot_timer_timeout() -> void:
	shootTimerBool = false
	if player && shooting :
		shoot()

func _on_hurt_box_area_area_entered(area):
	
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,0,0,255)
	if area is not AreaLaser:
		if !fuck_audio.playing:
			fuck_audio.play()
		var blood = bloodScene.instantiate()
		get_tree().root.add_child(blood)
		blood.global_position = area.global_position
		blood.rotation = global_position.angle_to_point(Global.playerPosition.global_position)
		blood.emitting = true
		health -= area.dealDamage()
		chaise = true
		var tween = get_tree().create_tween().set_loops()
		tween.tween_property(question,'scale',Vector2(0.7,0.7),0.3)
		tween.tween_property(question,'scale',Vector2(0.4,0.3),0.4)

func dead():
	if health <= 0:
		# Dialog Signal Emit 
		Dialogs.dialogSoldierKillLvl1.emit()
		
		
		chaise = false
		shooting = false
		attack = false
		player = null
		self.z_index = 4
		range_area.queue_free()
		collision_shape_2d.queue_free()
		hurt_box_area.queue_free()
		question.visible = false
		red_light_question.enabled = false
		audio_dead.play()
		direction = Vector2.ZERO
		what_audio.stop()
		fuck_you_audio.stop()
		fuck_audio.stop()
		die = true
		animated_sprite_2d.play("dead")
		var tween:Tween = get_tree().create_tween()
		tween.tween_property(blood_sprite_dead,'scale',Vector2(0.6,0.6),4)
		await get_tree().create_timer(7).timeout
		queue_free()

func _on_shoot_area_body_entered(body):
	attack = true
	shooting = true

func _on_shoot_area_body_exited(body):
	attack = false
	shooting = false

func changeDirection():
	return randi_range(-1,1)

# Func to create Navigation Path for 0,1s
func _on_recal_timer_timeout():
	makePath()

# Function to detect avoids or Player then Shoot or Not
func colidingShoot():
	if shooting && player:
		colidingRayCast.target_position = to_local(player.global_position)
	if colidingRayCast.get_collider() == player:
		shootColiding = false
		shoot()
	else:
		shootColiding = true
		

func _on_chaise_timer_timeout() -> void:
	if player == null:
		chaise = false
		if !chaise:
			red_light_question.enabled = false
			question.visible = false

func _on_hurt_box_area_area_exited(area: Area2D) -> void:
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,255,255,255)

func enemy():
	pass
