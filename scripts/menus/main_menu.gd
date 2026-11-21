
extends Control

@onready var play_button: Button = $CenterContainer/MenuContainer_VBoxContainer/PlayButton
@onready var options_button: Button = $CenterContainer/MenuContainer_VBoxContainer/OptionsButton
@onready var quit_button: Button = $CenterContainer/MenuContainer_VBoxContainer/QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	setup_button_animation(play_button)
	setup_button_animation(options_button)
	setup_button_animation(quit_button)


func setup_button_animation(button: Button) -> void:
	button.pivot_offset = button.size / 2.0

	button.mouse_entered.connect(_on_button_hover.bind(button))
	button.mouse_exited.connect(_on_button_exit.bind(button))


func _on_button_hover(button: Button) -> void:
	animate_button(button, Vector2(1.05, 1.05))


func _on_button_exit(button: Button) -> void:
	animate_button(button, Vector2(1.0, 1.0))


func animate_button(button: Button, target_scale: Vector2) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", target_scale, 0.15)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/forest.tscn")


func _on_options_pressed() -> void:
	print("Menu de opções em desenvolvimento")


func _on_quit_pressed() -> void:
	get_tree().quit()
