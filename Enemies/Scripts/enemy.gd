class_name Enemy
extends CharacterBody2D

signal direction_changed(direction: Vector2)

signal enemy_damanged()

var hp: int = 20

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var shadow: Sprite2D = $ShadowSprite2D
@onready var state_machine: EnemyStateMachine = $enemy_state_machine
@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize(self)
	player = GlobalPlayerManager.player
	hit_box.Damaged.connect(take_damage)
	hurt_box.monitoring = false  # Start with hurt box disabled
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
	cardinal_direction = new_direction.normalized()

	direction_changed.emit(cardinal_direction)
	sprite.scale.x = -1 if cardinal_direction.x < 0 else 1
	


func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player = body
		
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
func take_damage(hurt_box: HurtBox) -> void:
	hp -= int(hurt_box.damage)
	enemy_damanged.emit()
	if hp <= 0:
		die()

func die() -> void:
	queue_free()
