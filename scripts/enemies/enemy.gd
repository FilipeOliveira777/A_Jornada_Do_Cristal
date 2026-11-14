
extends CharacterBody2D

@export var speed: float = 55.0
@export var max_health: int = 30

@export var contact_damage: int = 10
@export var contact_distance: float = 40.0
@export var damage_cooldown: float = 1.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea

var current_health: int
var player: Node2D = null
var cooldown_timer: float = 0.0


func _ready() -> void:
	anim.play("spider_idle")
	current_health = max_health

	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	cooldown_timer = maxf(0.0, cooldown_timer - delta)

	if not is_instance_valid(player):
		player = null
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var distance = global_position.distance_to(
		player.global_position
	)

	# Persegue até chegar à distância de ataque
	if distance > contact_distance:
		var direction = global_position.direction_to(
			player.global_position
		)

		velocity = direction * speed
	else:
		# Para de perseguir quando chega perto
		velocity = Vector2.ZERO

	move_and_slide()

	# Causa dano enquanto o jogador está próximo
	check_contact_damage()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		print("Jogador detectado!")


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		velocity = Vector2.ZERO


func check_contact_damage() -> void:
	if not is_instance_valid(player):
		return

	var distance = global_position.distance_to(
		player.global_position
	)

	if distance <= contact_distance and cooldown_timer <= 0.0:
		if player.has_method("take_damage"):
			player.take_damage(contact_damage)
			print("Aranha causou ", contact_damage, " de dano!")

			cooldown_timer = damage_cooldown


func take_damage(amount: int) -> void:
	current_health = maxi(0, current_health - amount)

	print("Vida da aranha: ", current_health)

	if current_health <= 0:
		die()


func die() -> void:
	queue_free()
