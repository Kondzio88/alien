extends Area2D

class_name Bullet

@export var damage:int = 10
@export var speed: int = 500
@export var particleDestroyeScene: PackedScene


var direction

func _ready():
	pass

func _physics_process(delta):
	position += transform.x * speed * delta
	

# Visible Off when its out screen
func _on_visible_on_screen_enabler_2d_screen_exited():
	await get_tree().create_timer(2).timeout
	queue_free()

func destroy():
	var particle = particleDestroyeScene.instantiate()
	particle.global_position = self.global_position
	get_tree().root.add_child(particle)
	particle.emitting = true
	queue_free()

#in enterd in Wall itd
func _on_body_entered(body: Node2D) -> void:
	destroy()

# if enterd in Components like hurtBox
func _on_area_entered(area: Area2D) -> void:
	if area is HurtBoxComponent:
		area.takeDamage(damage, self)
		destroy()
