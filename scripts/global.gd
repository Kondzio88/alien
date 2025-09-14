extends Node

# Door and Stage Signal
signal openLabDoor
signal openLevelDoorSignal

# Equipe Signal
signal laserSignal
signal idCardSignal
signal droneSignal
signal magazineSignal

# Ui Signal
signal tipOnSignal
signal tipOffSignal
signal mission2Signal

# Dialogs Signal
signal dialog1
signal firstKillDialogSignal
signal dialog3
signal dialog4
signal firstKillLevel2DialogSignal

var firstKillDialog:bool = false
var firstKillLevel2Dialog:bool = true # Levle2 Setts bool on false

# Script Scenes Signals
signal scriptSceneLvl2
signal scriptSceneLvl2DeadSoldier
signal helicopterLandingSignal

# Player and Global Ui display
var globalArmorPrecent:String
var globalBullets:String
var playerPosition:CharacterBody2D
var playerHealthUi:int
var playerMaxHealthUi:int
var globalBattery:int
var globalStrength:int
var globalGrenadeMagazine:String

# Player Ui Bool
var globalArmor:bool = false
var globalIdCardEquipe:bool = false
var droneEquipeGlobal:bool = false
var laserEquipeGlobal:bool = false
var magazineEquipe:bool = false
var mission2Bool:bool = false
