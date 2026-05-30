extends StaticBody2D

@onready var bullet:PackedScene = preload("res://scenes/bullet.tscn")
@onready var luska :PackedScene= preload("res://scenes/particle/luska.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	shot(delta)
	
func shot(delta):
	get_tree().create_timer(2).timeout
	var projectile = bullet.instantiate() 
	get_tree().root.add_child(projectile)
	projectile.global_position = self.global_position
	projectile.global_rotation = self.global_rotation
	var launchDirection = Vector2(0,1).rotated(self.global_rotation)
	projectile.launch(launchDirection)
