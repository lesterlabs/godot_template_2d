extends State
class_name State_Idle
@onready var walk_state: State = $"../Walk"
@onready var attack_state: State = $"../Attack"
func Enter() -> void:
	player.UpdateAnimation("idle")

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk_state
	player.velocity = Vector2.ZERO
	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("Attack"):
		return attack_state
	return null
