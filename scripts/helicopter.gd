extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sound: AudioStreamPlayer = $sound
@onready var camera_2d: Camera2D = $Camera2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var wirnik: Sprite2D = $Sprite2D/wirnik
@onready var red_light: PointLight2D = $Sprite2D/redLight

@onready var direction :Vector2 = Vector2.RIGHT
@onready var speed: int = 180
@onready var wirnikSpeed:int = 60

# Tween Heli when flying
@onready var tweenScaleFly:Tween
@onready var tweenPosY:Tween

# Player Scene spawn and fog density
@onready var spawnPlayerBool:bool = false
@onready var mainScene: Node = $".."
@onready var playerScene:PackedScene= preload("res://scenes/player.tscn")
@onready var player_ui: CanvasLayer = $"../playerUi"
@onready var fog: ColorRect = $"../fog"

# Dialog variables
@export_multiline var textToSay :String 
@export var speakerName :String = 'Pilot'
@export var timeSpeak :int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Zoom Camera When fly
	camera_2d.zoom = Vector2(0.6,0.6)
	sprite_2d.scale = Vector2(4.0,4.0)

	# Tween properties
	var tweenLight = get_tree().create_tween().set_loops()
	tweenLight.tween_property(red_light,'energy',0,1)
	tweenLight.tween_property(red_light,'energy',1,1)
	# Signal Script Scene Landing
	Global.helicopterLandingSignal.connect(landingFunc)
	
	# Kolysanie and Scale when Flying
	tweenPosY = get_tree().create_tween().set_loops()
	tweenPosY.tween_property(self,'position:y',position.y - 15, 1.5 ).set_trans(Tween.TRANS_SINE)
	tweenPosY.tween_property(self,'position:y',position.y + 15, 1.5).set_trans(Tween.TRANS_SINE)

	tweenScaleFly = get_tree().create_tween().set_loops()
	tweenScaleFly.tween_property(sprite_2d,'scale',Vector2(3.7,3.7),1.5).set_ease(Tween.EASE_IN_OUT)
	tweenScaleFly.tween_property(sprite_2d,'scale',Vector2(4.1,4.1),1).set_ease(Tween.EASE_IN_OUT)
	
func _process(delta: float) -> void:
	position += direction * speed * delta
	wirnik.rotation += wirnikSpeed * delta
	
	
func landingFunc():
	# Fog visible and density
	fog.tween_density(0.5,5)
	
	# Kill Tween when Fly
	tweenPosY.kill()
	tweenScaleFly.kill()
	
	# Tween Landing Scale nad Sound
	rotationLanding()
	speed -= 160 
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(sprite_2d,"scale",Vector2(1.0,1.0),5).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(camera_2d,"zoom",Vector2(2.3,2.3),8).set_trans(Tween.TRANS_SINE)
	speed = 0
	tween.tween_property(self,'wirnikSpeed',0,3)
	tween.parallel().tween_property(sound,'volume_db',-40.0,5)
	tween.finished.connect(spawnPlayer)
	
func spawnPlayer():
	if !spawnPlayerBool:
		spawnPlayerBool = true
		var player = playerScene.instantiate()
		player.position = position + Vector2(0,-50)
		mainScene.add_child(player)
	
	# Camsera Heli off
	camera_2d.enabled = false
	
	# Player UI in Main Scene on
	player_ui.visible = true
	
	# Helicopter Starts back
	await get_tree().create_timer(2.0).timeout
	startAfterLanding()
	
func rotationLanding():
	if speed > 0:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
		tween.tween_property(self,'rotation_degrees',7,1)
		tween.tween_property(self,'rotation_degrees',-7,1)
		tween.tween_property(self,'rotation_degrees',5,1)
		tween.tween_property(self,'rotation_degrees',-5,1)
		tween.tween_property(self,'rotation_degrees',0,1)

func startAfterLanding():
	textToSay = 'Dobra ja juz spierdalam z tego zadupia , powodzenia !!!'
	Dialogs.trigger_dialog.emit(textToSay,speakerName,timeSpeak)
	
	var tween:Tween = create_tween()
	tween.tween_property(self, 'wirnikSpeed', 60, 3.0)
	tween.parallel().tween_property(sound, 'volume_db', 0.0, 3.0)
	tween.tween_property(self,'rotation_degrees',-5, 0.5)
	tween.tween_property(self,'rotation_degrees',5, 0.5)
	tween.tween_property(self,'rotation_degrees',-7, 0.5)
	tween.tween_property(self,'rotation_degrees',7, 0.5)
	tween.tween_property(self,'rotation_degrees', 0, 0.5)
	tween.tween_property(sprite_2d, "scale", Vector2(4.0, 4.0), 3.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite_2d, "rotation_degrees", -45, 3.0).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	direction = Vector2.LEFT
	speed = 180
	var tweenSound:Tween = create_tween()
	tweenSound.tween_property(sound,'volume_db',-40,25)
	await get_tree().create_timer(10.0).timeout
	queue_free()
	
func _on_timer_timeout() -> void:
		# Dialog signal emit
	Dialogs.trigger_dialog.emit(textToSay,speakerName,timeSpeak)
