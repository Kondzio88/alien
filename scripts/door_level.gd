extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var point_light_2d: PointLight2D = $Sprite2D/PointLight2D
@onready var point_light_2d_2: PointLight2D = $Sprite2D2/PointLight2D2
@onready var point_light_2d_4: PointLight2D = $Sprite2D/PointLight2D4
@onready var point_light_2d_3: PointLight2D = $Sprite2D2/PointLight2D3

@onready var lights :Array = [point_light_2d,point_light_2d_2,point_light_2d_4,point_light_2d_3]
 

func _ready() -> void:
	Global.openLevelDoorSignal.connect(openLevelDoor)
	animation_player.play('close')

	for i in lights:
		var tween = create_tween().set_loops()
		tween.tween_property(i,'energy',1,1)
		tween.tween_property(i,'energy',0,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func openLevelDoor():
	animation_player.play('open')
	
