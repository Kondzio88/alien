extends StaticBody2D

@onready var bullet:PackedScene = preload("res://scenes/bullet.tscn")
@onready var luska :PackedScene= preload("res://scenes/particle/luska.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var canShoot: bool = false
@onready var posiibleShootTarget:bool = false
@onready var gun: Sprite2D = $gun
@onready var detection_area: Area2D = $detectionArea
@onready var bullet_poiont: Marker2D = $gun/bulletPoiont
@onready var shoot_sound: AudioStreamPlayer2D = $shootSound
@onready var currentTarget:Node2D = null


func _ready() -> void:
	pass
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentTarget && posiibleShootTarget:
		gun.look_at(currentTarget.global_position)
		animated_sprite_2d.look_at(currentTarget.global_position)
		gun.rotation_degrees -= 90
		animated_sprite_2d.rotation_degrees -= 90
		if canShoot:
			shoot(delta)
			
func shoot(delta):
	if canShoot && posiibleShootTarget:
		gun.z_index = -1
		canShoot = false
		var projectile = bullet.instantiate() 
		get_tree().root.add_child(projectile)
		projectile.global_position =  bullet_poiont.global_position
		projectile.global_rotation = bullet_poiont.global_rotation + deg_to_rad(90)
		
		shoot_sound.play()
		animated_sprite_2d.play("shoot")
		await get_tree().create_timer(0.2).timeout
		canShoot = true


func _on_detection_area_body_entered(body: Node2D) -> void:
	if  body is Player:
		canShoot = true
		posiibleShootTarget = true
		currentTarget = body
	
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		posiibleShootTarget = false
		canShoot = false
		currentTarget = null
		animated_sprite_2d.stop()
	
