extends Sprite2D

var radius: float = 50.0
var angular_speed:float = 2.0
var angle:float = 0.0
@onready var player: Player = $"../player"
@onready var blue_light: PointLight2D = $blueLight
@onready var timer_audio: Timer = $"timer Audio"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var redTween:Tween = get_tree().create_tween().set_loops()
	redTween.tween_property(blue_light,'energy',10,0.5)
	redTween.tween_property(blue_light,'energy',8,1.5)
	redTween.tween_property(blue_light,'energy',0,1)
	redTween.tween_property(blue_light,'energy',0,2)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	
	angle += delta * angular_speed
	var offset = Vector2(cos(angle) * radius, sin(angle) * radius)
	position = player.global_position + offset
	var angleVec = global_position.angle_to_point(mouse_position)
	rotation = angleVec
	
