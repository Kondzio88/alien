extends Node2D

@onready var point_light_2d: PointLight2D = $Sprite2D/PointLight2D
@onready var point_light_2d_2: PointLight2D = $Sprite2D2/PointLight2D2
@onready var point_light_2d_4: PointLight2D = $Sprite2D/PointLight2D4
@onready var point_light_2d_3: PointLight2D = $Sprite2D2/PointLight2D3

@onready var lights :Array = [point_light_2d,point_light_2d_2,point_light_2d_4,point_light_2d_3]

@onready var animation_player = $AnimationPlayer
var bodyOpen:CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in lights:
		
		var tween = create_tween().set_loops()
		tween.tween_property(i,'energy',1,1)
		tween.tween_property(i,'energy',0,1)
		
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_range_body_entered(body):
	if body is CharacterBody2D:
		bodyOpen = body
		if animation_player.name != 'open' && bodyOpen != null:
			animation_player.play("open")


func _on_range_body_exited(body):
	bodyOpen = null
	if body is CharacterBody2D and bodyOpen == null:
		if animation_player.name != 'close' && bodyOpen == null:
			animation_player.play("close")
		
