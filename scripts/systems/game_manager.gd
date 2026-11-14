
extends Node

signal crystals_updated(collected: int, total: int)

var crystals_collected: int = 0
var total_crystals: int = 0


func reset_crystals() -> void:
	crystals_collected = 0
	total_crystals = 0
	crystals_updated.emit(0, 0)


func register_crystal() -> void:
	total_crystals += 1
	crystals_updated.emit(crystals_collected, total_crystals)


func collect_crystal(amount: int = 1) -> void:
	crystals_collected += amount
	crystals_updated.emit(crystals_collected, total_crystals)
