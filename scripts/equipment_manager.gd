@icon("uid://dfyn0phg2nuus")
extends Node2D
class_name EquipmentManager

# Signals for Player
signal throwableChanged(itemName:String)
signal specialToggled(itamName:String, isActive:bool)
signal specialUnlocked(itemName:String, slotIndex:int) # info for Ui where add Icon

# Left side Ui Equipment
var currentThrowable:String = 'grenade'
var flaresCount:int = 3

# Right side for Special Equipment 
var specialsArray: Array[String] = []
var activeSpecials: Dictionary = {}

func _input(event: InputEvent) -> void:
	# Switch throwable item
	if event.is_action_pressed('slot1'):
		equipThrowable('grenade')
	elif event.is_action_pressed('slot2'):
		equipThrowable('flare')
	
	# Switch Special Equipment
	if event.is_action_pressed('slot4') and specialsArray.size() >=1:
		toggleSpecial(specialsArray[0])
	if event.is_action_pressed('slot5') and specialsArray.size() >=2:
		toggleSpecial(specialsArray[1])
		
# Add to array special items
func unlockItem(itemName:String):
	if not specialsArray.has(itemName):
		specialsArray.append(itemName)
		activeSpecials[itemName] = false
		# Signal for Ui to change Icon
		specialUnlocked.emit(itemName,specialsArray.size() +3)
		print(specialsArray)
		
func equipThrowable(item:String):
	currentThrowable = item
	throwableChanged.emit(item)
	
func toggleSpecial(item: String):
	activeSpecials[item] = !activeSpecials[item] # add bool true
	specialToggled.emit(item, activeSpecials[item])
