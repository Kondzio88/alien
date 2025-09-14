extends StaticBody2D

@onready var sprite_2d: Sprite2D = $sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.scale = randomScale()

func randomScale():
	var  x = randf_range(0.15,0.3)
	return Vector2(x , x)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shadow_area_body_entered(body: Node2D) -> void:
	if body is Player:
		sprite_2d.modulate.a = 1


func _on_shadow_area_body_exited(body: Node2D) -> void:
	if body is Player:
		sprite_2d.modulate.a = 1
	
