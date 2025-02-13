extends State
class_name State_Attack
@export var move_speed: float = 150.0
@onready var idle_state: State = $"../Idle"
@onready var walk_state: State = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_effect_animation_player: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var hurt_box: HurtBox = %HurtBox

var attacking: bool = false
func Enter() -> void:
	attack_effect_animation_player.play("attack_" + player.AnimateDirection())
	player.UpdateAnimation("attack")
	animation_player.animation_finished.connect(_on_animation_finished)
	attacking = true

	await get_tree().create_timer(0.1).timeout

	hurt_box.monitoring = true

func Exit() -> void:
	animation_player.animation_finished.disconnect(_on_animation_finished)
	attacking = false
	hurt_box.monitoring = false
func Process(_delta: float) -> State:
	player.velocity = player.velocity.move_toward(Vector2.ZERO, 1000 * _delta)
	if not attacking:
		if player.direction != Vector2.ZERO:
			return walk_state
		return idle_state
	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null

func _on_animation_finished(_anim_name: String) -> void:
	attacking = false
