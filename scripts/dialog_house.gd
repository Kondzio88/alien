extends Area2D


@export_multiline var text_to_say: String = "Oooo jest jakis budynek ... Wyglada na pusty . Wejde sprawdzic"
@export var speaker: String = "Ghost"

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		# Odpalamy globalny sygnał i podajemy mu argumenty
		Dialogs.trigger_dialog.emit(text_to_say, speaker)
		
		# Żeby dialog nie odpalał się w kółko:
		queue_free()
