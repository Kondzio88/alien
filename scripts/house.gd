extends Node2D
@onready var detected_body: Area2D = $detectedBody
@onready var roof: Sprite2D = $roof


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_detected_body_body_entered(body: Node2D) -> void:
	if body is Player:
		var tween = create_tween()
		tween.tween_property(roof,'modulate:a',0.0,0.5)


func _on_detected_body_body_exited(body: Node2D) -> void:
	if body is Player:
		var tween = create_tween()
		tween.tween_property(roof,'modulate:a',1.0,0.5)
