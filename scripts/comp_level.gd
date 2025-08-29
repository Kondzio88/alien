extends StaticBody2D

@onready var keyboard_typing: AudioStreamPlayer2D = $keyboardTyping
@onready var password_please_audio: AudioStreamPlayer2D = $passwordPleaseAudio
@onready var password_inccorect: AudioStreamPlayer2D = $passwordInccorect
@onready var password_correct: AudioStreamPlayer2D = $passwordCorrect
@onready var green_light: PointLight2D = $greenLight
@onready var red_light: PointLight2D = $redLight

@onready var player :CharacterBody2D = null
var open:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	green_light.enabled = false
	pass # Replace with function b
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.globalIdCardEquipe && Input.is_action_just_pressed("action") && !open && player:
		keyboard_typing.play()
		open = true
		keyboard_typing.finished.connect(finishTyping)
		
	if !Global.globalIdCardEquipe && Input.is_action_just_pressed("action") && !open && player:
		password_inccorect.play()
		
func _on_turn_on_area_body_entered(body: Node2D) -> void:
	if body is Player && !open:
		player = body
		Global.tipOnSignal.emit()
		password_please_audio.play()
		
func _on_turn_on_area_body_exited(body: Node2D) -> void:
	player = null
	Global.tipOffSignal.emit()

func finishTyping():
	Global.openLevelDoorSignal.emit()
	password_correct.play()
	green_light.enabled = true
	red_light.enabled = false
