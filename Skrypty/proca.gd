extends Node2D

@export var maksymalna_siła: float = 100.0

var przycisk_wciśnięty := false
var ptak: RigidBody2D

func _input(event: InputEvent) -> void:
	var czy_przycisk_był_wciśnięty := przycisk_wciśnięty
	if event is InputEventMouseButton:
		przycisk_wciśnięty = event.pressed
	
	if not przycisk_wciśnięty and czy_przycisk_był_wciśnięty:
		var kierunek := -ptak.position.normalized()
		var siła := ptak.position.length()
		if siła > 10.0:
			wystrzel_pocisk(kierunek, siła)
	
	if ptak:
		if przycisk_wciśnięty:
			var pozycja_myszy: Vector2 # Do dokończenia - pozycja myszy
			var kierunek_do_myszy := pozycja_myszy.normalized()
			var wektor_strzału = clampf(pozycja_myszy.length(), 0.0, maksymalna_siła) * kierunek_do_myszy
			ptak.position = wektor_strzału
		else:
			ptak.position = Vector2.ZERO


func załaduj():
	pass # Miejsce na kod

func wystrzel_pocisk(kierunek: Vector2, siła: float):
	pass # Miejsce na kod
