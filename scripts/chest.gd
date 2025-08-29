extends RigidBody2D

class_name Chest

var pushForce:int = 30
@onready var pushDir:Vector2

func _process(delta: float) -> void:
		
	linear_velocity = Vector2.ZERO

func test(pushDirection):
	pushDir = pushDirection
	linear_velocity = pushDir * pushForce
