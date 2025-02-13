class_name EnemyState extends Node

var enemy: Enemy
var state_machine: EnemyStateMachine

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass


func process(_delta: float) -> EnemyState:
	return self

func physics_process(_delta: float) -> EnemyState:
	return self
