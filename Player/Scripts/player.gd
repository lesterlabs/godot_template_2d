# GODOT 4.3.0
class_name Player extends CharacterBody2D
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var last_pressed_direction: Vector2 = Vector2.ZERO

var hp: int = 100  # Player starts with 100 HP
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var attack_effect_sprite: Sprite2D = $Sprite2D/AttackEffectSprite
@onready var hit_box: HitBox = $HitBox
signal DirectionChanged(direction: Vector2)
signal player_damaged(current_hp: int)  # New signal for when player takes damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	GlobalPlayerManager.player = self
	hit_box.Damaged.connect(take_damage)
	pass # Replace with function body.

func take_damage(hurt_box: HurtBox) -> void:
	print("Player took ", hurt_box.damage, " damage! HP: ", hp)  # Log the damage
	hp -= int(hurt_box.damage)
	player_damaged.emit()
	
	if hp <= 0:
		die()

func die() -> void:
	queue_free()  # You might want to handle death differently

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
	# Only track the first pressed direction when no direction is currently pressed
	if velocity == Vector2.ZERO:
		if Input.is_action_just_pressed("up"):
			last_pressed_direction = Vector2.UP
		elif Input.is_action_just_pressed("down"):
			last_pressed_direction = Vector2.DOWN
		elif Input.is_action_just_pressed("left"):
			last_pressed_direction = Vector2.LEFT
		elif Input.is_action_just_pressed("right"):
			last_pressed_direction = Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		last_pressed_direction = Vector2.ZERO
		return false
		
	var new_cardinal_direction: Vector2
	# Honor first key press for diagonal movement
	if direction.x != 0 && direction.y != 0:
		# Always use the last_pressed_direction for diagonal movement
		if last_pressed_direction == Vector2.UP || last_pressed_direction == Vector2.DOWN:
			new_cardinal_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
		elif last_pressed_direction == Vector2.LEFT || last_pressed_direction == Vector2.RIGHT:
			new_cardinal_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
		else:
			# Fallback if no last_pressed_direction (shouldn't happen)
			new_cardinal_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
	else:
		# Single direction movement
		if direction.x != 0: 
			new_cardinal_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
		else:
			new_cardinal_direction = Vector2.DOWN if direction.y > 0 else Vector2.UP
	if new_cardinal_direction != cardinal_direction:
		cardinal_direction = new_cardinal_direction
		sprite.scale.x = -1 if cardinal_direction.x < 0 else 1	
		attack_effect_sprite.scale.x = -1 if cardinal_direction.x < 0 else 1
		DirectionChanged.emit(cardinal_direction)
		return true

	return false



func UpdateAnimation(state: String) -> void:
	animation_player.play(state + "_" + AnimateDirection())

func AnimateDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	return "side"
