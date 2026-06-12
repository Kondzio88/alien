@icon("uid://b8tkscvsgr7nk")

class_name HurtBoxComponent 
extends Area2D

signal tookDamage(amount:int, hitBox:Node2D)

func takeDamage(damage:int,hitBox:Node2D):
	tookDamage.emit(damage,hitBox)
