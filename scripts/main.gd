extends Node

@onready var level_2_area: Area2D = $areas/level2Area

# Level 2 preload Scene
const LEVEL_2 = preload("res://scenes/level_2.tscn")

@onready var fog: ColorRect = $fog

func _ready() -> void:
	get_tree().paused = true
	Global.laserEquipeGlobal = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Access to new Level 
func _on_level_2_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file('res://scenes/level_2.tscn')


# Script Scene Heli Landing Area
func _on_helicopter_landing_body_entered(body: Node2D) -> void:
	Global.helicopterLandingSignal.emit()
	
