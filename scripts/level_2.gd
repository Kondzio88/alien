extends Node

const drone = preload("res://scenes/drone.tscn")
const rozerwany = preload("res://scenes/rozszarpany.tscn")
@onready var rozerwany_marker_position: Marker2D = $areas/scriptArea/rozerwanyMarkerPosition
var scriptBool: bool = false

@onready var end_level_light: PointLight2D = $light/endLevelLight

func _ready() -> void:
	Global.mission2Signal.emit()
	Global.globalIdCardEquipe = false
	Global.mission2Bool = true

	# Sets Dialog lvl2 bool on false
	Global.firstKillLevel2Dialog = false
	
	end_level_light.enabled = false

func _process(delta: float) -> void:
	pass

func _on_script_area_body_entered(body: Node2D) -> void:
	if body is Player && !scriptBool:
		end_level_light.enabled = true
		scriptBool = true
		Global.scriptSceneLvl2.emit()
		var deadSoldier = rozerwany.instantiate()
		deadSoldier.global_position = rozerwany_marker_position.global_position
		get_tree().current_scene.add_child(deadSoldier)


func _on_script_area_2_body_entered(body: Node2D) -> void:
	if body is Rozszarpany:
		Global.scriptSceneLvl2DeadSoldier.emit()
