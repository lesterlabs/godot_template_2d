extends State
class_name State_Walk
@export var move_speed: float = 150.0
@onready var idle_state: State = $"../Idle"
@onready var attack_state: State = $"../Attack"
func Enter() -> void:
	player.UpdateAnimation("walk")

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle_state
	player.velocity = player.direction * move_speed
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("Attack"):
		return attack_state
	return null
