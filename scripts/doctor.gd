extends CharacterBody2D

const speed :int = 50
var direction:Vector2 = Vector2.ZERO

@onready var maxHealth:int = 50
@onready var minHealth:int = 0
@onready var health:int = 50

var die :bool = false

@export var moveDirection:Vector2

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_dead: AudioStreamPlayer2D = $audioDead
@onready var hit_sound: AudioStreamPlayer = $hitSound

@onready var bloodScene :PackedScene = preload("res://scenes/particle/enemy_blood.tscn")
@onready var idCard:PackedScene = preload("res://scenes/id_card.tscn")

func _ready() -> void:
	direction = Vector2.UP

func _physics_process(delta: float) -> void:
	
	if die:
		return
	else:
		for i in get_slide_collision_count():
			var c = get_slide_collision(i)
			if c.get_collider():
				moveDirection *= -1
				direction = moveDirection
			
		if direction:
			rotation = global_position.angle_to(direction)
			velocity = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			
	move_and_slide()
	playAnimation(direction)
	dead()
	
func playAnimation(direction):
	if die:
		animated_sprite_2d.play("dead")
	else:
		if direction == Vector2.ZERO:
			animated_sprite_2d.play("idle")
		if direction != Vector2.ZERO:
			animated_sprite_2d.play("run")
				
func dead():
	if health <= 0:
		hit_sound.stop()
		audio_dead.play()
		$CollisionShape2D.queue_free()
		$Area2D/CollisionShape2D.queue_free()
		animated_sprite_2d.play("dead")
		var card = idCard.instantiate()
		card.global_position = self.global_position
		die = true
		get_tree().root.add_child(card)
		await get_tree().create_timer(7).timeout
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,0,0,255)
	if area is not AreaLaser:
		var blood = bloodScene.instantiate()
		get_tree().root.add_child(blood)
		blood.global_position = area.global_position
		blood.rotation = global_position.angle_to_point(Global.playerPosition.global_position)
		blood.emitting = true
		health -= area.dealDamage()
		if !hit_sound.playing:
			hit_sound.play()
		if area is Bullet:
			direction = area.direction
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is AreaLaser:
		animated_sprite_2d.modulate = Color8(255,255,255,255)
