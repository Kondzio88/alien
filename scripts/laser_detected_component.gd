@icon("uid://bfnt2borwsyks")
class_name LaserDetectedComponent extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
func _on_area_entered(area: Area2D) -> void:
	if area is AreaLaser:
		var parent = get_parent()
		parent.modulate = Color(1.278, 0.0, 0.0)
		print(parent)
		print('detected')
		
func _on_area_exited(area:Area2D) -> void:
	var parent = get_parent()
	parent.modulate = Color(1.0, 1.0, 1.0)
