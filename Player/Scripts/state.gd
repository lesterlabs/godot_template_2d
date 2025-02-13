class_name State extends Node

# Stores a reference to the player that this state belongs to
static var player: Player

func _ready() -> void:
	pass

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Process(_delta: float) -> State:
	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	return null
