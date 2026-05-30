extends CanvasLayer

@onready var label: Label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var label2: Label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/Label

@onready var info_panel: PanelContainer = $infoPanel
@onready var title_label: Label = $infoPanel/HBoxContainer/titleLabel
@onready var kind_label: Label = $infoPanel/HBoxContainer/VBoxContainer/kindLabel
@onready var text_label: Label = $infoPanel/HBoxContainer/VBoxContainer/textLabel


@onready var tip_panel: PanelContainer = $tipPanel

# Dialog Ui and Dictionary with Image characters
@onready var dialog_panel: PanelContainer = $dialogPanel
@onready var dialog_label: Label = $dialogPanel/VBoxContainer/MarginContainer/dialogLabel
@onready var dialog_image: TextureRect = $dialogPanel/VBoxContainer/VBoxContainer/dialogImage
@onready var dialog_name_label: Label = $dialogPanel/VBoxContainer/VBoxContainer/dialogNameLabel


@onready var  portraits = {
	'pilot':{
		'image' : preload("res://assets/asepriteMoj/pilotFace.jpg"),
		'displayName': 'Pilot'
	},
	'player':{
		'image' : preload("res://assets/asepriteMoj/playerFace.jpg"),
		'displayName': 'Ghost'
	} 
}

@onready var droneDialog:bool = false
@onready var mision_panel: PanelContainer = $misionPanel

# Sound Variables
@onready var laser_audio: AudioStreamPlayer = $laserAudio
@onready var whats_that_audio: AudioStreamPlayer = $whatsThatAudio
@onready var drone_audio: AudioStreamPlayer = $droneAudio

# Armor Variables
@onready var armor_sprite: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer3/armorSprite
@onready var armor_container: VBoxContainer = $PanelContainer/MarginContainer/HBoxContainer/armorContainer
@onready var armor_precent: Label = $PanelContainer/MarginContainer/HBoxContainer/armorContainer/armorPrecent

# Misiion Variables
@onready var opis_label: Label = $misionPanel/MarginContainer/VBoxContainer/opisLabel
@onready var data_label: Label = $misionPanel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/dataLabel
@onready var localisation_label: Label = $misionPanel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/localisationLabel

# Item sprite Variables
@onready var drone_sprite: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/panelEquipment/equipmentHBox/droneSprite
@onready var laser_sprite: TextureRect = $PanelContainer/MarginContainer/HBoxContainer/panelEquipment/equipmentHBox/laserSprite

# Pause Settings
@onready var pause_panel: PanelContainer = $PanelContainer/pausePanel
@onready var controls_panel: PanelContainer = $PanelContainer/pausePanel/controlsPanel
@onready var back_button: Button = $PanelContainer/pausePanel/controlsPanel/MarginContainer/backButton
@onready var v_box_container: VBoxContainer = $PanelContainer/pausePanel/VBoxContainer

func _ready():
	Global.laserSignal.connect(laserText)
	Global.idCardSignal.connect(idCardText)
	Global.tipOnSignal.connect(tipOn)
	Global.tipOffSignal.connect(tipOff)
	Global.droneSignal.connect(droneText)
	Global.mission2Signal.connect(mission2Text)
	Global.magazineSignal.connect(magazineText)
	
	
func _process(delta):
	
	if Input.is_action_just_pressed("continue"):
		mision_panel.hide()
		info_panel.hide()
		pause_panel.hide()
		get_tree().paused = false
		
	label.text = Global.globalBullets
	label2.text = Global.globalGrenadeMagazine
	
	if Input.is_action_just_pressed('pause'):
		get_tree().paused = true
		pause_panel.show()
		# Icon show and hide 
	if Global.globalArmor:
		armor_container.show()
		armor_precent.text = Global.globalArmorPrecent
		
	if !Global.globalArmor:
		armor_container.hide()
		
	if Global.droneEquipeGlobal:
		drone_sprite.visible = true
			
	if Global.laserEquipeGlobal:
		laser_sprite.visible = true
		
func laserText():
	
	info_panel.visible = true
	title_label.text = 'LASER WEYLAND LX 229'
	kind_label.text = 'DODATEK DO BRONI:'
	text_label.text = 'Laser taktyczny klasy wojskowej do broni to zaawansowane narzedzie przeznaczone do zwiekszenia efektywnosci bojowej w ekstremalnych warunkach. Wyposazony w wiazke swiatla podczerwonego, laser ten umozliwia precyzyjne celowanie i poszerza kat widzenia podczas namierzania szybko poruszajacych sie celow. Dzieki wytrzymalej konstrukcji jest odporny na ekstremalne temperatury i uszkodzenia mechaniczne. kat widzenia + 10% ,podwietla cele na czerwono'
	get_tree().paused = true
	laser_audio.play()

func idCardText():
	info_panel.visible = true
	if Global.mission2Bool:
		title_label.text = 'Id card nr 34'
		kind_label.text = 'doctor jane smith'
		text_label.text = 'Karta dostepu poziomu 3 nalezaca do doktora Jane Smith. Autoryzacja Weyland Yutani Corp Nr #2098. Karta z kodami dostepu na poziom 3, wyposazona w zaawansowane zabezpieczenia biometryczne, kod QR i chip NFC. Solidna konstrukcja karty zapewnia odpornosc na uszkodzenia mechaniczne i zaklocenia elektromagnetyczne. Dzieki niej, dr Smith moze bezpiecznie i szybko uzyskiwac dostep do najbardziej strzezonych obszarow laboratorium. Karta umozliwia dostep do zaawansowanych technologicznie stanowisk badawczych i chronionych danych projektowych, gwarantujac najwyzszy poziom bezpieczenstwa.'
	if !Global.mission2Bool:
		title_label.text = 'ID CARD NR 19'
		kind_label.text = 'DOCTOR MALONE:'
		text_label.text = 'Karta dostepu poziomu 2 nalezaca do doktora Marka Maloona. Autoryzacja Weyland Yutani Corp Nr #1024. Karta z kodami dostepu na poziom 2 , wyposazona w zaawansowane zabezpieczenia biometryczne i kod QR. Solidna konstrukcja karty zapewnia odpornosc na uszkodzenia mechaniczne i zaklocenia elektromagnetyczne. Dzieki niej, dr Maloon moze bezpiecznie i szybko uzyskiwac dostep do kluczowych obszarow osrodka badawczego.'
	get_tree().paused = true
	whats_that_audio.play()
	
func tipOn():
	tip_panel.visible = true

func tipOff():
	tip_panel.visible = false
	
func droneText():
	info_panel.visible = true
	title_label.text = 'DRONE SENTINEL 7A'
	kind_label.text = 'WSPARCIE:'
	text_label.text = 'Dron bojowy klasy Sentinel, model 7A, produkcji Weyland Yutani Corp. Numer seryjny #DX-5789. Dron wyposazony w zaawansowany system sledzenia celu, mozliwosc orbitowania wokol operatora oraz wbudowana sztuczna inteligencje taktyczna. Solidna konstrukcja z materialow odpornych na uszkodzenia mechaniczne i zaklocenia elektromagnetyczne. Po przyszlej aktualizacji mozliwe bedzie uzbrojenie go w plazmowe dzialka oraz zaawansowane tarcze obronne. Obecnie dron pelni funkcje wsparcia, zwiekszajac swiadomosc sytuacyjna operatora i gotowosc bojowa w kazdych warunkach.'
	get_tree().paused = true
	drone_audio.play()
	
func mission2Text():
	mision_panel.show()
	localisation_label.text = 'laboratorium lvl 2'
	opis_label.text = 'Po zdobyciu karty dostepu poziomu 3 nalezacej do doktora Marka Maloona,uzyskalismy dostep do laboratorium poziomu 2.Wchodzac do obszaru,zauwazylismy znaczne ilosci krwi na podlodze i scianach,lecz brakowalo zwlok.Sceneria wskazuje na intensywna walke lub nagly atak,jednakze ciala ofiar zniknely. Wtrakcie eksploracji laboratorium,natknelismy sie na oddzial marines.Doszlo do wymiany ognia,wwyniku ktorej wyeliminowano wszystkich przeciwnikow,wlaczajac doktora Maloona.Oddzial marines zostal calkowicie zneutralizowany.Nie zidentyfikowano zadnych dodatkowych zagrozen podczas starcia. Po wejscu do laboratorium nastapila nagla utrata zasilania.Sytuacja ta wskazuje na mozliwe sabotaz lub awarie systemu energetycznego.Kontynuujemy dochodzenie w tej sprawie. Z informacji zawartych na karcie doktora Maloona wynika,ze oddzial marines operujacy w osrodku jest znacznie liczniejszy niz wczesniej zakladano.Polecam kontynuacje dochodzenia w celu ustalenia lokalizacji pozostalych czlonkow ekipy osrodka oraz przyczyn ich znikniecia. Zadania: -Przeprowadzenie szczegolowego przeszukania poziomu 2 laboratorium. -Zabezpieczenie zrodel zasilania i przywrocenie energii w osrodku. -Identyfikacja przyczyn obecnosci krwi przy jednoczesnym braku zwlok. -Kontynuowanie dochodzenia w celu zlokalizowania pozostalych czlonkow personelu i wyjasnienia ich losu'
	get_tree().paused = true

func magazineText():
	info_panel.show()
	title_label.text = 'Magazynek XM-25'
	kind_label.text = 'Dodatek do broni: '
	text_label.text = 'Powiekszony magazynek do broni, produkcji Armatech Industries, model XM-25, numer seryjny #MAG-1024. Wykonany z lekkiego stopu tytanu, zapewnia trwalosc i odpornosc na uszkodzenia mechaniczne. Wyposazony w nowoczesny system sprezynowy, ktory zwieksza szybkosci ladowania i niezawodnosc. Planowana przyszla aktualizacja doda wskaznik poziomu amunicji oraz technologie antyzakleszczeniowa. Obecnie magazynek poprawia wydajnosc i gotowosc bojowa w kazdych warunkach, zwiekszajac liczbe nabojow o 10, co daje lacznie 25 nabojow.'
	get_tree().paused = true
	laser_audio.play()
	
# PAUSE SETTINGS --------------------
func _on_quit_button_pause_pressed() -> void:
	get_tree().quit()

func _on_controls_button_pressed() -> void:
	controls_panel.show()
	v_box_container.hide()

func _on_back_button_pressed() -> void:
	controls_panel.hide()
	v_box_container.show()
	
func _on_continue_buttons_pressed() -> void:
	pause_panel.hide()
	get_tree().paused = false
