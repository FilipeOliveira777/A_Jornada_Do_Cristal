
extends CanvasLayer

@onready var crystal_label: Label = $CrystalLabel
@onready var health_label: Label = $HealthLabel

var player: CharacterBody2D = null


func _ready() -> void:
    GameManager.crystals_updated.connect(update_crystals)

    update_crystals(
        GameManager.crystals_collected,
        GameManager.total_crystals
    )

    player = get_tree().get_first_node_in_group("player")

    if player:
        update_health()


func _process(_delta: float) -> void:
    if is_instance_valid(player):
        update_health()


func update_health() -> void:
    health_label.text = "Vida: %d / %d" % [
        player.current_health,
        player.max_health
    ]


func update_crystals(collected: int, total: int) -> void:
    crystal_label.text = "Cristais: %d / %d" % [
        collected,
        total
    ]
