extends Node2D

@onready var scena_ptak := preload("res://ptak.tscn")
@onready var spawnpoint := $Spawnpoint

var przycisk_wciśnięty := false
var wektor_strzału: Vector2

var ptak: RigidBody2D

func _ready() -> void:
	załaduj()

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
			var pozycja_myszy: Vector2 = spawnpoint.get_local_mouse_position()
			var kierunek_do_myszy := pozycja_myszy.normalized()
			var odległość_do_myszy := clampf(pozycja_myszy.length(), 0.0, 100.0)
			wektor_strzału = kierunek_do_myszy * odległość_do_myszy
			ptak.position = wektor_strzału
		else:
			ptak.position = Vector2.ZERO


func załaduj():
	ptak = scena_ptak.instantiate()
	spawnpoint.add_child(ptak)
	ptak.freeze = true

func wystrzel_pocisk(kierunek: Vector2, siła: float):
	ptak.freeze = false
	ptak.apply_central_impulse(kierunek * siła * 20.0)
	ptak = null
	await get_tree().create_timer(0.25).timeout
	załaduj()
