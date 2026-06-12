extends Node2D

@onready var roof: Sprite2D = $roof
@onready var decorations: Node2D = $decorations

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	decorations.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_roof_area_hidding_body_entered(body: Node2D) -> void:
	if body is Player:
		var tween = create_tween()
		tween.tween_property(roof,'modulate:a',0.0,0.5)
		decorations.show()

func _on_roof_area_hidding_body_exited(body: Node2D) -> void:
	if body is Player:
		var tween = create_tween()
		tween.tween_property(roof,'modulate:a',1.0,0.5)
		decorations.hide()
		
