extends Node

@onready var level_2_area: Area2D = $areas/level2Area

# Dialog booleans
@onready var dialog1:bool = false
@onready var dialog2:bool = false
@onready var dialog3:bool = false
@onready var dialog4:bool = false

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

# Dialog Areas
func _on_dialog_area_body_entered(body: Node2D) -> void:
	if !dialog1 && body is Player:
		Global.dialog1.emit()
		dialog1 = true

func _on_dialog_area_2_body_entered(body: Node2D) -> void:
	if !dialog2 && body is Player:
		Global.dialog2.emit()
		dialog2 = true

func _on_dialog_area_3_body_entered(body: Node2D) -> void:
	if !dialog3 && body is Player:
		Global.dialog3.emit()
		dialog3 = true
		
func _on_dialog_area_4_body_entered(body: Node2D) -> void:
	if !dialog4 && body is Player:
		Global.dialog4.emit()
		dialog4 = true
		
# Script Scene Heli Landing Area
func _on_helicopter_landing_body_entered(body: Node2D) -> void:
	Global.helicopterLandingSignal.emit()
