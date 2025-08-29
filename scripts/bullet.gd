extends Area2D

class_name Bullet

@export var damage:int = 10
@export var speed: int = 400
@export var particleDestroyeScene: PackedScene
@onready var ray_cast_2d = $RayCast2D

var direction

func _ready():
	pass

func _physics_process(delta):
	position += direction * speed * delta
	if ray_cast_2d.is_colliding():
		destroye()
	
func launch(dir):
	direction = dir 
	
func dealDamage():
	return 10

func _on_visible_on_screen_enabler_2d_screen_exited():
	await get_tree().create_timer(2).timeout
	queue_free()

func destroye():
	var particle = particleDestroyeScene.instantiate()
	particle.global_position = self.global_position
	get_tree().root.add_child(particle)
	particle.emitting = true
	queue_free()
