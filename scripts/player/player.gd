extends CharacterBody2D

signal health_changed(current_health: int, max_health: int)

@export var speed: float = 120.0
@export var attack_offset_distance: float = 8.0

# Vida
@export var max_health: int = 100
var current_health: int

# Ataque
@export var attack_damage: int = 20
@export var attack_range: float = 45.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var last_direction: String = "down"
var is_attacking: bool = false
var is_shielding: bool = false

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

	anim.animation_finished.connect(_on_animation_finished)


func _physics_process(_delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Verifica se a tecla E está pressionada para defender
	if Input.is_physical_key_pressed(KEY_E):
		is_shielding = true
		velocity = Vector2.ZERO
		move_and_slide()
		anim.play("shield_" + last_direction)
		return
	else:
		is_shielding = false

	if Input.is_action_just_pressed("attack"):
		start_attack()
		return

	movement()


func movement() -> void:
	var direction := Vector2.ZERO

	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")

	direction = direction.normalized()
	velocity = direction * speed

	move_and_slide()
	update_animation(direction)


func update_animation(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		anim.play("idle_" + last_direction)
		return

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			last_direction = "right"
		else:
			last_direction = "left"
	else:
		if direction.y > 0:
			last_direction = "down"
		else:
			last_direction = "up"

	anim.play("run_" + last_direction)


func start_attack() -> void:
	is_attacking = true
	velocity = Vector2.ZERO

	match last_direction:
		"right":
			anim.offset = Vector2(attack_offset_distance, 0)
		"left":
			anim.offset = Vector2(-attack_offset_distance, 0)
		"down":
			anim.offset = Vector2(0, attack_offset_distance)
		"up":
			anim.offset = Vector2(0, -attack_offset_distance)

	anim.play("attack_" + last_direction)

	# Aplica o dano no momento do ataque
	apply_attack_damage()


func apply_attack_damage() -> void:
	var attack_direction := Vector2.ZERO

	match last_direction:
		"right":
			attack_direction = Vector2.RIGHT
		"left":
			attack_direction = Vector2.LEFT
		"down":
			attack_direction = Vector2.DOWN
		"up":
			attack_direction = Vector2.UP

	var enemies = get_tree().get_nodes_in_group("enemy")

	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue

		var distance = global_position.distance_to(enemy.global_position)

		if distance > attack_range:
			continue

		var direction_to_enemy = global_position.direction_to(enemy.global_position)

		# Só acerta inimigos que estão na direção do ataque
		if direction_to_enemy.dot(attack_direction) >= 0.3:
			if enemy.has_method("take_damage"):
				enemy.take_damage(attack_damage)


func _on_animation_finished() -> void:
	if anim.animation.begins_with("attack_"):
		is_attacking = false
		anim.offset = Vector2.ZERO


# Recebe dano
func take_damage(amount: int) -> void:
	current_health = maxi(0, current_health - amount)

	print("Dano recebido: ", amount)
	print("Vida do jogador: ", current_health)

	health_changed.emit(current_health, max_health)

	if current_health <= 0:
		die()


func die() -> void:
	print("O jogador morreu!")
	get_tree().reload_current_scene()
