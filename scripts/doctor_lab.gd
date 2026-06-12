extends CharacterBody2D

@export var speed:int = 30
@export var health:int = 50

@onready var bloodScene :PackedScene = preload("res://scenes/particle/enemy_blood.tscn")
@onready var idCard:PackedScene = preload("res://scenes/id_card.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var direction:Vector2 = Vector2.RIGHT
@onready var hurt_box_component: HurtBoxComponent = $hurtBoxComponent
@onready var blood_dead: Sprite2D = $bloodDead
@onready var dead_sound: AudioStreamPlayer2D = $deadSound

@onready var die:bool = false

func _ready() -> void:
	hurt_box_component.tookDamage.connect(receiveDamage)

func _physics_process(delta: float) -> void:
	velocity = direction * speed 
	
	animation()
	move_and_slide()

func animation():
	if !die:
		if speed >= 0:
			animated_sprite_2d.play("walk")
		else:
			animated_sprite_2d.play("idle")
	if die:
		animated_sprite_2d.play('dead')
		
func receiveDamage(damage:int, hitBox:Node2D):
	dead_sound.play()
	var blood = bloodScene.instantiate()
	get_tree().root.add_child(blood)
	blood.global_position = hitBox.global_position
	blood.rotation = global_position.angle_to_point(hitBox.global_position)
	blood.emitting = true
	health -= damage
	if health <=0 :
		dead()
		
func dead():
	die = true
	speed = 0
	self.set_collision_layer_value(1,false)
	self.set_collision_mask_value(1,false)
	hurt_box_component.queue_free()
	var tween:Tween = get_tree().create_tween()
	self.scale = Vector2(1.2,1.2)
	tween.tween_property(blood_dead,'scale',Vector2(0.8,0.8),4)
	var card = idCard.instantiate()
	get_tree().root.add_child(card)
	card.global_position = self.global_position
	await get_tree().create_timer(7).timeout
	queue_free()
