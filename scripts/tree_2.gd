extends StaticBody2D

@onready var sprite2D: Sprite2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.droneEquipeGlobal = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shadow_area_body_entered(body: Node2D) -> void:
	if body is Player:
		sprite2D.modulate.a = 0.5


func _on_shadow_area_body_exited(body: Node2D) -> void:
	if body is Player:
		sprite2D.modulate.a = 1
