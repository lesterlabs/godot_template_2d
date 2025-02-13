class_name EnemyStateWander extends EnemyState

@export var anim_name: String = "walk"

@export_category("AI")
@export var state_animation_duration: float = 0.5
@export var state_cycles_max: int = 3
@export var state_cycles_min: int = 1
@export var next_state: EnemyState
@export var walk_speed: float = 20.0

var state_duration: float = 0.0
var _timer: float = 0.0
var _direction: Vector2 = Vector2.DOWN

func init() -> void:
	pass

func enter() -> void:
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = Vector2.DOWN if rand == 0 else Vector2.UP if rand == 1 else Vector2.LEFT if rand == 2 else Vector2.RIGHT
	enemy.velocity = _direction * walk_speed
	enemy.set_direction(_direction)
	enemy.update_animation(anim_name)
	enemy.hurt_box.monitoring = true  # Enable hurt box in wander state

func exit() -> void:
	pass


func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0.0:
		return next_state
	return self

func physics_process(_delta: float) -> EnemyState:
	return self
