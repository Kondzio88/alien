@icon("uid://dt0y2cmyfhtso")

class_name FireLightComponent
extends Node2D

@onready var fire_light: PointLight2D = $fireLight
@onready var fire_light_2: PointLight2D = $fireLight2
@onready var fire_light_3: PointLight2D = $fireLight3

func _ready() -> void:
	setLightsEnabled(false)
	
func flash():
	setLightsEnabled(true)
	await get_tree().create_timer(0.05).timeout
	setLightsEnabled(false)

func setLightsEnabled(state:bool):
	fire_light.enabled = state
	fire_light_2.enabled = state
	fire_light_3.enabled = state
