extends RayCast2D

@onready var laser: RayCast2D = $"."
@onready var line_2d: Line2D = $Line2D
@onready var player: Player = $".."

@onready var mousePos = get_local_mouse_position()
@onready var maxRange:int = 10000
@onready var maxCast :Vector2 = mousePos * maxRange
@onready var point_bullet: Marker2D = $"../pointBullet"
@onready var area_laser: Area2D = $areaLaser
@onready var laser_light: PointLight2D = $laserLight

func _ready() -> void:
	laser_light.texture.height = 2
	laser.add_exception(area_laser)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:

	if player.canMove:
		if player.aiming && player.laserActive:
			laser.target_position = Vector2.RIGHT * 10000
			
			
		if !player.aiming:
			laser.target_position = Vector2(20,0)
		if laser.is_colliding():
			var colision = laser.get_collision_point()
			line_2d.set_point_position(1,line_2d.to_local(colision))
			
			line_2d.set_point_position(0,line_2d.to_local(point_bullet.global_position))
			area_laser.position = line_2d.get_point_position(1)
			
			var pos1 = line_2d.get_point_position(0)
			var pos2 = line_2d.get_point_position(1)
			var posTotal = pos1.distance_to(pos2)
			laser_light.texture.width = posTotal 
			laser_light.position = pos2 / 1.9
			
		else:
			line_2d.set_point_position(1,laser.target_position)
			area_laser.position = line_2d.get_point_position(1)
	else:
		laser.hide()
