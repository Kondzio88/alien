extends Node2D

const DRONE = preload("res://scenes/drone.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.laserEquipeGlobal = true
	Global.droneEquipeGlobal = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
