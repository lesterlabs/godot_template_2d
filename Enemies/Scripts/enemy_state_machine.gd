class_name EnemyStateMachine extends Node
var states: Array[EnemyState] = []
var prev_state: EnemyState
var curr_state: EnemyState

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_DISABLED
    pass

func initialize(enemy: Enemy) -> void:
    states = []
    for child in get_children():
        if child is EnemyState:
            states.append(child)
    for state in states:
        state.state_machine = self
        state.enemy = enemy
        state.init()
    if states.size() > 0:
        change_state(states[0])
        process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta: float) -> void:
    change_state(curr_state.process(delta))
    pass

func _physics_process(delta: float) -> void:
    change_state(curr_state.physics_process(delta))
    pass

func change_state(new_state: EnemyState) -> void:
    if new_state == null or new_state == curr_state:
        return
    if prev_state:
        prev_state.exit()
    prev_state = curr_state
    curr_state = new_state
    curr_state.enter()