extends Area2D

@export var value: int = 1

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var is_collected: bool = false

func _ready() -> void:
	anim.play("idle_crystal")
	GameManager.register_crystal()
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if is_collected or not body.is_in_group("player"):
		return
		
	is_collected = true
	GameManager.collect_crystal(value)
	
	set_deferred("monitoring", false)
	
	queue_free()
