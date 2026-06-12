extends CanvasLayer
@onready var dialog_layer: CanvasLayer = $"."

var portraits = {
	"Ghost": preload("res://assets/asepriteMoj/playerFace.jpg"),
	"Pilot": preload("res://assets/asepriteMoj/pilotFace.jpg")
}
@onready var dialog_name_label: Label = $PanelContainer/dialogPanel/VBoxContainer/VBoxContainer/dialogNameLabel
@onready var dialog_image: TextureRect = $PanelContainer/dialogPanel/VBoxContainer/VBoxContainer/dialogImage
@onready var dialog_label: Label = $PanelContainer/dialogPanel/VBoxContainer/MarginContainer/dialogLabel
@onready var dialog_panel: PanelContainer = $PanelContainer/dialogPanel

func _ready() -> void:
	# Podpinamy globalny sygnał do naszej lokalnej funkcji display_dialog
	Dialogs.trigger_dialog.connect(display_dialog)

# Zauważ, że funkcja musi przyjmować dokładnie te same argumenty, co sygnał!
func display_dialog(text: String = '', speaker_name: String = '' ,timeSpeak:int = 5) -> void:
	# Visible Layer on topbeacuse Player Ui is Layer 5 
	dialog_layer.layer = 10
	
	dialog_name_label.text = speaker_name
	dialog_panel.show()
	dialog_label.text = text
	dialog_label.visible_ratio = 0.0
	dialog_image.texture = portraits[speaker_name]
	dialog_image.show()
	
	# Writing delay Tween
	var writeTime = text.length() * 0.05
	var tween:Tween = create_tween()
	tween.tween_property(dialog_label,'visible_ratio',1.0,writeTime)
	await tween.finished
	await get_tree().create_timer(timeSpeak).timeout
	dialog_panel.hide()
	# Hide layer under Player Ui
	dialog_layer.layer = 0
