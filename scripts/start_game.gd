extends Control

@onready var label: Label = $Label
@onready var arrayLabel: Array = [start_game,controls,quit]
@onready var start_game: Label = $VBoxContainer/startGame
@onready var controls: Label = $VBoxContainer/controls
@onready var quit: Label = $VBoxContainer/quit
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var tween:Tween = get_tree().create_tween().parallel()

@onready var main_sound: AudioStreamPlayer = $mainSound
@onready var controls_panel: PanelContainer = $controlsPanel
@onready var start_sound: AudioStreamPlayer2D = $VBoxContainer/startGame/Button/startSound
@onready var choise_sound: AudioStreamPlayer2D = $VBoxContainer/controls/Button2/choiseSound

@onready var timer_buttons: Timer = $timerButtons

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_buttons.start()
	tween.tween_property(label,'modulate:a',0,4)
	tween.tween_property(label,'modulate:a',0.5,4)
	tween.tween_property(label,'modulate:a',1,3)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	main_sound.play()
	
func _on_button_2_pressed() -> void:
	choise_sound.play()
	controls_panel.show()
	v_box_container.hide()
	
func _on_back_button_pressed() -> void:
	choise_sound.play()
	controls_panel.hide()
	v_box_container.show()

func _on_button_3_pressed() -> void:
	get_tree().quit()

func _on_button_pressed() -> void:
	start_sound.play()
	
func _on_start_sound_finished() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	

func _on_timer_buttons_timeout() -> void:
	v_box_container.show()
	var tween2:Tween = create_tween().parallel()
	tween2.tween_property(start_game,'modulate:a',0,1)
	tween2.tween_property(start_game,'modulate:a',1,1)
	tween2.tween_property(controls,'modulate:a',1,1)
	tween2.tween_property(quit,'modulate:a',1,1)
