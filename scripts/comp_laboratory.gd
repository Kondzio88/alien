extends StaticBody2D

@onready var point_light_2d = $PointLight2D
@onready var audio_turn_on = $audioTurnOn
@onready var point_light_2d_2 = $PointLight2D2
@onready var keyboar_typin_audio: AudioStreamPlayer2D = $keyboarTypinAudio

var open :bool = false
var tween:Tween
var player:CharacterBody2D

func _ready():
	tween = get_tree().create_tween().set_loops()
	tween.tween_property(point_light_2d,'energy',2,1)
	tween.tween_property(point_light_2d,'energy',0,1)

func _process(delta):
	if player && Input.is_action_just_pressed('action') && !open:
		keyboar_typin_audio.play()
		
	if open:
		point_light_2d.enabled = false
		point_light_2d_2.enabled = true
		tween.stop()
		
func _on_turn_on_area_body_entered(body):
	if body is Player && !open:
		player = body
		Global.tipOnSignal.emit()
		
func _on_turn_on_area_body_exited(body):
		Global.tipOffSignal.emit()
		player = null
		
func _on_keyboar_typin_audio_finished() -> void:
	open = true
	audio_turn_on.play()
	Global.openLabDoor.emit()
	Global.tipOffSignal.emit()
