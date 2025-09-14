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
@onready var mainScene: Node = $".."
@onready var playerScene:PackedScene= preload("res://scenes/player.tscn")
@onready var player_ui: CanvasLayer = $"../playerUi"
@onready var fog: ColorRect = $"../fog"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Zoom Camera When fly
	camera_2d.zoom = Vector2(0.6,0.6)
	sprite_2d.scale = Vector2(4.0,4.0)
	
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
	
	# UI Player visible off
	if speed > 0:
		player_ui.visible = false
		
func landingFunc():
	# Fog visible and density
	fog.tween_density(0.5,5)
	
	# Kill Tween when Fly
	tweenPosY.kill()
	tweenScaleFly.kill()
	
	# Tween Landing Scale nad Sound
	speed = 0 
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(sprite_2d,"scale",Vector2(1.0,1.0),5)
	tween.parallel().tween_property(camera_2d,"zoom",Vector2(2.3,2.3),10)
	tween.tween_property(self,'wirnikSpeed',0,5)
	tween.parallel().tween_property(sound,'volume_db',-40.0,7)
	tween.finished.connect(spawnPlayer)
	
func spawnPlayer():
	var player = playerScene.instantiate()
	player.position = position + Vector2(0,-50)
	mainScene.add_child(player)
	
	# Camsera Heli off
	camera_2d.queue_free()
	
	# Player UI in Main Scene on
	player_ui.visible = true
	
