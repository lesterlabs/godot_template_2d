class_name EnemyStateStun extends EnemyState

@export var anim_name: String = "stun"

@export var knock_back_speed: float = 125.0
@export var deceleration: float = 800.0

@onready var animation_player: AnimationPlayer = $"../../Sprite2D/AnimationPlayer"

@export_category("AI")
@export var next_state: EnemyState

var state_duration: float = 0.0

func init() -> void:
	enemy.enemy_damanged.connect(on_enemy_damaged)
	pass

func enter() -> void:
	enemy.velocity = enemy.player.cardinal_direction * knock_back_speed
	enemy.update_animation(anim_name)
	enemy.hurt_box.monitoring = false
	animation_player.animation_finished.connect(func(_anim_name: String) -> void:
		state_machine.change_state(next_state))

func exit() -> void:
	enemy.hurt_box.monitoring = true
	for connection in animation_player.animation_finished.get_connections():
		animation_player.animation_finished.disconnect(connection["callable"])

func process(_delta: float) -> EnemyState:
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, deceleration * _delta)
	return self

func physics_process(_delta: float) -> EnemyState:
	return self

func on_enemy_damaged() -> void:
	state_machine.change_state(self)
