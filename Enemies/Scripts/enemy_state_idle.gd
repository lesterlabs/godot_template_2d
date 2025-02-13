class_name EnemyStateIdle extends EnemyState

@export var anim_name: String = "idle"

@export_category("AI")
@export var state_duration_min: float = 0.5
@export var state_duration_max: float = 1.5
@export var after_idle_state: EnemyState
var state_duration: float = 0.0

var _timer: float = 0.0

func init() -> void:
	pass

func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(anim_name)
	enemy.hurt_box.monitoring = true  # Enable hurt box in idle state

func exit() -> void:
	pass


func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0.0:
		return after_idle_state
	return self

func physics_process(_delta: float) -> EnemyState:
	return self
