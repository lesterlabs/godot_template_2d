class_name PlayerStateMachine extends Node
var states: Array[State] = []
var prev_state: State
var current_state: State

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

func _process(_delta: float) -> void:
	ChangeState(current_state.Process(_delta))
	pass

func _physics_process(_delta: float) -> void:
	ChangeState(current_state.Physics(_delta))

func _unhandled_input(event: InputEvent) -> void:
	ChangeState(current_state.HandleInput(event))

func Initialize( _player: Player) -> void:
	states = []
	for child in get_children():
		if child is State:
			states.append(child)
			child.player = _player
			child.Init()
	
	if states.size() > 0:
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func ChangeState(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		return
	if current_state:
		current_state.Exit()
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
