extends Node2D

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.openLabDoor.connect(openDoor)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func openDoor():
	animation_player.play('open')
