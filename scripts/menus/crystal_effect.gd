
extends Node2D

@onready var crystal_sprite: Sprite2D = $CrystalSprite

var original_position: Vector2
var original_scale: Vector2

func _ready() -> void:
	original_position = crystal_sprite.position
	original_scale = crystal_sprite.scale

	var tween = create_tween()
	tween.set_loops()

	# Cristal aumenta e sobe suavemente
	tween.tween_property(
		crystal_sprite,
		"scale",
		original_scale * 1.08,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(
		crystal_sprite,
		"position",
		original_position + Vector2(0, -6),
		1.2
	)

	# Cristal volta ao tamanho e posição originais
	tween.tween_property(
		crystal_sprite,
		"scale",
		original_scale,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.parallel().tween_property(
		crystal_sprite,
		"position",
		original_position,
		1.2
	)
