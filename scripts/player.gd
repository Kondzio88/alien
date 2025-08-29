extends CharacterBody2D

class_name Player


@onready var health:int = 100
@onready var maxHealth:int = 100

@export var speed:int = 130
@export var rotationSpeed:int =5
@export var walk:int = 130
@export var aimSpeed:int = 90
@export var sprint:int = 180
var direction:Vector2 = Vector2.ZERO

# Player bool
var aiming :bool = false
var shooting:bool = false
var sprinting:bool = false
var die:bool = false
var reload:bool = false
var frag:bool = false
var canMove:bool = true

# Global bool
var pushGrenade :bool = false
var droneEquipe:bool = false
var droneActive:bool = false
var laserActive:bool = false
var magazineActive:bool = false

# Gun,battery,strength grenade player and UI
@onready var magazine:int = 15
@onready var battery:int
@onready var maxBattery :int = 1000
@onready var strengthGrenade:int = 0
@onready var grenadeMagazine:int = 3
@onready var armor:int = 0

# Packed Scene Player
@onready var bullet:PackedScene = preload("res://scenes/bullet.tscn")
@onready var luska :PackedScene= preload("res://scenes/particle/luska.tscn")
@onready var bloodScene :PackedScene = preload("res://scenes/particle/enemy_blood.tscn")
@onready var magazineScene :PackedScene = preload("res://scenes/particle/magazine_particle.tscn")
@onready var grenade:PackedScene = preload("res://scenes/grenade.tscn")
@onready var droneScene :PackedScene = preload("res://scenes/drone.tscn")

# Camera , AnimatedSprite, Colison , Transition, PointBullet
@onready var camera_2d: Camera2D = $Camera2D
@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_polygon_2d:CollisionPolygon2D = $CollisionPolygon2D
@onready var collision_shape_2d:CollisionShape2D = $CollisionShape2D
@onready var point_bullet:Marker2D = $pointBullet
@onready var transition: = $transition/AnimationPlayer

# FlashLight Player
@onready var flashlight:PointLight2D = $flashlight
@onready var flashlight_2:PointLight2D = $flashlight2
@onready var flashlight_3: PointLight2D = $flashlight3
@onready var flashLigthsArray :Array = [flashlight,flashlight_2,flashlight_3]
@onready var arrayEnergy:Array = [1,0.4,0.3,0,0,0,0,0,0]

# Audio
@onready var audio_shoot: = $audioShoot
@onready var audio_reload = $audioReload
@onready var audio_reload_2 = $audioReload2
@onready var audio_walk = $audioWalk
@onready var audio_run = $audioRun
@onready var audio_dead = $transition/audioDead
@onready var electric_flash_light: AudioStreamPlayer2D = $electricFlashLight

# Fire Lights and Shadow Player
@onready var fire_light = $pointBullet/fireLight
@onready var fire_light_2 = $pointBullet/fireLight2
@onready var fire_light_3 = $pointBullet/fireLight3
@onready var shadow: LightOccluder2D = $shadow
@onready var arraylightFire :Array = [fire_light,fire_light_2,fire_light_3]

# Grenade Sprite and Laser
@onready var grenadeSprite: CharacterBody2D = $grenade
@onready var red_grenade_light: PointLight2D = $redGrenadeLight
@onready var laser: RayCast2D = $laser

func _ready():
	collision_polygon_2d.disabled = true
	red_grenade_light.enabled = false
	battery = maxBattery
	
	Global.playerPosition = self
	Global.laserSignal.connect(laserAvaible)
	Global.idCardSignal.connect(idCardAvaible)
	Global.droneSignal.connect(droneAvaible)
	Global.magazineSignal.connect(magazineAvaible)
	
	# Script Scene Lvl 2
	Global.scriptSceneLvl2.connect(scriptSceneLvl2)
	Global.scriptSceneLvl2DeadSoldier.connect(scriptSceneLvl2End)
	
	droneActive = false
	laserActive = false
	magazineActive = false
	
func _physics_process(delta):
	
	if die:
		return
	else:
		Global.globalBattery = battery
		Global.playerHealthUi = health
		Global.globalBullets = str(magazine)
		Global.globalStrength = strengthGrenade
		Global.globalGrenadeMagazine = str(grenadeMagazine)
		Global.globalArmorPrecent = str(armor)
		
		var mouse_position = get_global_mouse_position()
		var angleVec = global_position.angle_to_point(mouse_position)
		
		if canMove:
			rotation = angleVec
			velocity = direction * speed 
			
		if !canMove:
			direction = Vector2.ZERO
			velocity = direction * 0
			rotation = angleVec
			animated_sprite_2d.play('idle')
			
		move_and_slide()
		playAnimation(delta)
		rigidBodyPush()
		dead()
		batteryStatus()
		camera()
		armorFunc()
		droneSceneInstant()
		laserCheck()
		magazineCheck()
		flashLightArrayDisplay(flashLigthsArray)
		
@warning_ignore("unused_parameter")
func _input(event):
	direction = Input.get_vector('left',"right","up",'down')
	if Input.is_action_pressed("aim"):
		aiming = true
	if Input.is_action_just_released("aim"):
		aiming = false
	if Input.is_action_pressed("sprint") && !aiming:
		sprinting = true
	if Input.is_action_just_released('sprint'):
		sprinting = false
	if Input.is_action_just_pressed("shoot") && aiming:
		shooting = true
	if Input.is_action_just_released("shoot"):
		shooting = false
	if Input.is_action_just_pressed("reload") && !reload:
		reload = true
		reloadMagazine()
	if Input.is_action_just_pressed("fragGrenade"):
		frag = true
	if Input.is_action_just_released("fragGrenade"):
		frag = false
		pushGrenade = true
	
func playAnimation(delta):
	if die :
		animated_sprite_2d.play("dead")
	else:
		if canMove:
			
			# Frag Grenade Logic
			
			if frag && grenadeMagazine >0:
				aiming = false
				animated_sprite_2d.play("fragGrenade")
				red_grenade_light.enabled = true
				strengthGrenade += 2
				collision_polygon_2d.disabled = true
				flashlight.enabled = false
				flashlight_2.enabled = false
				if strengthGrenade >= 300:
					strengthGrenade = 300
			if !frag:
				red_grenade_light.enabled = false
				
				# Push Grenade and initialize ShootGrenade function
				
				if pushGrenade:
					pushGrenade = false
					shootGrenade(delta,strengthGrenade)
					strengthGrenade = 0
					
			if reload:
				animated_sprite_2d.play("reload")
			if !reload && !frag:
				
				# Aiming Logic
				
				if aiming:
					speed = aimSpeed
					animated_sprite_2d.play("aim")
					collision_polygon_2d.disabled = false
					if aiming && laserActive:
						laser.visible = true
					if aiming && direction != Vector2.ZERO:
						if !audio_walk.playing:
							audio_walk.volume_db = -7
							audio_walk.play()
					if shooting:
						shoot(delta)
						shooting = false
				
				else:
					collision_polygon_2d.disabled = true
					laser.visible = false
					
					# Animated Sprite state and set speed player 
					
					if direction && !sprinting:
						animated_sprite_2d.play("walk")
						if !audio_walk.playing:
							audio_walk.volume_db = 0
							audio_walk.play()
					if !direction:
						animated_sprite_2d.play("idle")
						audio_walk.stop()
						audio_run.stop()
					if !aiming && !sprinting:
						speed = walk
					if direction && !aiming && sprinting:
						speed = sprint
						animated_sprite_2d.play("run")
						if !audio_run.playing:
							audio_run.play()
							audio_walk.stop()
						
# Shoot , Shoot Grenade and Reload Magazine -------

@warning_ignore("unused_parameter")
func shoot(delta):
	if magazine > 0:
		magazine -= 1
		lightFireOn()
		audio_shoot.play()
		var projectile = bullet.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_rotation = point_bullet.global_rotation
		projectile.global_position = point_bullet.global_position
		var launchDir :Vector2 = Vector2.RIGHT.rotated(point_bullet.global_rotation)
		projectile.launch(launchDir)
		var luskaItem = luska.instantiate()
		get_tree().root.add_child(luskaItem)
		luskaItem.global_position = point_bullet.global_position
		luskaItem.global_rotation = point_bullet.global_rotation
		
@warning_ignore("shadowed_variable")
func shootGrenade(delta,strengthGrenade):
	if grenadeMagazine > 0:
		grenadeMagazine -= 1
		var projectile = grenade.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_position = point_bullet.global_position
		projectile.global_rotation = point_bullet.global_rotation
		var launchDir :Vector2 = Vector2.RIGHT.rotated(point_bullet.global_rotation)
		projectile.launch(launchDir,delta,strengthGrenade)
		
func reloadMagazine():
	if !die:
		var magazineParticle = magazineScene.instantiate()
		get_tree().root.add_child(magazineParticle)
		magazineParticle.global_position = self.global_position
		magazineParticle.global_rotation = self.global_rotation
		laser.visible = false
		if reload && magazineActive:
			audio_reload.play()
			magazine = 25
			await get_tree().create_timer(1).timeout
			reload = false
		if reload && !magazineActive:
			audio_reload.play()
			magazine = 15
			await get_tree().create_timer(1).timeout
			reload = false

# Flash Light and Light Fire --------------------

func flashLightArrayDisplay(array):
	if aiming && !die:
		for i in array:
			i.enabled = true
	else:
		for i in array:
			i.enabled = false
		
func lightFireOn():
	for i in arraylightFire:
		i.enabled = true
	await get_tree().create_timer(0.1).timeout
	lightFireOff()
	
func lightFireOff():
	for i in arraylightFire:
		i.enabled = false

# Hurt Box Function and Dead Function ------------

func _on_hurt_box_area_area_entered(area):
	if area is Bullet || area is AlienArea:
		if armor > 0:
			armor -= 25
		else:
			var blood = bloodScene.instantiate()
			get_tree().current_scene.add_child(blood)
			blood.global_position = area.global_position
			blood.rotation = global_position.angle_to_point(area.global_position)
			blood.emitting = true
			health -= area.dealDamage()
			Global.playerHealthUi -= area.dealDamage()
			
	if area is Grenade || area is Barell:
		
		var blood = bloodScene.instantiate()
		get_tree().current_scene.add_child(blood)
		blood.global_position = area.global_position
		blood.rotation = global_position.angle_to_point(area.global_position)
		blood.emitting = true
		health -= area.dealDamage()
		Global.playerHealthUi -= area.dealDamage()

func dead():
	if health <= 0:
		animated_sprite_2d.z_index = -1
		laser.queue_free()
		shadow.queue_free()
		collision_shape_2d.queue_free()
		die = true
		playAnimation('dead')
		red_grenade_light.enabled = false
		audio_dead.play()
		for i in flashLigthsArray:
			i.enabled = false
		await get_tree().create_timer(2).timeout
		transition.play('transition')
		await get_tree().create_timer(3).timeout
		get_tree().reload_current_scene()

func rigidBodyPush():
	var pushDirection :Vector2 = direction
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is Chest:
			c.get_collider().test(pushDirection)
			if !get_node('chestSound').playing:
				get_node('chestSound').play()
				
func healthPlus():
	health += 33
	if health >= maxHealth:
		health = maxHealth

func batteryStatus():
	if aiming:
		battery -= 1 
		if battery < 0:
			battery = 0
			
	if !aiming && battery < maxBattery:
		battery += 3 
		if battery > maxBattery:
			battery = maxBattery
			
	if battery > 250:
		flashlight.energy = 0.6
		flashlight_2.energy = 0.8
		flashlight_3.energy = 0.7
		electric_flash_light.stop()
		
	if battery <= 250:
		for i in flashLigthsArray:
			i.energy = chose(arrayEnergy)
			if !electric_flash_light.playing && aiming:
				electric_flash_light.play()
			
	if battery <= 0:
		for i in flashLigthsArray:
			i.energy = 0
		electric_flash_light.stop()

func chose(array):
	array.shuffle()
	return array.front()

func camera():
	if canMove:
		var cameraTween:Tween = get_tree().create_tween()
		if aiming && battery > 0 && Global.laserEquipeGlobal:
			cameraTween.tween_property(camera_2d,'zoom',Vector2(1.8,1.8),0.5)
		if aiming && battery > 0|| frag :
			cameraTween.tween_property(camera_2d,'zoom',Vector2(2,2),0.5)
		if !aiming && !frag || aiming && battery <= 0:
			cameraTween.tween_property(camera_2d,'zoom',Vector2(2.3,2.3),0.5)
	if !canMove:
		camera_2d.zoom = Vector2(1.7,1.7)
		
# GLOBAL EQUIPE PLAYER and Armor ,Grenade Plus

func laserAvaible():
	Global.laserEquipeGlobal = true

func laserCheck():
	if Global.laserEquipeGlobal && !laserActive:
		laserActive = true

func idCardAvaible():
	Global.globalIdCardEquipe = true

func armorFunc():
	if armor <= 0:
		Global.globalArmor = false

func armorPlus():
	Global.globalArmor = true
	armor = 100

func grenadePlus():
	grenadeMagazine += 2

func droneAvaible():
	Global.droneEquipeGlobal = true

func droneSceneInstant():
	if Global.droneEquipeGlobal && !droneActive:
		droneActive = true
		var drone = droneScene.instantiate()
		get_tree().current_scene.add_child(drone)
		drone.global_position = self.global_position

func magazineAvaible():
	Global.magazineEquipe = true

func magazineCheck():
	if Global.magazineEquipe && !magazineActive:
		magazineActive = true

# SCRIPT SCENES ---------------------------

func scriptSceneLvl2():
	canMove = false
	
func scriptSceneLvl2End():
	canMove = true
