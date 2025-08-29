extends CharacterBody2D

const speed:int = 30
var direction: Vector2 = Vector2.ZERO

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	direction = Vector2(1,0)

func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider():
			direction = Vector2(changeDirection(),changeDirection())
		
	if position.x > 0 :
		rotation = global_position.angle_to(direction)
	if position.x < 0:
		rotation = global_position.angle_to(-direction)
	
	if direction:
		velocity = direction * speed
		animated_sprite_2d.play('run')
	else:
		velocity = direction * 0

	move_and_slide()

func changeDirection():
	return randi_range(-1,1)
