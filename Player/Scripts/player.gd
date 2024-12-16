# GODOT 4.3.0
class_name Player extends CharacterBody2D
var cardinal_direction: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var move_speed: float = 100.0
var state: String = "idle"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	velocity = direction.normalized() * move_speed
	
	if SetState() or SetDirection():
		UpdateAnimation()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	var new_dir: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_dir = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	elif direction.x == 0:
		new_dir = Vector2.DOWN if direction.y > 0 else Vector2.UP
	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
		sprite.scale.x = 1 if cardinal_direction.x == 1 else -1
		return true
	return false

func SetState() -> bool:
	var new_state: String = "idle" if direction == Vector2.ZERO else "walk"
	if new_state != state:
		state = new_state
		return true
	return false

func UpdateAnimation() -> void:
	animation_player.play(state + "_" + AnimateDirection())
	pass

func AnimateDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	return "side"
